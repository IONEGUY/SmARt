//
//  SectionObjectsView.swift
//  SmARt
//
//  Created by MacBook on 19.02.21.
//

import SwiftUI

struct SectionObjectsView: View {
    var objects: [ObjectData]
    var objectSelected: (ObjectData) -> Void
    
    var body: some View {
        if objects.first?.mask == nil {
            ImageFromFile(name: objects.first?.icon.id ?? .empty)
                .frame(width: UIScreen.width - 60, height: 150)
                .cornerRadius(18)
                .onTapGesture {
                    guard let object = objects.first else { return }
                    objectSelected(object)
                }
                .padding(.vertical, 40)
        } else {
            MaskList(masks: objects.map(\.mask))
        }
    }
}
