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

class ExtendedRealityKitView: ARView, FocusEntityDelegate {
    var delegate: ExtendedRealityKitViewDelegate?
    var focusEntity: FocusEntity?
    
    var cancellables = Set<AnyCancellable>()
    
    func setup() {
        setupOptimizations()
        setupFocusEntity()
        configueARSceneView()
        addGestureRecognizers()
    }
    
    private func setupFocusEntity() {
        focusEntity = FocusEntity(on: self, focus: .classic)
    }
    
    private func setupOptimizations() {
        contentScaleFactor = 0.50 * contentScaleFactor
        renderOptions = [.disableMotionBlur, .disableAREnvironmentLighting,
                         .disableCameraGrain, .disableDepthOfField, .disableFaceOcclusions, .disableGroundingShadows,
                         .disableHDR, .disablePersonOcclusion]
    }

    private func configueARSceneView() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        session.run(configuration)
    }
    
    private func addGestureRecognizers() {
        let tapRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(handleTapAction))

        addGestureRecognizer(tapRecognizer)
    }
    
    func appendVideo(_ url: String, _ transform: simd_float4x4) -> AnyPublisher<ModelEntity, Never> {
        AnyPublisher.create { [unowned self] observer in
            if scene.findEntity(named: url) != nil { observer.onComplete() }
            
            guard let videoURL = URL(string: url) else { return Disposable(dispose: {}) }
            
            let videoPlayer = AVPlayer(playerItem: AVPlayerItem(url: videoURL))

            let videoPlane = ModelEntity(mesh: .generatePlane(width: 1.6, height: 0.9),
                                         materials: [VideoMaterial(avPlayer: videoPlayer)])

            let anchor = AnchorEntity(plane: .horizontal)
            
            addAnchorToARView(anchor, videoPlane, url)
            observer.onNext(videoPlane)
            
            videoPlayer.play()
            return Disposable(dispose: {})
        }
    }
    
    func append3DModel(_ url: String, _ transform: simd_float4x4) -> AnyPublisher<ModelEntity, Never> {
        AnyPublisher.create { [unowned self] observer in
            if scene.findEntity(named: url) != nil { observer.onComplete() }
            AF.download(url, method: .get).responseData { [unowned self] response in
                guard let fileName = url.split(separator: "/").last,
                      let filePath = FileManager.default.urls(
                        for: .cachesDirectory,
                        in: .userDomainMask).first?.appendingPathComponent("\(fileName).usdz"),
                      (try? response.result.get().write(to: filePath)) != nil else { return }
                
                Entity.loadModelAsync(contentsOf: filePath).sink {_ in}
                    receiveValue: { [unowned self] model in
                        model.transform = Transform(matrix: transform)
                        model.scale = SIMD3<Float>(x: 0.01, y: 0.01, z: 0.01)
                        
                        let anchor = AnchorEntity()
                        addAnchorToARView(anchor, model, url)
                        observer.onNext(model)
                    }
                    .store(in: &cancellables)
            }
            return Disposable(dispose: {})
        }
    }
    
    private func addAnchorToARView(_ anchor: AnchorEntity, _ model: ModelEntity, _ name: String) {
//        objectTransform = model.transform
//        currentModel = model
        model.name = name
        anchor.addChild(model)
        scene.anchors.append(anchor)
    }
    
    @objc private func handleTapAction(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: self)
        delegate?.doOnTap(self, getPositionFromRayCast(at: tapPoint))
        if let hitEntity = entity(at: tapPoint) {
            delegate?.entitySelected(hitEntity)
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
