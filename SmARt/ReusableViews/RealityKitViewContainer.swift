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

struct RealityKitViewContainer: UIViewRepresentable, ExtendedRealityKitViewDelegate {
    @State var cancellables = Set<AnyCancellable>()
    
    @Binding var objectUrl: String
    @Binding var objectType: AugmentedObjectType
        
    func makeUIView(context: Context) -> ExtendedRealityKitView {
        let arView = ExtendedRealityKitView()
        arView.delegate = self
        arView.setup()
        
        return arView
    }
    
    func updateUIView(_ uiView: ExtendedRealityKitView, context: Context) {}
    
    func doOnTap(_ arView: ExtendedRealityKitView, _ transform: simd_float4x4) {
        (objectType == .video
            ? arView.appendVideo(objectUrl, transform)
            : arView.append3DModel(with: objectUrl, transform))
            .sink(receiveValue: {_ in})
            .store(in: &cancellables)
    }
    
    func entitySelected(_ entity: Entity) {}
}
