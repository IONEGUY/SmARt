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
    
    init(sectionInfo: Section?) {
        self.sectionInfo = sectionInfo
        if let sectionInfo = sectionInfo {
            title = sectionInfo.name
            sectionType = SectionType(rawValue: sectionInfo.typeSection) ?? .none
            
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
        case .healthSection:
            getStartedButtonText = "Get Stream"
        case .section5G:
            getStartedButtonText = "5G coverage"
        default:
            break
        }
    }
    
    private func handleObjectSelected(_ object: ObjectData) {
        
    }
}
