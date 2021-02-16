//
//  ExtendedARView.swift
//  SmARt
//
//  Created by MacBook on 15.02.21.
//

import Foundation
import ARKit
import RealityKit

class ExtendedARView: ARView, ARCoachingOverlayViewDelegate {
    var doOnTap: ((ARView, simd_float4x4) -> ())?
    var entitySelected: ((Entity) -> ())?

    func setup() {
        setupOptimizations()
        addCoaching()
        configueARSceneView()
        addGestureRecognizers()
    }
    
    private func setupOptimizations() {
        contentScaleFactor = 0.50 * contentScaleFactor
        renderOptions = [.disableMotionBlur, .disableAREnvironmentLighting, .disableCameraGrain,
                         .disableDepthOfField, .disableFaceOcclusions, .disableGroundingShadows,
                         .disableHDR, .disablePersonOcclusion]
    }
    
    private func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        addSubview(coachingOverlay)
        coachingOverlay.fillSuperview()
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = session
        coachingOverlay.delegate = self
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
    
    @objc private func handleTapAction(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: self)
        doOnTap?(self, getPositionFromRayCast(at: tapPoint))
        if let hitEntity = entity(at: tapPoint) {
            entitySelected?(hitEntity)
        }
    }
    
    private func getPositionFromRayCast(at point: CGPoint) -> simd_float4x4 {
        let cast = raycast(from: point, allowing: .existingPlaneInfinite, alignment: .horizontal)
        return cast.first?.worldTransform ?? .init(0)
    }
}
