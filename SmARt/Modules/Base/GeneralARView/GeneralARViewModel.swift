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
    @Published var current3DObjectId: String = .empty
    @Published var augmentedObjectType = AugmentedObjectType.object3D

    override init() {
        super.init()
    }
    
    init(object3DIds: [String], augmentedObjectType: AugmentedObjectType) {
        super.init()
        
        self.augmentedObjectType = augmentedObjectType
        current3DObjectId = object3DIds.first ?? .empty
        
        let files = constructFiles(object3DIds, augmentedObjectType)
        performFilesLoading(files: files)
    }
    
    func constructFiles(_ object3DIds: [String], _ augmentedObjectType: AugmentedObjectType) -> [FileProtocol] {
        let baseUrl: String = ApiConstants.fileUrls[augmentedObjectType] ?? .empty
        let fileExtension: String = ApiConstants.fileExtensions[augmentedObjectType] ?? .empty
        
        return object3DIds.map { FileData(id: $0, url: baseUrl + $0, fileExtension: fileExtension) }
    }
}
