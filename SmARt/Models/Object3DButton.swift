//
//  Object3DButton.swift
//  SmARt
//
//  Created by MacBook on 22.02.21.
//

import Foundation

class SelectableButton {
    init(unselectedimage: String, selectedImage: String = .empty, isSelected: Bool = false) {
        self.unselectedimage = unselectedimage
        self.selectedImage = selectedImage
        self.isSelected = isSelected
    }
    
    var currentImage: String { isSelected ? selectedImage : unselectedimage }
    var unselectedimage: String = .empty
    var selectedImage: String = .empty
    var isSelected: Bool = false
    var action: () -> Void = {}
    
    func toogleSelection() {
        isSelected.toggle()
    }
}
