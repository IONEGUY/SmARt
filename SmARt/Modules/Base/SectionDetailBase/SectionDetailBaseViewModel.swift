//
//  SectionViewModel.swift
//  SmARt
//
//  Created by MacBook on 17.02.21.
//

import Combine
import Alamofire
import SwiftUI

class SectionDetailBaseViewModel: ObservableObject {
    let section: Section
    var sectionType: SectionType = .none
    
    @Published var title: String = .empty
    @Published var pushARPage = PassthroughSubject<ARPageType, Never>()
    @Published var masks = [Mask?]()
    @Published var object3DIds = [String]()
    @Published var augmentedObjectType = AugmentedObjectType.object3D
    @Published var sectionDescription = String.empty
    
    init(section: Section) {
        self.section = section
        
        title = section.name
        sectionType = SectionType(rawValue: section.typeSection) ?? .none
        sectionDescription = section.description
    }
    
    func handleGetStartedButtonPressed() {
        buildDataForARPage()
        performNavigationToARViewPage()
    }
    
    func handleObjectSelected(_ object: ObjectData) {
        augmentedObjectType = object.video != nil ? .video : .object3D
        object3DIds = [object.video?.id ?? object.object3d?.files?.first?.id ?? .empty]
        performNavigationToARViewPage()
    }
    
    private func performNavigationToARViewPage() {
        var arPage: ARPageType = .generalARViewPage
        switch sectionType {
        case .smartRetail: arPage = .maskFittingPage
        case .droneSection: arPage = .dronePage
        case .arDrawing: arPage = .arDrawingPage
        default: break
        }
        
        pushARPage.send(arPage)
    }
    
    private func buildDataForARPage() {
        switch sectionType {
        case .smartRoom:
            object3DIds = section.objects?.map { objectData in
                objectData.object3d?.files?.first?.id ?? .empty
            } ?? []
        case .section5G:
            object3DIds = [section.objects?.last?.object3d?.files?.first?.id ?? .empty]
        case .smartRetail:
            masks = section.objects?.map(\.mask) ?? []
        case .droneSection:
            object3DIds = [section.objects?.first?.object3d?.files?.first?.id ?? .empty]
        default:
            break
        }
    }
}
