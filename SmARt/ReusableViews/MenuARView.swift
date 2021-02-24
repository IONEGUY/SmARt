//
//  ARSceneView.swift
//  SmARt
//
//  Created by MacBook on 2/8/21.
//

import Foundation
import SwiftUI
import UIKit
import ARKit
import RealityKit
import Combine
import Closures

struct MenuARView: UIViewRepresentable {
    @Binding var menuItems: [MenuItemData]
    @State var menuAdded = false
    @Binding var onMenuItemSelected: PassthroughSubject<String, Never>
                
    func makeUIView(context: Context) -> ExtendedSceneKitView {
        let arView = ExtendedSceneKitView()
        arView.setup()
        return arView
    }

    func updateUIView(_ arView: ExtendedSceneKitView, context: Context) {
        arView.configueSession()
        arView.doOnTap = populateARView
        arView.nodeSelected = {
            guard let nodeName = ($0 as? Menu3DItem)?.name else { return }
            onMenuItemSelected.send(nodeName)
        }
    }
    
    private func populateARView(_ arView: ARSCNView, _ transform: simd_float4x4) {
        if menuItems.isEmpty || menuAdded { return }
        menuAdded.toggle()
        
        var nodes: [SCNNode] = []
        let dispatchGroup = DispatchGroup()
        
        for index in 0...menuItems.count - 1 {
            dispatchGroup.enter()
            
            let node = Menu3DItem()
            node.initData(menuItems[index])
            node.transform = SCNMatrix4(transform)
            node.position.y += (Float(index) * 0.2) + (Float(index) * 0.04) + 0.1
            nodes.append(node)
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global(qos: .background)) {
            nodes.forEach { arView.scene.rootNode.addChildNode($0) }
        }
    }
}
