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

class ExtendedRealityKitView: ARView, FocusEntityDelegate, ARCoachingOverlayViewDelegate {
    var delegate: ExtendedRealityKitViewDelegate?
    var focusEntity: FocusEntity?
    var cancellables = Set<AnyCancellable>()
    var videoPlayers: [AVPlayer] = []
    
    static var shared = ExtendedRealityKitView()
    
    func setup() {
        configueARSession()
        setupOptimizations()
        setupFocusEntity()
        addCoaching()
        addGestureRecognizers()
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
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        session.run(configuration)
    }
    
    func createLightingAnchor(_ position: SIMD3<Float>) -> HasAnchoring {
        let lightAnchor = AnchorEntity()
        lightAnchor.addChild(DefaultLightingEntity())
        lightAnchor.transform.translation = position
        return lightAnchor
    }
    
    private func getGroupAnchor(_ name: String) -> HasAnchoring? {
        return scene.anchors.first(where: { $0.name == name })
    }
    
    private func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        addSubview(coachingOverlay)
        coachingOverlay.fillSuperview()
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = session
        coachingOverlay.delegate = self
    }

    private func setupFocusEntity() {
        focusEntity = FocusEntity(on: self, focus: .classic)
    }
    
    private func setupOptimizations() {
        contentScaleFactor = 0.50 * contentScaleFactor
        renderOptions = [.disableMotionBlur, .disableAREnvironmentLighting,
                         .disableCameraGrain, .disableDepthOfField,
                         .disableFaceOcclusions, .disableGroundingShadows,
                         .disableHDR, .disablePersonOcclusion]
    }
    
    private func addGestureRecognizers() {
        let tapRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(handleTapAction))

        addGestureRecognizer(tapRecognizer)
    }
    
    func appendVideo(_ url: String, _ transform: simd_float4x4, groupName: String? = nil) -> AnyPublisher<ModelEntity, Never> {
        AnyPublisher.create { [unowned self] observer in
            if scene.findEntity(named: url) != nil { return .init(dispose: {}) }
            
            guard let videoURL = URL(string: url) else { return Disposable(dispose: {}) }
            
            let videoPlayer = AVPlayer(playerItem: AVPlayerItem(url: videoURL))
            videoPlayers.append(videoPlayer)

            let videoPlane = ModelEntity(mesh: .generatePlane(width: 1.6, height: 0.9),
                                         materials: [VideoMaterial(avPlayer: videoPlayer)])
            videoPlane.transform.translation = transform.translation
            videoPlane.transform.rotation = Transform(matrix: transform).rotation
            
            let anchor = AnchorEntity(plane: .horizontal)
            addAnchorToARView(anchor, videoPlane, url, groupName)
            
            observer.onNext(videoPlane)
            
            videoPlayer.play()
            return .init(dispose: {})
        }
    }
    
    func append3DModel(with url: String, _ transform: simd_float4x4, groupName: String? = nil) -> AnyPublisher<ModelEntity, Never> {
        AnyPublisher.create { [unowned self] observer in
            if scene.findEntity(named: url) != nil { return .init(dispose: {}) }
            
            let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
            guard let object3DName = url.split(separator: "/").last,
                  let filePath = cacheDirectory?.appendingPathComponent("\(object3DName).usdz")
            else { fatalError("cannot retrieve file with 3d model") }
            
            Entity.loadModelAsync(contentsOf: filePath).sink {_ in}
                receiveValue: { [unowned self] model in
                    model.transform.translation = transform.translation
                    model.transform.rotation = Transform(matrix: transform).rotation
                    
                    let anchor = AnchorEntity()
                    addAnchorToARView(anchor, model, url, groupName)
                    model.availableAnimations.forEach { model.playAnimation($0.repeat()) }
                    observer.onNext(model)
                }
                .store(in: &cancellables)
            return .init(dispose: {})
        }
    }
    
    private func addAnchorToARView(_ anchor: AnchorEntity, _ model: ModelEntity, _ name: String, _ groupName: String? = nil) {
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
        let tapPoint = sender.location(in: self)
        delegate?.doOnTap(self, getPositionFromRayCast(at: tapPoint))
        
        let hit = hitTest(tapPoint, mask: .all).first
        let tappedEntity = hit?.entity        
        if tappedEntity != nil {
            delegate?.entitySelected(tappedEntity!)
        }
    }
    
    private func getPositionFromRayCast(at point: CGPoint) -> simd_float4x4 {
        let cast = raycast(from: point, allowing: .existingPlaneInfinite, alignment: .horizontal)
        return cast.first?.worldTransform ?? .init(0)
    }
}

protocol ExtendedRealityKitViewDelegate {
    func doOnTap(_ sender: ExtendedRealityKitView, _ transform: simd_float4x4)
    func entitySelected(_ entity: Entity)
}

class DefaultLightingEntity: Entity, HasPointLight {
    required init() {
        super.init()
  
        light = PointLightComponent(color: .white, intensity: 50000)
    }
}
