//
//  SmartRoomARViewModel.swift
//  SmARt
//
//  Created by MacBook on 27.04.21.
//

import Foundation
import Combine

class SmartRoomARViewModel: GeneralARViewModel {
    var object3DButtons: [SelectableButton] = []
    var current3DObjectChanged = PassthroughSubject<Void, Never>()
    
    override init(object3DIds: [String], augmentedObjectType: AugmentedObjectType) {
        super.init(object3DIds: object3DIds, augmentedObjectType: augmentedObjectType)
        createObject3DButtons(object3DIds)
    }
    
    private func createObject3DButtons(_ object3DIds: [String]) {
        object3DButtons = [
            SelectableButton(unselectedimage: "zap", selectedImage: "zap_selected", isSelected: true),
            SelectableButton(unselectedimage: "cup", selectedImage: "cup_selected")
        ]

        for index in 0..<object3DIds.count {
            object3DButtons[index].action = { [unowned self] in
                current3DObjectId = object3DIds[index]
                object3DButtons.forEach { $0.isSelected = false }
                object3DButtons[index].toogleSelection()
                current3DObjectChanged.send()
            }
        }
    }
}
