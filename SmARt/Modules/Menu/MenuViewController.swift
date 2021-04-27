//
//  MenuARViewController.swift
//  SmARt
//
//  Created by MacBook on 27.02.21.
//

import Foundation
import RealityKit
import UIKit
import SwiftUI
import Combine

class MenuViewController: BaseViewController, WorldTrackingRealityKitViewDelegate {
    let menuYOffset: Float = 1
    let menuItemsSpacing: Float = 0.25
    
    private var viewModel: MenuViewModel
    private var menuAdded = false
    private var arView: WorldTrackingRealityKitView
    override var isNavigationBarVisible: Bool { return false }

    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
        
        WorldTrackingRealityKitView.shared.setup()
        arView = WorldTrackingRealityKitView.shared
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.$contentLoadingProgress
            .assign(to: \.loadingProgress, on: self)
            .store(in: &cancellables)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        arView.configueARSession()
        arView.showGroup(withName: Self.typeName)
        view.insertSubview(arView, at: 0)
        arView.fillSuperview()
        arView.delegate = self
        
        addProposalForInteractionMessage(withTitle: "Touch on screen")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        arView.removeGroup(withName: Self.typeName)
        arView.removeFromSuperview()
        menuAdded = false
    }
        
    func doOnTap(_ sender: WorldTrackingRealityKitView, _ transform: simd_float4x4) {
        populateARView(sender, transform)
    }
    
    func entitySelected(_ entity: Entity) {
        guard let entityName = entity.parent?.name,
              let section = viewModel.sections.first(where: { $0.id == entityName }) 
        else { return }
        
        let vc = SectionDetailBaseViewController(
            viewModel: SectionDetailBaseViewModel(currentSection: section, allSections: viewModel.sections))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
    private func populateARView(_ arView: WorldTrackingRealityKitView, _ transform: simd_float4x4) {
        if viewModel.menuItems.count == 0 || menuAdded { return }
        
        menuAdded = true
        removeProposalForInteractionMessage()
        
        var menuItemEntities: [Menu3DItem] = []
        let dispatchGroup = DispatchGroup()
        let menuItems: [MenuItemData] = viewModel.menuItems.reversed()
        
        for index in 0...viewModel.menuItems.count - 1 {
            dispatchGroup.enter()
            
            let menuItemEntity = Menu3DItem()
            menuItemEntity.initData(menuItems[index]) { [unowned self] in
                menuItemEntity.transform = Transform(matrix: transform)
                menuItemEntity.position.y += (Float(index) * menuItemsSpacing) - menuYOffset
                menuItemEntities.append(menuItemEntity)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            menuItemEntities.forEach {
                let anchor = AnchorEntity()
                anchor.addChild($0)
                arView.addToGroup(withName: Self.typeName, anchor: anchor)
            }
        }
    }
}
