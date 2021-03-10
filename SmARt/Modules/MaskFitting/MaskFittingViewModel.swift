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
    @Published var currentMaskId = String.empty
    
    init(masks: [Mask?]) {
        self.masks = masks
        if let firstMask = masks.first, let mask = firstMask {
            currentMask = mask
            currentMaskId = mask.icon.id
        }
    }
    
    func maskChanged(_ mask: Mask) {
        masks.removeAll(where: { $0?.id == mask.id })
        masks.append(currentMask)
        currentMask = mask
        currentMaskId = mask.icon.id
    }
}
