//
//  SectionsList3DItem.swift
//  SmARt
//
//  Created by MacBook on 2/8/21.
//

import Foundation
import RealityKit
import ARKit
import UIKit
import SwiftUI
import Alamofire
import Combine

class Menu3DItem: Entity, HasAnchoring {
    private var cancellables = Set<AnyCancellable>()
    
    func initData(_ menuItemData: SectionsList3DItemData) {
        name = menuItemData.id
        Entity.loadModelAsync(contentsOf: menuItemData.object3DFileUrl)
            .sink { _ in }
            receiveValue: { [unowned self] model in
                model.scale = SIMD3<Float>(x: 0.0005, y: 0.0005, z: 0.0005)
                model.position.x += -0.09
                model.position.z += 0.05
                
                addChild(createPlaneInfo(menuItemData))
                addChild(model)
            }
            .store(in: &cancellables)
    }
    
    private func createPlaneInfo(_ menuItemData: SectionsList3DItemData) -> ModelEntity {
        let image = createPlaneInfoImage(menuItemData.sectionName, menuItemData.sectionDescription)
        let documentsDirectory =
            FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        guard let data = image.pngData(),
              let filePath = documentsDirectory?.appendingPathComponent("\(menuItemData.object3DName).png"),
            (try? data.write(to: filePath)) != nil else { return ModelEntity() }

        var material = SimpleMaterial()
        material.baseColor = try! .texture(.load(contentsOf: filePath))
        material.metallic = .float(0.01)
        material.roughness = .float(1)

        try? FileManager.default.removeItem(atPath: filePath.absoluteString)
        
        let model = ModelEntity(mesh: .generatePlane(width: 0.4,
                                                     height: 0.1,
                                                     cornerRadius: 0.04),
                                materials: [material])
        
        return model
    }

    private func createPlaneInfoImage(_ name: String,_ description: String) -> UIImage {
        let container = UIImageView(frame: CGRect(x: 0, y: 0, width: 400, height: 100))

        container.image = UIImage(named: "container_gradient")

        let radialGradientImageView =
            UIImageView(frame: CGRect(x: 30, y: -50, width: 200, height: 200))
        radialGradientImageView.image = UIImage(named: "radial_gradient")
        radialGradientImageView.contentMode = .scaleToFill

        let sectionName =
            UILabel(frame: CGRect(x: 200, y: 10, width: 200, height: 25))
        sectionName.font = .systemFont(ofSize: 22, weight: .bold)
        sectionName.textColor = .blue
        sectionName.text = name

        let sectionDescription =
            UILabel(frame: CGRect(x: 200, y: 40, width: 180, height: 40))
        sectionDescription.font = .systemFont(ofSize: 16, weight: .semibold)
        sectionDescription.textColor = .gray
        sectionDescription.text = description
        sectionDescription.lineBreakMode = .byWordWrapping
        sectionDescription.numberOfLines = 0

        container.addSubview(radialGradientImageView)
        container.addSubview(sectionName)
        container.addSubview(sectionDescription)

        return increaseContrast(container.toImage())
    }

    func increaseContrast(_ image: UIImage) -> UIImage {
        let inputImage = CIImage(image: image)!
        let parameters = ["inputContrast": NSNumber(value: 0.7)]
        let outputImage = inputImage.applyingFilter("CIColorControls", parameters: parameters)

        let context = CIContext(options: nil)
        let img = context.createCGImage(outputImage, from: outputImage.extent)!
        return UIImage(cgImage: img)
    }
}
