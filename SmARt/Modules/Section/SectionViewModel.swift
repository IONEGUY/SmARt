//
//  SectionViewModel.swift
//  SmARt
//
//  Created by MacBook on 17.02.21.
//

import Combine
import Alamofire
import SwiftUI

class SectionViewModel: ObservableObject {
    let sectionInfo: Section?
    
    init(sectionInfo: Section?) {
        self.sectionInfo = sectionInfo
        if sectionInfo != nil {
            print(sectionInfo!.menuName)
        }
    }
}
