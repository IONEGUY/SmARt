//
//  SmartRoomARViewModel.swift
//  SmARt
//
//  Created by MacBook on 22.02.21.
//

import Foundation
import Combine
import SwiftUI
import RealityKit

class SmartRoomARViewModel: ObservableObject {
    @Published var object3DButtons: [Object3DButton] = []
    @Published var current3DObjectUrl: String
    @Published var augmentedObjectType = AugmentedObjectType.object3D
    
    init(object3dUrls: [String], augmentedObjectType: AugmentedObjectType) {
        self.augmentedObjectType = augmentedObjectType
        current3DObjectUrl = object3dUrls.first ?? .empty
        
        createObject3DButtons(object3dUrls)
    }
    
    private func createObject3DButtons(_ object3dUrls: [String]) {
        if object3dUrls.count < 2 { return }
        
        object3DButtons = [
            Object3DButton(image: "light", isSelected: true),
            Object3DButton(image: "cup")
        ]

        for index in 0..<object3dUrls.count {
            object3DButtons[index].action = { [unowned self] in
                current3DObjectUrl = object3dUrls[index]
                object3DButtons.forEach { $0.isSelected = false }
                object3DButtons[index].isSelected = true
            }
        }
    }
}
