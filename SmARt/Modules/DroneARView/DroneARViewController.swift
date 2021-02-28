//
//  DroneARViewController.swift
//  SmARt
//
//  Created by MacBook on 26.02.21.
//

import Foundation
import UIKit
import Combine
import RealityKit

class DroneARViewController: UIViewController, ExtendedRealityKitViewDelegate {
    var viewModel: DroneARViewModel
    
    private var cancellabes = Set<AnyCancellable>()
    private var drone = ModelEntity()
    
    init(viewModel: DroneARViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let arView = ExtendedRealityKitView()
        view.addSubview(arView)
        arView.setup()
        arView.fillSuperview()
        
        arView.delegate = self
        
        viewModel.$objectTransform.sink { [unowned self] in
            drone.transform = $0
        }.store(in: &cancellabes)
    }
    
    func doOnTap(_ arView: ExtendedRealityKitView, _ transform: simd_float4x4) {
        arView.append3DModel(with: viewModel.droneModelUrl, transform)
            .sink { [unowned self] in
                drone = $0
                viewModel.objectTransform = $0.transform
            }.store(in: &cancellabes)
    }
    
    func entitySelected(_ entity: Entity) {}
}
