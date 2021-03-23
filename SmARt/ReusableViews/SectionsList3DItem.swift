//
//  SectionsList3DItem.swift
//  SmARt
//
//  Created by MacBook on 2/8/21.
//

import Foundation
import SceneKit
import ARKit
import UIKit
import SwiftUI
import GLTFSceneKit
import Alamofire

class SectionsList3DItemNode: SCNNode {
    var id: String = .empty
    
    func initNode(_ sectionsList3DItemData: SectionsList3DItemData) {
        id = sectionsList3DItemData.id
        let node1 = create2DSectionInfo(sectionsList3DItemData.sectionName,
                                        sectionsList3DItemData.sectionDescription)
        node1.isHidden = true
        addChildNode(node1)
        node1.isHidden = false
        DispatchQueue.global().async { [unowned self] in
            let node2 = create3DSectionObject(sectionsList3DItemData.object3DSource)
            node2.isHidden = true
            addChildNode(node2)
            node2.isHidden = false
        }
    }
    
    private func create2DSectionInfo(_ name: String, _ description: String) -> SCNNode {
        let plane = SCNPlane(width: 0.4, height: 0.1)
        let boxNode = SCNNode(geometry: plane)
        let container = UIImageView(frame: CGRect(x: 0, y: 0, width: 400, height: 100))
        
        container.backgroundColor = .black
        container.layer.cornerRadius = 30
        container.isOpaque = false
        container.image = UIImage(named: "container_gradient.png")
            
        let radialGradientImageView =
            UIImageView(frame: CGRect(x: 30, y: -30, width: 160, height: 160))
        radialGradientImageView.image = UIImage(named: "radial_gradient.png")
        
        let sectionName =
            UILabel(frame: CGRect(x: 200, y: 10, width: 200, height: 25))
        sectionName.font = .systemFont(ofSize: 22, weight: .bold)
        sectionName.textColor = .blue
        sectionName.text = name
        
        let sectionDescription =
            UILabel(frame: CGRect(x: 200, y: 40, width: 180, height: 40))
        sectionDescription.font = .systemFont(ofSize: 16, weight: .semibold)
        sectionDescription.textColor = .gray
        sectionDescription.text = description
        sectionDescription.lineBreakMode = .byWordWrapping
        sectionDescription.numberOfLines = 0
        
        container.addSubview(radialGradientImageView)
        container.addSubview(sectionName)
        container.addSubview(sectionDescription)
                
        boxNode.geometry?.materials.first?.diffuse.contents = container.toImage()

        return boxNode
    }
    
    private func create3DSectionObject(_ nodeSource: String) -> SCNNode {
        let cacheUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!

        guard let directoryContents = try? FileManager.default.contentsOfDirectory(at: cacheUrl, includingPropertiesForKeys: nil),
              let fileUrl = directoryContents.filter
              { nodeSource.contains($0.deletingPathExtension().lastPathComponent) }.first,
              let node = try? GLTFSceneSource(url: fileUrl).scene().rootNode else {
            fatalError("failed to load model from url")
        }
        
        node.scale = SCNVector3(0.05, 0.05, 0.05)
        node.position.x += -0.09
        node.position.z += 0.05
        node.eulerAngles.y = .pi / 2
        return node
    }
}
