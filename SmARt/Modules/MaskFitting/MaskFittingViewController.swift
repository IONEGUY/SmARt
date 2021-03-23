//
//  MaskFittingViewController.swift
//  SmARt
//
//  Created by MacBook on 5.03.21.
//

import Foundation
import SceneKit
import ARKit
import UIKit
import SwiftUI
import Combine

class MaskFittingViewController: BaseViewController, ARSCNViewDelegate {
    var viewModel: MaskFittingViewModel
    var cancellables = Set<AnyCancellable>()
    var maskFittingView: ARSCNView
    
    private var faceNode = SCNNode()
    private var defaultMask: String = .empty
    
    init(viewModel: MaskFittingViewModel) {
        self.viewModel = viewModel
        
        ExtendedRealityKitView.shared.session.pause()
        maskFittingView = ARSCNView()
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(_ defaultMask: String) {
        self.defaultMask = defaultMask
        maskFittingView.delegate = self
        configueARSceneView()
    }
    
    private func configueARSceneView() {
        let configuration = ARFaceTrackingConfiguration()
        maskFittingView.session.run(configuration)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup(viewModel.currentMaskId)
        view.insertSubview(maskFittingView, at: 0)
        maskFittingView.fillSuperview()
        
        createNavBar()
        createMaskList()
        
        viewModel.$currentMaskId
            .sink(receiveValue: { [unowned self] in updateMask($0)})
            .store(in: &cancellables)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = maskFittingView.device else { return nil }
        
        let faceGeometry = ARSCNFaceGeometry(device: device, fillMesh: true)
        faceNode.geometry = faceGeometry
        updateMask(defaultMask)
        return faceNode
    }
    
    func updateMask(_ mask: String) {
        DispatchQueue.main.async { [unowned self] in
            let imageView = UIImageView()
            imageView.image = UIImage.read(from: .documentDirectory, name: mask)
            faceNode.geometry?.firstMaterial?.diffuse.contents = imageView.image
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor,
              let faceGeometry = node.geometry as? ARSCNFaceGeometry
        else { return }

        faceGeometry.update(from: faceAnchor.geometry)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        maskFittingView.session.pause()
        ExtendedRealityKitView.shared.configueARSession()
    }
    
    private func createMaskList() {
        let maskList = UIHostingController(rootView: MaskList(masks: viewModel.masks,
                                                              maskSelected: viewModel.maskChanged))
        maskList.view.backgroundColor = .clear
        addChild(maskList)
        view.addSubview(maskList.view)

        maskList.view.translatesAutoresizingMaskIntoConstraints = false
        maskList.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        maskList.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        maskList.view.heightAnchor.constraint(equalToConstant: 200).isActive = true
        maskList.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
    }
}
