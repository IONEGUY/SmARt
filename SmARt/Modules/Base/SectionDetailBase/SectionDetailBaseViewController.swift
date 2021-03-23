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

class SectionDetailBaseViewController: BaseViewController {
    var viewModel: SectionDetailBaseViewModel
    var cancellables = Set<AnyCancellable>()
    
    init(viewModel: SectionDetailBaseViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createNavBar(title: String = .empty, rightButtons: [Object3DButton] = []) {
        super.createNavBar(title: viewModel.title)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRootView()
        
        viewModel.pushARPage
            .sink(receiveValue: { [unowned self] (arPageType: ARPageType) in
                var vc: UIViewController = GeneralARViewController(viewModel:
                    GeneralARViewModel(object3DIds: viewModel.object3DIds,
                                       augmentedObjectType: viewModel.augmentedObjectType))
                switch arPageType {
                case .maskFittingPage:
                    vc = MaskFittingViewController(viewModel: MaskFittingViewModel(masks: viewModel.masks))
                case .dronePage:
                    vc = DroneARViewController(viewModel: DroneARViewModel(droneModelId: viewModel.object3DIds[0]))
                case .arDrawingPage: vc = ARDrawingViewController()
                default: break
                }
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: false, completion: nil)
            })
            .store(in: &cancellables)
    }
    
    private func addRootView() {
        let rootView = UIHostingController(rootView: SectionDetailBaseView(viewModel: viewModel))
        addChild(rootView)
        view.insertSubview(rootView.view, at: 0)
        rootView.view.fillSuperview()
    }
}
