//
//  MaskFittingViewModel.swift
//  SmARt
//
//  Created by MacBook on 23.02.21.
//

import Foundation
import SwiftUI
import Combine

class MaskFittingViewModel: ObservableObject {
    private var currentMask = Mask(id: .empty,
                                   icon: ImageData(url: .empty),
                                   description: String.empty)
    @Published var masks = [Mask?]()
    @Published var currentMaskUrl = String.empty
    
    init(masks: [Mask?]) {
        self.masks = masks
        if let firstMask = masks.first, let mask = firstMask {
            currentMask = mask
            currentMaskUrl = mask.icon.url
        }
    }
    
    func maskChanged(_ mask: Mask) {
        masks.removeAll(where: { $0?.id == mask.id })
        masks.append(currentMask)
        currentMask = mask
        currentMaskUrl = mask.icon.url
    }
}
