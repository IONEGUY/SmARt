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
    
    init(viewModel: SectionDetailBaseViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createNavBar(title: String = .empty) {
        super.createNavBar(title: viewModel.title)
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRootView()
        
        viewModel.pushARPage
            .sink(receiveValue: { [unowned self] (sectionType: SectionType) in
                var vc: UIViewController = GeneralARViewController(viewModel:
                    GeneralARViewModel(object3DIds: viewModel.object3DIds,
                                       augmentedObjectType: viewModel.augmentedObjectType))
                switch sectionType {
                case .smartRetail: vc = MaskFittingViewController(viewModel:
                    MaskFittingViewModel(masks: viewModel.masks))
                case .smartRoom: vc = SmartRoomARViewController(viewModel:
                    SmartRoomARViewModel(object3DIds: viewModel.object3DIds,
                                         augmentedObjectType: viewModel.augmentedObjectType))
                case .droneSection: vc = DroneARViewController(viewModel:
                    DroneARViewModel(droneModelId: viewModel.object3DIds[0]))
                case .arDrawing: vc = ARDrawingViewController()
                case .arScanner:
                    let objects = viewModel.allSections.compactMap(\.objects).flatMap { $0 }
                    let modelIds = objects.compactMap(\.object3d?.files?.first?.id)
                    let imageTriggerIds = objects.compactMap(\.trigger).map(\.id)
                    let triggers = Dictionary(uniqueKeysWithValues: zip(imageTriggerIds, modelIds))
                    vc = ARScannerViewController(viewModel: ARScannerViewModel(triggers: triggers))
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
