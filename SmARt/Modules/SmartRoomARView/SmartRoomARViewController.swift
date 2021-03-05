//
//  SmartRoomARViewController.swift
//  SmARt
//
//  Created by MacBook on 3.03.21.
//

import Foundation
import RealityKit
import UIKit
import RealityUI
import SwiftUI
import Combine

class SmartRoomARViewController: UIViewController, ExtendedRealityKitViewDelegate {
    @ObservedObject var viewModel: SmartRoomARViewModel
    var menuAdded = false
    var arView: ExtendedRealityKitView
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: SmartRoomARViewModel) {
        self.viewModel = viewModel
        arView = ExtendedRealityKitView.shared
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createNavBar()
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
        arView.videoPlayers.forEach { $0.pause() }
        arView.videoPlayers = []
        arView.removeFromSuperview()
    }
    
    deinit {
        print("SmartRoomARViewController has been released")
    }
    
    private func createNavBar() {
        let navBar = UIHostingController(rootView: NavBar(object3DButtons: viewModel.object3DButtons) { [unowned self] in
            dismiss(animated: false, completion: nil)
        })
        navBar.view.backgroundColor = .clear
        addChild(navBar)
        view.addSubview(navBar.view)
        navBar.view.translatesAutoresizingMaskIntoConstraints = false
        navBar.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navBar.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        navBar.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        navBar.view.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func doOnTap(_ sender: ExtendedRealityKitView, _ transform: simd_float4x4) {
        (viewModel.augmentedObjectType == .object3D
            ? arView.append3DModel(with: viewModel.current3DObjectUrl, transform, groupName: Self.typeName)
            : arView.appendVideo(viewModel.current3DObjectUrl, transform, groupName: Self.typeName))
            .sink {_ in}
            .store(in: &cancellables)
    }
    
    func entitySelected(_ entity: Entity) {}
}
