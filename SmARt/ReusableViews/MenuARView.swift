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
    @Binding var sectionsList3DItemData: [SectionsList3DItemData]
    var sectionItemSelected: (String) -> Void
    @State var sectionsListAdded = false
    
    private let arView = ExtendedARView()
            
    func makeUIView(context: Context) -> ARView {
        arView.setup()
        arView.doOnTap = populateARView
        arView.entitySelected = {
            guard let entity = $0 as? Menu3DItem else { return }
            sectionItemSelected(entity.name)
        }
        
        return arView
    }

    func updateUIView(_ arView: ARView, context: Context) {

    }
    
    private func populateARView(_ arView: ARView, _ transform: simd_float4x4) {
        if sectionsList3DItemData.isEmpty || sectionsListAdded { return }
        sectionsListAdded.toggle()
        for index in 0...sectionsList3DItemData.count - 1 {
            let model = Menu3DItem()
            model.initData(sectionsList3DItemData[index])
            model.transform = Transform(matrix: transform)
            model.position.y += (Float(index) * 0.1) + (Float(index) * 0.02) + 0.3
            let anchor = AnchorEntity()
            anchor.addChild(model)
            anchor.generateCollisionShapes(recursive: true)
            arView.scene.anchors.append(anchor)
        }
    }
}
