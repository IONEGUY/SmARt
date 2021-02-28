////
////  SectionsList3DItem.swift
////  SmARt
////
////  Created by MacBook on 2/8/21.
////
//
//import Foundation
//import SceneKit
//import ARKit
//import UIKit
//import GLTFSceneKit
//
//class Menu3DItem: SCNNode {
//    func initData(_ menuItemData: MenuItemData) {
//        name = menuItemData.id
//
//        addChildNode(create3DObject(menuItemData.object3DData))
//        DispatchQueue.main.async { [unowned self] in
//            addChildNode(createPlaneInfo(menuItemData.name, menuItemData.description))
//        }
//    }
//
//    private func create3DObject(_ data: Data) -> SCNNode {
//        guard let node = try? GLTFSceneSource(data: data).scene().rootNode
//        else { return SCNNode() }
//
//        node.scale = SCNVector3(x: 0.1, y: 0.1, z: 0.1)
//        node.position.x += -0.18
//        node.position.z += 0.1
//        node.eulerAngles.y = .pi / 2
//        return node
//    }
//
//    private func createPlaneInfo(_ name: String,_ description: String) -> SCNNode {
//        let plane = SCNPlane(width: 0.8, height: 0.2)
//        let image = createPlaneInfoImage(name, description)
//        plane.materials.first?.diffuse.contents = image
//        return SCNNode(geometry: plane)
//    }
//
//    private func createPlaneInfoImage(_ name: String,_ description: String) -> UIImage {
//        let container = UIImageView(frame: CGRect(x: 0, y: 0, width: 400, height: 100))
//
//        container.image = UIImage(named: "container_gradient")
//        container.layer.cornerRadius = 30
//        container.isOpaque = false
//        container.backgroundColor = .black
//
//        let radialGradientImageView =
//            UIImageView(frame: CGRect(x: 0, y: -50, width: 200, height: 200))
//        radialGradientImageView.image = UIImage(named: "radial_gradient")
//        radialGradientImageView.contentMode = .scaleToFill
//
//        let sectionName =
//            UILabel(frame: CGRect(x: 200, y: 10, width: 200, height: 25))
//        sectionName.font = .systemFont(ofSize: 22, weight: .bold)
//        sectionName.textColor = .blue
//        sectionName.text = name
//
//        let sectionDescription =
//            UILabel(frame: CGRect(x: 200, y: 40, width: 180, height: 40))
//        sectionDescription.font = .systemFont(ofSize: 16, weight: .semibold)
//        sectionDescription.textColor = .gray
//        sectionDescription.text = description
//        sectionDescription.lineBreakMode = .byWordWrapping
//        sectionDescription.numberOfLines = 0
//
//        container.addSubview(radialGradientImageView)
//        container.addSubview(sectionName)
//        container.addSubview(sectionDescription)
//
//        return container.toImage()
//    }
//}
