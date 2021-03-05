//
//  NavBar.swift
//  SmARt
//
//  Created by MacBook on 3.03.21.
//

import Foundation
import SwiftUI

struct NavBar: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var object3DButtons: [Object3DButton] = []
    @State var title: String = .empty
    @State var backButtonAction: (() -> Void)?
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                Button(action: { backButtonAction?() ?? presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .frame(width: 30, height: 30)
                        .background(Color(hex: 0xC4C4C4, alpha: 0.7))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }.frame(width: 60, height: 60, alignment: .topLeading)
                
                Spacer()
                
                if !object3DButtons.isEmpty {
                    VStack {
                        ForEach(object3DButtons) { button in
                            Button(action: {
                                button.action()
                                object3DButtons = [object3DButtons].flatMap { $0 }
                            }) {
                                Image(button.image)
                                    .colorMultiply(Color(
                                        hex: button.isSelected ? 0x0983FD : 0xFFFFFF))
                            }
                            .frame(width: 30, height: 30)
                        }
                    }
                    .background(Color(hex: 0xC4C4C4, alpha: 0.7))
                    .cornerRadius(8)
                }
            }
            Text(title)
                .foregroundColor(.white)
                .fontWeight(.heavy)
                .font(.title3)
                .padding(.top, 5)
        }
    }
}
