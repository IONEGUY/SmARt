//
//  RealityKitViewContainer.swift
//  SmARt
//
//  Created by MacBook on 23.02.21.
//

import Foundation
import Alamofire
import RealityKit
import ARKit
import UIKit
import SwiftUI
import Combine

struct RealityKitViewContainer: UIViewRepresentable {
    @Binding var objectUrl: String
    @State var cancellables = Set<AnyCancellable>()
    
    func makeUIView(context: Context) -> ExtendedRealityKitView {
        let arView = ExtendedRealityKitView()
        arView.setup()
        return arView
    }
    
    func updateUIView(_ uiView: ExtendedRealityKitView, context: Context) {
        uiView.doOnTap = append3DObjectToARView
    }
    
    func append3DObjectToARView(arView: ARView, transform: simd_float4x4) {
        AF.download(objectUrl, method: .get).responseData { response in
            guard let fileName = objectUrl.split(separator: "/").last,
                  let filePath = FileManager.default.urls(
                for: .cachesDirectory,
                in: .userDomainMask).first?.appendingPathComponent("\(fileName).usdz"),
                (try? response.result.get().write(to: filePath)) != nil else { return }

            Entity.loadModelAsync(contentsOf: filePath).sink {_ in}
                receiveValue: { model in
                    model.transform = Transform(matrix: transform)
                    model.scale = SIMD3<Float>(x: 0.01, y: 0.01, z: 0.01)
                    
                    let anchor = AnchorEntity()
                    anchor.addChild(model)
                    anchor.generateCollisionShapes(recursive: true)
                    arView.scene.anchors.append(anchor)
                    arView.installGestures(.all, for: model)
                }
                .store(in: &cancellables)
        }
    }
}
