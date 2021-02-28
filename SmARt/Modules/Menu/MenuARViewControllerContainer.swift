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

struct MenuARViewControllerContainer: UIViewControllerRepresentable {
    @State var viewModel: MenuViewModel
                
    func makeUIViewController(context: Context) -> MenuARViewController {
        return MenuARViewController(viewModel: viewModel)
    }

    func updateUIViewController(_ uiViewController: MenuARViewController, context: Context) {}
}
