//
//  SectionObjectsView.swift
//  SmARt
//
//  Created by MacBook on 19.02.21.
//

import SwiftUI
import Kingfisher

struct SectionObjectsView: View {
    var objects: [ObjectData]
    var objectSelected: (ObjectData) -> Void
    
    var body: some View {
        if objects.first?.mask == nil {
            KFImage(URL(string: objects.first?.icon.url ?? .empty))
                .resizable()
                .frame(width: UIScreen.width - 60, height: 150)
                .cornerRadius(18)
                .onTapGesture {
                    guard let object = objects.first else { return }
                    objectSelected(object)
                }
        } else {
            MaskList(masks: objects.map(\.mask))
        }
    }
}
