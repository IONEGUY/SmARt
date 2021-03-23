//
//  MaskList.swift
//  SmARt
//
//  Created by MacBook on 23.02.21.
//

import SwiftUI

struct MaskList: View {
    @State var masks: [Mask?]
    
    var maskSelected: (Mask) -> Void = {_ in}
    
    var body: some View {
        HStack(spacing: 15) {
            ForEach(0..<masks.count) { index in
                ZStack(alignment: .center) {
                    ImageFromFile(name: masks[index]?.icon.id ?? .empty)
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
                .onTapGesture {
                    guard let mask = masks[index] else { return }
                    maskSelected(mask)
                }
                .background(Color(hex: 0x3C506A, alpha: 0.5))
                .cornerRadius(10)
            }
        }.frame(width: UIScreen.width - 30, height: 200)
    }
}
