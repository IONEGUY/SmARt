//
//  SmartRoomARView.swift
//  SmARt
//
//  Created by MacBook on 22.02.21.
//

import SwiftUI
import Combine

struct SmartRoomARView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: SmartRoomARViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            RealityKitViewContainer(objectUrl: $viewModel.current3DObjectUrl,
                                    objectType: $viewModel.augmentedObjectType)
                .edgesIgnoringSafeArea(.all)
            
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .frame(width: 30, height: 30)
                        .background(Color(hex: 0xC4C4C4, alpha: 0.7))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }.frame(width: 60, height: 60, alignment: .topLeading)
                
                if viewModel.is3DObjectButtonsVisible {
                    VStack {
                        ForEach(viewModel.object3DButtons) { button in
                            Button(action: button.action) {
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
            }.frame(width: UIScreen.width - 50, height: 60)
        }
    }
}
