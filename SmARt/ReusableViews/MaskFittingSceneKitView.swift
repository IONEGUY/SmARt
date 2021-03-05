//
//  MaskFittingView.swift
//  SmARt
//
//  Created by MacBook on 23.02.21.
//

import UIKit
import ARKit
import SceneKit
import Kingfisher

class MaskFittingSceneKitView: ARSCNView, ARSCNViewDelegate {
    private var faceNode = SCNNode()
    
    private var defaultMask: String = .empty
    
    func setup(_ defaultMask: String) {
        delegate = self

        self.defaultMask = defaultMask
        
        configueARSceneView()
    }
    
    deinit {
        print("MaskFittingSceneKitView released")
    }
    
    private func configueARSceneView() {
        let configuration = ARFaceTrackingConfiguration()
        session.run(configuration)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = device else { return nil }
        
        let faceGeometry = ARSCNFaceGeometry(device: device, fillMesh: true)
        faceNode.geometry = faceGeometry
        updateMask(defaultMask)
        return faceNode
    }
    
    func updateMask(_ mask: String) {
        DispatchQueue.main.async { [unowned self] in
            let imageView = UIImageView()
            imageView.kf.setImage(with: URL(string: mask))
            faceNode.geometry?.firstMaterial?.diffuse.contents = imageView.image
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
              let faceGeometry = node.geometry as? ARSCNFaceGeometry
        else { return }

        faceGeometry.update(from: faceAnchor.geometry)
    }
}
