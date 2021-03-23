//
//  ExtendedARSceneView.swift
//  SmARt
//
//  Created by MacBook on 2/9/21.
//

//import Foundation
//import ARKit
//import RealityKit
//import SmartHitTest
//import Combine
//
//class ExtendedARView: ARView, ARSmartHitTest,
//                      ARViewDelegate, ARCoachingOverlayViewDelegate {
//    private var planeVisualizer = SCNNode()
//    private var defaulfPlaneVisualizerYOffset: Float = -0.3
//
//    var doOnTap: ((SCNScene, SCNVector3) -> Void)?
//    var nodeSelected: ((String) -> Void)?
//
//    func setup(_ doOnTap: @escaping (SCNScene, SCNVector3) -> Void) {
//        self.doOnTap = doOnTap
//        delegate = self
//        planeVisualizer = buildPlaneVisualizer()
//        addCoaching()
//        configueARSceneView()
//        addGestureRecognizers()
//    }
//
//    deinit {
//        print("ExtendedARSceneView has been released")
//    }
//
//    func coachingOverlayViewDidDeactivate(_ coachingOverlayView: ARCoachingOverlayView) {
//        planeVisualizer.isHidden = false
//        setPositionToCenterOf(planeVisualizer)
//    }
//
//    func coachingOverlayViewWillActivate(_ coachingOverlayView: ARCoachingOverlayView) {
//        planeVisualizer.isHidden = true
//    }
//
//    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
//        updatePlaneVisualizerPosition()
//    }
//
//    private func addCoaching() {
//        let coachingOverlay = ARCoachingOverlayView()
//        addSubview(coachingOverlay)
//        coachingOverlay.fillSuperview()
//        coachingOverlay.goal = .horizontalPlane
//        coachingOverlay.session = session
//        coachingOverlay.delegate = self
//    }
//
//    private func configueARSceneView() {
//        let configuration = ARWorldTrackingConfiguration()
//        configuration.planeDetection = [.horizontal]
//        session.run(configuration)
//    }
//
//    private func addGestureRecognizers() {
//        let tapRecognizer =
//            UITapGestureRecognizer(target: self, action: #selector(handleTapAction(tapGesture:)))
//
//        addGestureRecognizer(tapRecognizer)
//    }
//
//    private func updatePlaneVisualizerPosition() {
//        setPositionToCenterOf(planeVisualizer)
//    }
//
//    private func setPositionToCenterOf(_ node: SCNNode) {
//        DispatchQueue.main.async { [weak self] in
//            guard let self = self else { return }
//            let center = CGPoint(x: self.bounds.midX, y: self.bounds.midY)
//            self.setNodePositionFromPoint(node: node, point: center)
//        }
//    }
//
//    private func setNodePositionFromPoint(node: SCNNode, point: CGPoint) {
//        guard let raycastQuesry = raycastQuery(from: point,
//                                               allowing: .estimatedPlane,
//                                               alignment: .horizontal),
//              let worldTransform = session.raycast(raycastQuesry).first?.worldTransform
//            else { return }
//        node.position = SCNVector3(worldTransform.columns.3.x,
//                                   worldTransform.columns.3.y,
//                                   worldTransform.columns.3.z)
//        scene.rootNode.addChildNode(node)
//
//    }
//
//    @objc private func handleTapAction(tapGesture: UITapGestureRecognizer) {
//        doOnTap?(scene, planeVisualizer.position)
//        if let node = getNodeFromHitTest(tapGesture) {
//            nodeSelected?(node.id)
//        }
//    }
//
//    private func buildPlaneVisualizer() -> SCNNode {
//        let node = SCNNode()
//        let plane = SCNPlane(width: 0.2, height: 0.2)
//        let material = SCNMaterial()
//        material.diffuse.contents = UIImage(named: "plane")
//        plane.materials = [material]
//        node.geometry = plane
//        node.eulerAngles.x = -Float.pi / 2
//        return node
//    }
//
//    private func getNodeFromHitTest(_ gesture: UIGestureRecognizer)
//        -> SectionsList3DItemNode? {
//        let point = gesture.location(in: self)
//        let node = hitTest(point).first?.node.parent
//        return node as? SectionsList3DItemNode
//    }
//}
