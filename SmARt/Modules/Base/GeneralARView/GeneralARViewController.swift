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

class GeneralARViewController<ViewModelType: GeneralARViewModel>: BaseViewController, WorldTrackingRealityKitViewDelegate {
    @ObservedObject var viewModel: ViewModelType
    var menuAdded = false
    var arView: WorldTrackingRealityKitView
    
    var objects3DGroupName: String { Self.typeName }
    
    init(viewModel: ViewModelType) {
        self.viewModel = viewModel
        arView = WorldTrackingRealityKitView.shared
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addTakeSnapshotButton(of: arView)
        
        viewModel.$contentLoadingProgress
            .assign(to: \.loadingProgress, on: self)
            .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        view.insertSubview(arView, at: 0)
        arView.fillSuperview()
        arView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        arView.removeGroup(withName: objects3DGroupName)
        arView.releaseResources()
        arView.removeFromSuperview()
    }
    
    func doOnTap(_ sender: WorldTrackingRealityKitView, _ transform: simd_float4x4) {
        (viewModel.augmentedObjectType == .object3D
            ? arView.append3DModel(viewModel.current3DObjectId, transform, groupName: objects3DGroupName)
            : arView.appendVideo(viewModel.current3DObjectId, transform, groupName: objects3DGroupName))
            .sink(receiveValue: handle3DObjectAdded)
            .store(in: &cancellables)
    }
    
    func handle3DObjectAdded(modelEntity: ModelEntity) {}

    func entitySelected(_ entity: Entity) {}
}
