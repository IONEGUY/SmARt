//
//  MenuARViewController.swift
//  SmARt
//
//  Created by MacBook on 27.02.21.
//

import Foundation
import RealityKit
import UIKit
import RealityUI

class MenuARViewController: UIViewController, ExtendedRealityKitViewDelegate {
    var viewModel: MenuViewModel
    var menuAdded = false
    var arView: ExtendedRealityKitView
    
    init(viewModel: MenuViewModel) {
        self.viewModel = viewModel
        
        arView = ExtendedRealityKitView()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(arView)
        arView.fillSuperview()
        arView.setup()
        arView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        arView.configueARSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        arView.session.pause()
    }
    
    func doOnTap(_ sender: ExtendedRealityKitView, _ transform: simd_float4x4) {
        populateARView(sender, transform)
    }
    
    func entitySelected(_ entity: Entity) {
        guard let entityName = entity.parent?.name else { return }
        viewModel.onMenuItemSelected.send(entityName)
    }
    
    private func populateARView(_ arView: ExtendedRealityKitView, _ transform: simd_float4x4) {
        if viewModel.menuItems.isEmpty || menuAdded { return }
        menuAdded.toggle()
        
        var menuItems: [Menu3DItem] = []
        let dispatchGroup = DispatchGroup()
        
        for index in 0...viewModel.menuItems.count - 1 {
            dispatchGroup.enter()
            
            let menuItem = Menu3DItem()
            menuItem.initData(viewModel.menuItems[index])
            menuItem.transform = Transform(matrix: transform)
            menuItem.position.y += (Float(index) * 0.2) + (Float(index) * 0.04) + 0.1
            menuItems.append(menuItem)
            
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.global(qos: .background)) {
            menuItems.forEach {
                let anchor = AnchorEntity()
                anchor.addChild($0)
                arView.scene.anchors.append(anchor)
            }
        }
    }
}
