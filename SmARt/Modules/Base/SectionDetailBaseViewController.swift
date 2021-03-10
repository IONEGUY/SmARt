//
//  SectionDetailBaseViewController.swift
//  SmARt
//
//  Created by MacBook on 3.03.21.
//

import Foundation
import RealityKit
import UIKit
import SwiftUI
import Combine

class SectionDetailBaseViewController: UIViewController {
    var viewModel: SectionDetailBaseViewModel
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: SectionDetailBaseViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rootView = UIHostingController(rootView: SectionDetailBaseView(viewModel: viewModel))
        addChild(rootView)
        view.addSubview(rootView.view)
        rootView.view.fillSuperview()
        
        createNavBar()
        
        viewModel.$pushMaskFittingViewActive
            .dropFirst()
            .sink { [unowned self] _ in
                let vc = MaskFittingViewController(viewModel: MaskFittingViewModel(masks: viewModel.masks))
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: false, completion: nil)
            }
            .store(in: &cancellables)
        
        viewModel.$pushSmartRoomARViewActive
            .dropFirst()
            .sink { [unowned self] _ in
                let vc = SmartRoomARViewController(viewModel:
                    SmartRoomARViewModel(object3DIds: viewModel.object3DIds,
                                         augmentedObjectType: viewModel.augmentedObjectType))
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: false, completion: nil)
            }
            .store(in: &cancellables)
        
        viewModel.$pushDroneARViewActive
            .dropFirst()
            .sink { [unowned self] _ in
                let vc = DroneARViewController(viewModel:
                    DroneARViewModel(droneModelId: viewModel.object3DIds.first ?? .empty))
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: false, completion: nil)
            }
            .store(in: &cancellables)
    }
    
    private func createNavBar() {
        let navBar = UIHostingController(rootView:
            NavBar(title: viewModel.title, backButtonAction: { [unowned self] in
            dismiss(animated: false, completion: nil)
        }))
        navBar.view.backgroundColor = .clear
        addChild(navBar)
        view.addSubview(navBar.view)
        navBar.view.translatesAutoresizingMaskIntoConstraints = false
        navBar.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        navBar.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20).isActive = true
        navBar.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20).isActive = true
        navBar.view.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}
