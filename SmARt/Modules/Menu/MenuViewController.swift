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

class MenuViewController: UIViewController, ExtendedRealityKitViewDelegate {
    private var viewModel: MenuViewModel
    private var menuAdded = false
    private var arView: ExtendedRealityKitView
    private var cancellables = Set<AnyCancellable>()
    private var loadingView = LoadingViewWithProgressBar()
    private var loadingViewContainer = UIView()
    
    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
        
        ExtendedRealityKitView.shared.setup()
        arView = ExtendedRealityKitView.shared
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.contentLoadingProgress
            .dropFirst()
            .first()
            .receive(on: RunLoop.main)
            .sink { [unowned self] _ in addLoadingView() }
            .store(in: &cancellables)
        
        viewModel.contentLoadingProgress
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { [unowned self] _ in loadingViewContainer.removeFromSuperview() },
                  receiveValue: { [unowned self] in loadingView.updateProgress(CGFloat($0)) })
            .store(in: &cancellables)
    }
    
    private func addLoadingView() {
        loadingView.text = "Fetching Media Content"
        loadingViewContainer = UIView()
        loadingViewContainer.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        view.addSubview(loadingViewContainer)
        loadingViewContainer.fillSuperview()
        loadingViewContainer.addSubview(loadingView)
        
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        loadingView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loadingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        arView.configueARSession()
        arView.showGroup(withName: Self.typeName)
        view.insertSubview(arView, at: 0)
        arView.fillSuperview()
        arView.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        arView.hideGroup(withName: Self.typeName)
        arView.removeFromSuperview()
    }
        
    func doOnTap(_ sender: ExtendedRealityKitView, _ transform: simd_float4x4) {
        populateARView(sender, transform)
    }
    
    func entitySelected(_ entity: Entity) {
        guard let entityName = entity.parent?.name,
              let section = viewModel.sections.first(where: { $0.id == entityName }) 
        else { return }
        
        let vc = SectionDetailBaseViewController(
            viewModel: SectionDetailBaseViewModel(section: section))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
    private func populateARView(_ arView: ExtendedRealityKitView, _ transform: simd_float4x4) {
        if viewModel.menuItems.isEmpty || menuAdded { return }
        menuAdded.toggle()
        
        var menuItemEntities: [Menu3DItem] = []
        let dispatchGroup = DispatchGroup()
        let menuItems: [MenuItemData] = viewModel.menuItems.reversed()
        
        for index in 0...viewModel.menuItems.count - 1 {
            dispatchGroup.enter()
            
            let menuItemEntity = Menu3DItem()
            menuItemEntity.initData(menuItems[index]) {
                menuItemEntity.transform = Transform(matrix: transform)
                menuItemEntity.position.y += (Float(index) * 0.2) + (Float(index) * 0.04) + 0.1
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
