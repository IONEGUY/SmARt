//
//  Menu3DItemRealityKit.swift
//  SmARt
//
//  Created by MacBook on 27.02.21.
//

import Foundation
import RealityKit
import ARKit
import UIKit
import Alamofire
import Combine

class Menu3DItem: Entity {
    private var cancellables = Set<AnyCancellable>()
    
    func initData(_ menuItemData: MenuItemData, _ completion: @escaping () -> Void) {
        name = menuItemData.id
        generateCollisionShapes(recursive: true)
        let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        guard let object3DName = menuItemData.object3DFileUrl.split(separator: "/").last,
              let filePath = cacheDirectory?.appendingPathComponent("\(object3DName).usdz")
        else { fatalError("cannot retrieve file with 3d model") }
        
        Entity.loadModelAsync(contentsOf: filePath)
            .sink { _ in }
            receiveValue: { [unowned self] model in
                model.position.x += -0.18
                model.position.z += 0.1
                model.orientation = simd_quatf(angle: .pi / 2, axis: [0, 1, 0])
                model.generateCollisionShapes(recursive: true)
                addChild(createPlaneInfo(menuItemData))
                addChild(model)
                completion()
            }
            .store(in: &cancellables)
    }
    
    private func createPlaneInfo(_ menuItemData: MenuItemData) -> ModelEntity {
        let image = createPlaneInfoImage(menuItemData.sectionName, menuItemData.sectionDescription)
        let cacheDirectory =
            FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
        guard let imageName = menuItemData.object3DFileUrl.split(separator: "/").last,
              let data = image.pngData(),
              let filePath = cacheDirectory?.appendingPathComponent("\(imageName).png"),
            (try? data.write(to: filePath)) != nil else { return ModelEntity() }

        var material = SimpleMaterial()
        material.baseColor = try! .texture(.load(contentsOf: filePath))

        try? FileManager.default.removeItem(atPath: filePath.absoluteString)
        
        let model = ModelEntity(mesh: .generatePlane(width: 0.8,
                                                     height: 0.2,
                                                     cornerRadius: 0.08),
                                materials: [material])
        model.generateCollisionShapes(recursive: true)
        return model
    }

    private func createPlaneInfoImage(_ name: String,_ description: String) -> UIImage {
        let container = UIImageView(frame: CGRect(x: 0, y: 0, width: 400, height: 100))

        container.image = UIImage(named: "container_gradient")

        let radialGradientImageView =
            UIImageView(frame: CGRect(x: 0, y: -50, width: 200, height: 200))
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

        return container.toImage()
    }
}
