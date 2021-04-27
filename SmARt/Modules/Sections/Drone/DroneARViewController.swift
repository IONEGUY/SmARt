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
import SwiftUI

class DroneARViewController: GeneralARViewController<DroneARViewModel> {
    private var drone = ModelEntity()

    override var shouldAutorotate: Bool {
        return false
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask(rawValue: UIInterfaceOrientationMask.landscapeRight.rawValue)
    }

    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return UIInterfaceOrientation.landscapeRight
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addJoysticksBar()
        
        viewModel.$objectTransform
            .sink { [unowned self] in drone.transform = $0 }
            .store(in: &cancellables)
    }
    
    private func setOrientation(to orientation: UIInterfaceOrientation) {
        UIView.setAnimationsEnabled(false)
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        UIView.setAnimationsEnabled(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(animated)
        
        setOrientation(to: UIInterfaceOrientation.landscapeRight)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        setOrientation(to: UIInterfaceOrientation.portrait)
    }

    override func handle3DObjectAdded(modelEntity: ModelEntity) {
        modelEntity.transform.rotation = simd_quatf(angle: .pi, axis: [0,1,0])
        drone = modelEntity
        viewModel.objectTransform = modelEntity.transform
    }
        
    private func addJoysticksBar() {
        let joysticksBar = UIHostingController(rootView:
            JoysticksWithMapView(leftJoystickAction: viewModel.leftJoystickAction,
                                 rightJoystickAction: viewModel.rightJoystickAction))
        joysticksBar.view.backgroundColor = .clear
        addChild(joysticksBar)
        view.addSubview(joysticksBar.view)
        joysticksBar.view.translatesAutoresizingMaskIntoConstraints = false
        joysticksBar.view.heightAnchor.constraint(equalToConstant: 120).isActive = true
        joysticksBar.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        joysticksBar.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -30).isActive = true
        joysticksBar.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
    }
}
