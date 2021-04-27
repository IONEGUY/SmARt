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
    let allSections: [Section]
    var sectionType: SectionType = .none
    
    @Published var title: String = .empty
    @Published var pushARPage = PassthroughSubject<SectionType, Never>()
    @Published var masks = [Mask?]()
    @Published var object3DIds = [String]()
    @Published var augmentedObjectType = AugmentedObjectType.object3D
    @Published var sectionDescription = String.empty
    
    init(currentSection: Section, allSections: [Section]) {
        self.section = currentSection
        self.allSections = allSections
        
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
        pushARPage.send(sectionType)
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
