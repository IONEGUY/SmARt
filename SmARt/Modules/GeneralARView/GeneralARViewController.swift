//
//  SmartRoomARViewController.swift
//  SmARt
//
//  Created by MacBook on 3.03.21.
//

import Foundation
import RealityKit
import UIKit
import SwiftUI
import Combine

class GeneralARViewController: BaseViewController, ExtendedRealityKitViewDelegate {
    @ObservedObject var viewModel: GeneralARViewModel
    var menuAdded = false
    var arView: ExtendedRealityKitView
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: GeneralARViewModel) {
        self.viewModel = viewModel
        arView = ExtendedRealityKitView.shared
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.insertSubview(arView, at: 0)
        arView.fillSuperview()
        arView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        arView.removeGroup(withName: Self.typeName)
        arView.releaseResources()
        arView.removeFromSuperview()
    }
    
    func doOnTap(_ sender: ExtendedRealityKitView, _ transform: simd_float4x4) {
        (viewModel.augmentedObjectType == .object3D
            ? arView.append3DModel(viewModel.current3DObjectId, transform, groupName: Self.typeName)
            : arView.appendVideo(viewModel.current3DObjectId, transform, groupName: Self.typeName))
            .sink {_ in}
            .store(in: &cancellables)
    }
    
    func entitySelected(_ entity: Entity) {}
}
