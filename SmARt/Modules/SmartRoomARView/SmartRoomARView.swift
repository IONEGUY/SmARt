//
//  SmartRoomARView.swift
//  SmARt
//
//  Created by MacBook on 22.02.21.
//

import SwiftUI
import RealityKit
import ARKit
import Combine
import Alamofire

struct SmartRoomARView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: SmartRoomARViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            Color.black
                .edgesIgnoringSafeArea(.all)
            
            HStack {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.white)
                }
                .frame(width: 30, height: 30)
                .background(Color(hex: 0xC4C4C4, alpha: 0.7))
                .cornerRadius(15)
                Spacer()
                
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
            ARViewContainer(objectUrl: $viewModel.current3DObjectUrl)
        }
    }
}

struct SmartRoomARView_Previews: PreviewProvider {
    static var previews: some View {
        SmartRoomARView(viewModel: SmartRoomARViewModel(object3dUrls: []))
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var objectUrl: String
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero)
        arView.contentScaleFactor =  0.5 * arView.contentScaleFactor
        return arView
        
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
    
}
