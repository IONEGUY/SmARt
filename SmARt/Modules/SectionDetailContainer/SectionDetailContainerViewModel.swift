//
//  SectionViewModel.swift
//  SmARt
//
//  Created by MacBook on 17.02.21.
//

import Combine
import Alamofire
import SwiftUI

class SectionDetailContainerViewModel: ObservableObject {
    let sectionInfo: Section?
    var sectionType: SectionType = .none
    var getStartedButtonText = "Get Started"
    var getStartedButtonPressed: () -> Void = {}
    var objectSelected: (ObjectData) -> Void = {_ in}
    
    @Published var title: String = .empty
    @Published var pushSmartRoomARViewActive = false
    @Published var pushMaskFittingViewActive = false
    @Published var pushDroneARViewActive = false
    @Published var masks = [Mask?]()
    @Published var object3dUrls = [String]()
    @Published var augmentedObjectType = AugmentedObjectType.object3D
    @Published var sectionDescription = String.empty
    
    init(sectionInfo: Section?) {
        self.sectionInfo = sectionInfo
        if let sectionInfo = sectionInfo {
            title = sectionInfo.name
            sectionType = SectionType(rawValue: sectionInfo.typeSection) ?? .none
            sectionDescription = sectionInfo.description
            
            getStartedButtonPressed = handleGetStartedButtonPressed
            objectSelected = handleObjectSelected
            
            switch sectionType {
            case .healthSection:
                getStartedButtonText = "Get Stream"
            case .section5G:
                getStartedButtonText = "5G coverage"
            default:
                break
            }
        }
    }
    
    private func handleGetStartedButtonPressed() {
        switch sectionType {
        case .smartRoom:
            object3dUrls = sectionInfo?.objects?.map { objectData in
                objectData.object3d?.files?.first?.url ?? .empty
            } ?? []
            pushSmartRoomARViewActive = true
        case .section5G:
            object3dUrls =
                [sectionInfo?.objects?.first?.object3d?.files?.first?.url ?? .empty]
            pushSmartRoomARViewActive = true
        case .smartRetail:
            masks = sectionInfo?.objects?.map(\.mask) ?? []
            pushMaskFittingViewActive = true
        case .droneSection:
            object3dUrls =
                [sectionInfo?.objects?.first?.object3d?.files?.first?.url ?? .empty]
            pushDroneARViewActive = true
        default:
            break
        }
    }
    
    private func handleObjectSelected(_ object: ObjectData) {
        augmentedObjectType = object.video != nil ? .video : .object3D
        object3dUrls = [object.video?.url ?? object.object3d?.files?.first?.url ?? .empty]
        pushSmartRoomARViewActive = true
    }
}
