//
//  ARScannerViewController.swift
//  SmARt
//
//  Created by MacBook on 22.04.21.
//

import Foundation
import ARKit
import RealityKit

class ARScannerViewController: GeneralARViewController<ARScannerViewModel> {
    override var objects3DGroupName: String { "Holograms" }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        $loadingProgress
            .sink { [unowned self] in
                switch $0 {
                case .finished: setupTrackingImages()
                default: break
                }
            }
            .store(in: &cancellables)
        
        addProposalForInteractionMessage(withTitle: "Focus on image")
    }
    private func setupTrackingImages() {
        let images = viewModel.triggers.keys.compactMap { UIImage.read(name: $0) }
        let trackingImages = Dictionary(uniqueKeysWithValues: zip(images, viewModel.triggers.values))
        arView.configueImageTrackingARSession(trackingImages: trackingImages)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        WorldTrackingRealityKitView.shared.configueARSession()
    }
}
