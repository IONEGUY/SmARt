//
//  ExtendedRealityKitView.swift
//  SmARt
//
//  Created by MacBook on 23.02.21.
//

import Foundation
import ARKit
import RealityKit
import Alamofire
import Combine

class WorldTrackingRealityKitView: ARView, ARSessionDelegate {
    private let defaultZOffset: Float = -1.5
    private let defaultContentScaleFactorMultiplier: CGFloat = 0.5
    private let videoPlaneWidth: Float = 1
    private let videoPlaneHeight: Float = 0.5
    
    private var cancellables = Set<AnyCancellable>()
    private var disposables: [Disposable] = []
    private var coachingOverlay = ARCoachingOverlayView()
    
    private var interactionsEnadled = true
    private var trackingImages: [UIImage: String] = [:]
    private var hologramAnchors: [String : HasAnchoring] = [:]
    
    var delegate: WorldTrackingRealityKitViewDelegate?
    static var shared = WorldTrackingRealityKitView()
    
    func setup() {
        configueARSession()
        setupOptimizations()
        addGestureRecognizers()
        createLightingAnchor()
    }
    
    func releaseResources() {
        disposables.forEach { $0.dispose() }
        disposables = []
        hologramAnchors = [:]
    }
    
    func addToGroup(withName name: String, anchor: HasAnchoring) {
        var groupAnchor = getGroupAnchor(name)
        if groupAnchor == nil {
            groupAnchor = AnchorEntity()
            groupAnchor?.name = name
            scene.anchors.append(groupAnchor ?? AnchorEntity())
        }
        
        groupAnchor?.addChild(anchor)
    }
    
    func hideGroup(withName name: String) {
        getGroupAnchor(name)?.isEnabled = false
    }
    
    func showGroup(withName name: String) {
        getGroupAnchor(name)?.isEnabled = true
    }
    
    func removeGroup(withName name: String) {
        getGroupAnchor(name)?.removeFromParent()
    }

    func configueARSession() {
        interactionsEnadled = true
        session.delegate = self
        let configuration = ARWorldTrackingConfiguration()
        session.run(configuration, options: [.removeExistingAnchors, .resetTracking])
    }
    
    func configueImageTrackingARSession(trackingImages: [UIImage: String]) {
        interactionsEnadled = false
        self.trackingImages = trackingImages
        let referenceImages: [ARReferenceImage] = trackingImages.keys.compactMap {
            guard let cgImage = $0.cgImage else { return nil }
            let referenceImage = ARReferenceImage(cgImage, orientation: .down, physicalWidth: 0.2)
            referenceImage.name = $0.accessibilityIdentifier ?? .empty
            return referenceImage
        }

        let config = ARImageTrackingConfiguration()
        config.trackingImages = Set(referenceImages)
        config.maximumNumberOfTrackedImages = referenceImages.count
        session.delegate = self
        session.run(config, options: [.removeExistingAnchors, .resetTracking])
    }
    
