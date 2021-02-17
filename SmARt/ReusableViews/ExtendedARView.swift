//
//  ExtendedARView.swift
//  SmARt
//
//  Created by MacBook on 15.02.21.
//

import Foundation
import ARKit
import SceneKit
import SmartHitTest
import FocusNode

class ExtendedARView: ARSCNView, ARSmartHitTest, ARSCNViewDelegate, ARCoachingOverlayViewDelegate {
    var doOnTap: ((ARSCNView, simd_float4x4) -> ())?
    var nodeSelected: ((SCNNode) -> ())?
    
    private let focusNode = FocusSquare()

    func setup() {
        delegate = self
        
        addFocusNode()
        setupOptimizations()
        addCoaching()
        configueSession()
        addGestureRecognizers()
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        focusNode.updateFocusNode()
    }
    
    func configueSession() {
        autoenablesDefaultLighting = true
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        session.run(configuration)
    }
    
    private func addFocusNode() {
        focusNode.viewDelegate = self
        scene.rootNode.addChildNode(focusNode)
    }
    
    private func setupOptimizations() {
        contentScaleFactor = 0.5 * contentScaleFactor
        rendersMotionBlur = false
    }
    
    private func addCoaching() {
        let coachingOverlay = ARCoachingOverlayView()
        addSubview(coachingOverlay)
        coachingOverlay.fillSuperview()
        coachingOverlay.goal = .horizontalPlane
        coachingOverlay.session = session
        coachingOverlay.delegate = self
    }
    
    private func addGestureRecognizers() {
        let tapRecognizer =
            UITapGestureRecognizer(target: self, action: #selector(handleTapAction))

        addGestureRecognizer(tapRecognizer)
    }
    
    @objc private func handleTapAction(_ sender: UITapGestureRecognizer) {
        let tapPoint = sender.location(in: self)
        doOnTap?(self, getPositionFromRayCast(at: tapPoint))
        if let hitNode = getNodeFromHitTest(at: tapPoint) {
            nodeSelected?(hitNode)
        }
    }
    
    private func getPositionFromRayCast(at point: CGPoint) -> simd_float4x4 {
        guard let raycastQuesry = raycastQuery(from: point,
                                               allowing: .estimatedPlane,
                                               alignment: .horizontal),
              let transform = session.raycast(raycastQuesry).first?.worldTransform
        else { return .init() }
        return transform
    }
    
    private func getNodeFromHitTest(at point: CGPoint)
        -> SCNNode? {
        guard let node = hitTest(point).first?.node.parent else { return nil }
        return node
    }
}
