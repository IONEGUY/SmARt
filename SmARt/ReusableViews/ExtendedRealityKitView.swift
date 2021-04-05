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

class ExtendedRealityKitView: ARView, ARSessionDelegate {
    private let defaultZOffset: Float = 1.5
    private let defaultYOffset: Float = 0.5
    private let defaultContentScaleFactorMultiplier: CGFloat = 0.5
    
    private var cancellables = Set<AnyCancellable>()
    private var resources: [Disposable] = []
    private var cameraPlane = ModelEntity(mesh: .generatePlane(width: 0.05, height: 0.05),
                                          materials: [SimpleMaterial(color: .clear,
                                                                     roughness: 1.0,
                                                                     isMetallic: true)])
    
    var delegate: ExtendedRealityKitViewDelegate?
    static var shared = ExtendedRealityKitView()
    
    func setup() {
        configueARSession()
        setupOptimizations()
        addGestureRecognizers()
        createLightingAnchor()
        createCameraPoint()
    }
    
    func releaseResources() {
        resources.forEach { $0.dispose() }
        resources = []
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
        session.delegate = self
        automaticallyConfigureSession = true
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
            resources.append(Disposable(dispose: { videoPlayer.pause() }))

            let videoPlane = ModelEntity(mesh: .generatePlane(width: 1.6, height: 0.9),
                                         materials: [VideoMaterial(avPlayer: videoPlayer)])
            
            addAnchorToARView(transform, videoPlane, id, groupName)
            
            observer.onNext(videoPlane)
            
            videoPlayer.play()
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
                }
                .store(in: &cancellables)
            return .init(dispose: {})
        }
    }
    
    private func createCameraPoint() {
        let cameraAnchor = AnchorEntity(.camera)
        cameraPlane.name = "cameraPlane"
        cameraPlane.generateCollisionShapes(recursive: true)
        cameraAnchor.addChild(cameraPlane)
        cameraAnchor.transform.translation.z -= defaultZOffset
        scene.anchors.append(cameraAnchor)
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
        let anchor = AnchorEntity(.world(transform: transform))
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
        let centerHit = hitTest(center, mask: .all).first(where: { $0.entity.name == "cameraPlane" })
        if let centerHit = centerHit,
           let camera = session.currentFrame?.camera {
            let cameraTransform = Transform(matrix: camera.transform)
            var transform = Transform(scale: SIMD3<Float>(x: 1, y: 1, z: 1),
                                      rotation: cameraTransform.rotation,
                                      translation: centerHit.position)
            transform.rotation = simd_quatf(angle: camera.eulerAngles.y, axis: SIMD3<Float>(0, 1, 0))
            transform.translation.y -= defaultYOffset
            delegate?.doOnTap(self, transform.matrix)
        }

        let tapPoint = sender.location(in: self)
        let hit = hitTest(tapPoint, mask: .all).first
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