    func session(_ session: ARSession, didAdd anchors: [ARAnchor]) {
        anchors
            .compactMap { $0 as? ARImageAnchor }
            .forEach { [unowned self] imageAnchor in
                guard let imageAnchorName = imageAnchor.referenceImage.name,
                      let image = trackingImages.keys.first(where:
                          { $0.accessibilityIdentifier == imageAnchorName }),
                      let modelId = trackingImages[image]
                      else { return }

                attach3DModelToImageAnchor(modelId, imageAnchor, imageAnchorName)
            }
    }
    
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        anchors
            .compactMap { $0 as? ARImageAnchor }
            .forEach { [unowned self] imageAnchor in
                guard let imageAnchorName = imageAnchor.referenceImage.name,
                      let hologramAnchor = hologramAnchors[imageAnchorName]
                else { return }
                
                hologramAnchor.isEnabled = imageAnchor.isTracked
                hologramAnchor.transform = Transform(matrix: imageAnchor.transform)
                scene.anchors.append(hologramAnchor)
            }
    }

    func createLightingAnchor() {
        let lightAnchor = AnchorEntity()
        lightAnchor.addChild(DefaultLightingEntity())
        scene.anchors.append(lightAnchor)
    }
    
    func appendVideo(_ id: String, _ transform: simd_float4x4, groupName: String? = nil) -> AnyPublisher<ModelEntity, Never> {
        AnyPublisher.create { [unowned self] observer in
            if scene.findEntity(named: id) != nil { return .init(dispose: {}) }
            
            let url = URL.constructFilePath(withName: "\(id).mp4")
            
            let videoPlayer = AVPlayer(playerItem: AVPlayerItem(url: url))
            disposables.append(Disposable(dispose: { videoPlayer.isMuted = true }))

            let videoPlane = ModelEntity(mesh: .generatePlane(width: videoPlaneWidth,
                                                              height: videoPlaneHeight),
                                         materials: [VideoMaterial(avPlayer: videoPlayer)])
            videoPlayer.play()
            addAnchorToARView(transform, videoPlane, id, groupName)
            
            observer.onNext(videoPlane)
            observer.onComplete()
            
            return .init(dispose: {})
        }
    }
    
    func append3DModel(_ id: String, _ transform: simd_float4x4, groupName: String? = nil) -> AnyPublisher<ModelEntity, Never> {
        AnyPublisher.create { [unowned self] observer in
            if scene.findEntity(named: id) != nil { return .init(dispose: {}) }
            
            let filePath = URL.constructFilePath(withName: "\(id).usdz")
            Entity.loadModelAsync(contentsOf: filePath).sink {_ in}
                receiveValue: { [unowned self] model in
                    addAnchorToARView(transform, model, id, groupName)
                    model.availableAnimations.forEach { model.playAnimation($0.repeat()) }
                    observer.onNext(model)
                    observer.onComplete()
                }
                .store(in: &cancellables)
            return .init(dispose: {})
        }
    }
    
    private func attach3DModelToImageAnchor(_ modelId: String, _ imageAnchor: ARImageAnchor, _ imageAnchorName: String) {
        append3DModel(modelId, imageAnchor.transform, groupName: "Holograms")
            .sink { [unowned self] model in
                let modelVisualBounds = model.visualBounds(relativeTo: model)
                let min = modelVisualBounds.min
                let max = modelVisualBounds.max
                let modelWidth = CGFloat(max.x - min.x)
                let imageWidth = imageAnchor.referenceImage.physicalSize.width
                let scaleFactor = imageWidth / modelWidth
                model.scale = SIMD3<Float>(SCNVector3(scaleFactor, scaleFactor, scaleFactor))
                hologramAnchors[imageAnchorName] = model.anchor
            }
            .store(in: &cancellables)
    }
    
    private func getGroupAnchor(_ name: String) -> HasAnchoring? {
        return scene.anchors.first(where: { $0.name == name })
    }
    
    private func setupOptimizations() {
        contentScaleFactor = defaultContentScaleFactorMultiplier * contentScaleFactor
        renderOptions = [.disableMotionBlur, .disableAREnvironmentLighting,
                         .disableCameraGrain, .disableDepthOfField,
                         .disableFaceOcclusions, .disableGroundingShadows,
                         .disableHDR, .disablePersonOcclusion]
    }
    
    private func addGestureRecognizers() {
        addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                    action: #selector(handleTapAction)))
    }
    
    private func addAnchorToARView(_ transform: simd_float4x4, _ model: ModelEntity, _ name: String, _ groupName: String? = nil) {
        let anchor = AnchorEntity()
        anchor.transform = Transform(matrix: transform)
        model.name = name
        anchor.name = name
        anchor.addChild(model)
        
        if let groupName = groupName {
            addToGroup(withName: groupName, anchor: anchor)
        } else {
            scene.anchors.append(anchor)
        }
    }
    
    @objc private func handleTapAction(_ sender: UITapGestureRecognizer) {
        if !interactionsEnadled { return }
        if let currentFrame = session.currentFrame {
            var translation = matrix_identity_float4x4
            translation.columns.3.z = defaultZOffset
            let transformMatrix = simd_mul(currentFrame.camera.transform, translation)
            var transform = Transform(matrix: transformMatrix)
            transform.rotation = simd_quatf(angle: currentFrame.camera.eulerAngles.y, axis: SIMD3<Float>(0, 1, 0))
            delegate?.doOnTap(self, transform.matrix)
        }

        let tapPoint = sender.location(in: self)
        let hit = hitTest(tapPoint).first
        if let tappedEntity = hit?.entity {
            delegate?.entitySelected(tappedEntity)
        }
    }
}

private class DefaultLightingEntity: Entity, HasPointLight {
    required init() {
        super.init()
  
        light = PointLightComponent(color: .white, intensity: 60000)
    }
}
