//
//  DroneARViewControllerContainer.swift
//  SmARt
//
//  Created by MacBook on 26.02.21.
//

import Foundation
import UIKit
import SwiftUI

struct DroneARViewControllerContainer: UIViewControllerRepresentable {
    @State var viewModel: DroneARViewModel
    
    func makeUIViewController(context: Context) -> DroneARViewController {
        return DroneARViewController(viewModel: viewModel)
    }
    
    func updateUIViewController(_ uiViewController: DroneARViewController,
                                context: Context) {}
}
