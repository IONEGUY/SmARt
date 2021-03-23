//
//  Object3DButton.swift
//  SmARt
//
//  Created by MacBook on 22.02.21.
//

import Foundation

class Object3DButton: Identifiable {
    init(image: String, isSelected: Bool = false) {
        self.image = image
        self.isSelected = isSelected
    }
    
    var id = UUID()
    var image: String = .empty
    var isSelected: Bool = false
    var action: () -> Void = {}
}
