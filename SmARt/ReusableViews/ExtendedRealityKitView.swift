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
import FocusEntity

class ExtendedRealityKitView: ARView, FocusEntityDelegate, ARCoachingOverlayViewDelegate {
    private var focusEntity: FocusEntity?
    private var cancellables = Set<AnyCancellable>()
    private var resources: [Disposable] = []
    
    var delegate: ExtendedRealityKitViewDelegate?
    static var shared = ExtendedRealityKitView()
    
    func setup() {
        configueARSession()
        setupOptimizations()
        setupFocusEntity()
        addCoaching()
        addGestureRecognizers()
        createLightingAnchor()
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
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        session.run(configuration)
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

private class DefaultLightingEntity: Entity, HasPointLight {
    required init() {
        super.init()
  
        light = PointLightComponent(color: .white, intensity: 60000)
    }
}
