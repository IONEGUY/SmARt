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

class DroneARViewController: UIViewController, ExtendedRealityKitViewDelegate {
    var viewModel: DroneARViewModel
    
    private var cancellabes = Set<AnyCancellable>()
    private var drone = ModelEntity()
    private var arView: ExtendedRealityKitView
    
    init(viewModel: DroneARViewModel) {
        self.viewModel = viewModel
        
        arView = ExtendedRealityKitView.shared
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        createNavBar()
        addJoysticksBar()
        
        viewModel.$objectTransform.sink { [unowned self] in
            drone.transform = $0
        }.store(in: &cancellabes)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.insertSubview(arView, at: 0)
        arView.fillSuperview()
        arView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        arView.removeGroup(withName: Self.typeName)
        arView.removeFromSuperview()
        
        setOrientation(to: UIInterfaceOrientation.portrait)
    }
    
    func doOnTap(_ arView: ExtendedRealityKitView, _ transform: simd_float4x4) {
        arView.append3DModel(viewModel.droneModelId, transform, groupName: Self.typeName)
            .sink { [unowned self] in
                $0.transform.rotation = simd_quatf(angle: .pi / 2, axis: [0,1,0])
                drone = $0
                viewModel.objectTransform = $0.transform
            }.store(in: &cancellabes)
    }
    
    func entitySelected(_ entity: Entity) {}
    
    private func createNavBar() {
        let navBar = UIHostingController(rootView: NavBar(backButtonAction: { [unowned self] in
            dismiss(animated: false, completion: nil)
        }))
        navBar.view.backgroundColor = .clear
        addChild(navBar)
        view.addSubview(navBar.view)
        navBar.view.translatesAutoresizingMaskIntoConstraints = false
        navBar.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        navBar.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        navBar.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        navBar.view.heightAnchor.constraint(equalToConstant: 60).isActive = true
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
