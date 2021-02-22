//
//  SmartRoomARViewModel.swift
//  SmARt
//
//  Created by MacBook on 22.02.21.
//

import Foundation
import Combine

class SmartRoomARViewModel: ObservableObject {
    @Published var object3DButtons: [Object3DButton]
    @Published var current3DObjectUrl: String
    @Published var is3DObjectButtonsVisible = false
    
    var r = Set<AnyCancellable>()
    
    init(object3dUrls: [String]) {
        current3DObjectUrl = object3dUrls.first ?? .empty
        is3DObjectButtonsVisible = !object3dUrls.isEmpty
        object3DButtons = [
            Object3DButton(image: "light", isSelected: true),
            Object3DButton(image: "cup")
        ]
        
        $current3DObjectUrl.sink(receiveValue: { print($0) }).store(in: &r)
        
        for index in 0..<object3dUrls.count {
            object3DButtons[index].action = { [unowned self] in
                current3DObjectUrl = object3dUrls[index]
                object3DButtons.forEach { $0.isSelected = false }
                object3DButtons[index].isSelected = true
            }
        }
    }
}
