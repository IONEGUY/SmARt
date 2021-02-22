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
                .onTapGesture {
                    guard let object = objects.first else { return }
                    objectSelected(object)
                }
        } else {
            let masks = objects.map(\.mask)
            HStack(spacing: 15) {
                ForEach(0..<masks.count) { index in
                    HStack {
                        ZStack(alignment: .center) {
                            KFImage(URL(string: masks[index]?.icon?.url ?? .empty))
                                    .resizable()
                                    .offset(x: 0, y: -40)
                            VStack {
                                Spacer()
                                Text(masks[index]?.description ?? .empty)
                                    .foregroundColor(.white)
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .padding(.all, 10)
                            }
                        }
                    }
                    .background(Color(hex: 0x1D242E))
                    .cornerRadius(10)
                }
            }.frame(width: UIScreen.width - 30, height: 200)
        }
    }
}

struct SectionObjectsView_Previews: PreviewProvider {
    static var previews: some View {
        SectionObjectsView(objects: [], objectSelected: { _ in})
    }
}
