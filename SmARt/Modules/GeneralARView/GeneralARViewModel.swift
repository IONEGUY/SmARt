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

class GeneralARViewModel: BaseViewModel, ObservableObject {
    @Published var object3DButtons: [Object3DButton] = []
    @Published var current3DObjectId: String = .empty
    @Published var augmentedObjectType = AugmentedObjectType.object3D
    
    init(object3DIds: [String], augmentedObjectType: AugmentedObjectType) {
        super.init()
        
        downloadMediaContent(object3DIds, augmentedObjectType)
        
        self.augmentedObjectType = augmentedObjectType
        current3DObjectId = object3DIds.first ?? .empty
        
        createObject3DButtons(object3DIds)
    }
    
    private func downloadMediaContent(_ object3DIds: [String], _ augmentedObjectType: AugmentedObjectType) {
        let baseUrl = augmentedObjectType == .object3D ? ApiConstants.modelsUrl : ApiConstants.videosUrl
        let files = object3DIds.map { FileData(id: $0,
                                   url: baseUrl + $0,
                                   fileExtension: augmentedObjectType == .object3D ? "usdz" : "mp4") }
        performFilesLoading(files: files)
    }
    
    private func createObject3DButtons(_ object3DIds: [String]) {
        if object3DIds.count < 2 { return }
        
        object3DButtons = [
            Object3DButton(image: "light", isSelected: true),
            Object3DButton(image: "cup")
        ]

        for index in 0..<object3DIds.count {
            object3DButtons[index].action = { [unowned self] in
                current3DObjectId = object3DIds[index]
                object3DButtons.forEach { $0.isSelected = false }
                object3DButtons[index].isSelected = true
            }
        }
    }
}
