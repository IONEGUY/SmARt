//
//  ARDrawingViewController.swift
//  SmARt
//
//  Created by MacBook on 18.03.21.
//

import Foundation
import UIKit
import SwiftUI
import SceneKit
import ARKit

class ARDrawingViewController: BaseViewController, ARSCNViewDelegate {
    private lazy var drawingPlaneNode = SCNNode()
    private lazy var sceneView = ARSCNView()
    private var previousPoint: SCNVector3?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        ExtendedRealityKitView.shared.session.pause()
        
        configureSceneView()
        addProposalForInteractionMessage(withTitle: "Touch and drow")
        configueDrawingPlaneNode()
        
        sceneView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture)))
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
        ExtendedRealityKitView.shared.configueARSession()
    }

    private func configureSceneView() {
        sceneView.delegate = self
        let scene = SCNScene(named: "art.scnassets/world.scn")!
        sceneView.scene = scene
        sceneView.contentScaleFactor *= 0.5
        view.insertSubview(sceneView, at: 0)
        sceneView.fillSuperview()
        sceneView.session.run(ARWorldTrackingConfiguration())
    }
    
    private func configueDrawingPlaneNode() {
        let drawingPlane = SCNPlane(width: 1, height: 1)
        drawingPlane.firstMaterial?.diffuse.contents = UIColor.clear
        drawingPlaneNode = SCNNode(geometry: drawingPlane)
        drawingPlaneNode.name = "drawingPlaneNode"
        sceneView.scene.rootNode.addChildNode(drawingPlaneNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else { return }
        
        let mat = pointOfView.transform
        let dir = SCNVector3(-1 * mat.m31, -1 * mat.m32, -1 * mat.m33)
        let currentPosition = pointOfView.position + (dir * 0.3)
        
        drawingPlaneNode.position = currentPosition
        drawingPlaneNode.eulerAngles = pointOfView.eulerAngles
        
        sceneView.scene.rootNode.addChildNode(drawingPlaneNode)
    }
    
    @objc private func handlePanGesture(_ pan: UIPanGestureRecognizer) {
        removeProposalForInteractionMessage()
        let location: CGPoint = pan.location(in: sceneView)
        let hits = self.sceneView.hitTest(location, options: nil)
        guard let hitTest = hits.last else { return }
        
        let tappednode = hitTest.node
        let currentPosition = hitTest.worldCoordinates

        if pan.state == .ended {
            previousPoint = nil
            return
        }
        
        if tappednode.name == "drawingPlaneNode", let previousPoint = previousPoint {
            drawLine(leadingPoint: previousPoint, trailingPoint: currentPosition)
        }
        
        previousPoint = currentPosition
    }
    
    private func drawLine(leadingPoint: SCNVector3, trailingPoint: SCNVector3) {
        let distance = SCNVector3.distance(between: leadingPoint, and: trailingPoint)
        let cylinder = SCNCylinder(radius: 0.005, height: CGFloat(distance))
        cylinder.radialSegmentCount = 10
        cylinder.firstMaterial?.diffuse.contents = UIColor.white

        let lineNode = SCNNode(geometry: cylinder)
        lineNode.position = .center(of: leadingPoint, and: trailingPoint)
        lineNode.eulerAngles = .eulerAngle(between: leadingPoint, and: trailingPoint, distance: distance)
        sceneView.scene.rootNode.addChildNode(lineNode)
        
        addSphere(at: leadingPoint)
        addSphere(at: trailingPoint)
    }
    
    private func addSphere(at position: SCNVector3) {
        let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.005))
        sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.white
        sphereNode.position = position
        sceneView.scene.rootNode.addChildNode(sphereNode)
    }
}
