//
//  MaskFittingViewContainer.swift
//  SmARt
//
//  Created by MacBook on 23.02.21.
//

import SwiftUI
import UIKit

struct MaskFittingSceneViewContainer : UIViewRepresentable {
    @Binding var maskUrl: String
    
    func makeUIView(context: Context) -> MaskFittingSceneKitView {
        let arView = MaskFittingSceneKitView()
        arView.setup(maskUrl)
        return arView
    }

    func updateUIView(_ arView: MaskFittingSceneKitView, context: Context) {
        arView.updateMask(maskUrl)
    }
}
