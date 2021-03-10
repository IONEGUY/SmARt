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
    var viewModel: MenuViewModel
    var menuAdded = false
    var arView: ExtendedRealityKitView
    var cancellables = Set<AnyCancellable>()
    var loadingView = LoadingViewWithProgressBar()
    var loadingViewContainer = UIView()
    
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
        
        viewModel.$contentLoadingProgress
            .dropFirst()
            .first()
            .sink { [unowned self] _ in addLoadingView() }
            .store(in: &cancellables)
        
        viewModel.$contentLoadingProgress
            .sink { [unowned self] in loadingView.updateProgress(CGFloat($0)) }
            .store(in: &cancellables)
        
        viewModel.$contentLoadingProgress
            .filter { $0 >= Constants.completeProgressValue }
            .sink { [unowned self] _ in loadingViewContainer.removeFromSuperview() }
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
        guard let entityName = entity.parent?.name else { return }
        
        let section = viewModel.sections.first { $0.id == entityName }
        let vc = SectionDetailBaseViewController(
            viewModel: SectionDetailBaseViewModel(sectionInfo: section))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
    private func populateARView(_ arView: ExtendedRealityKitView, _ transform: simd_float4x4) {
        if viewModel.menuItems.isEmpty || menuAdded { return }
        menuAdded.toggle()
        
        var menuItems: [Menu3DItem] = []
        let dispatchGroup = DispatchGroup()
        
        for index in 0...viewModel.menuItems.count - 1 {
            dispatchGroup.enter()
            
            let menuItem = Menu3DItem()
            menuItem.initData(viewModel.menuItems[index]) {
                menuItem.transform = Transform(matrix: transform)
                menuItem.position.y += (Float(index) * 0.2) + (Float(index) * 0.04) + 0.1
                menuItems.append(menuItem)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            menuItems.forEach {
                let anchor = AnchorEntity()
                anchor.addChild($0)
                arView.addToGroup(withName: Self.typeName, anchor: anchor)
            }
        }
    }
}
