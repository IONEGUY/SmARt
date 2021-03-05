//
//  MaskFittingView.swift
//  SmARt
//
//  Created by MacBook on 23.02.21.
//
//
//import SwiftUI
//import Combine
//
//struct MaskFittingView: View {
//    @Environment(\.presentationMode) var presentationMode
//
//    @ObservedObject var viewModel: MaskFittingViewModel
//
//    var body: some View {
//        ZStack(alignment: .top) {
//            VStack {
//                HStack {
//                    Button(action: { presentationMode.wrappedValue.dismiss() }) {
//                        Image(systemName: "chevron.left")
//                            .frame(width: 30, height: 30)
//                            .background(Color(hex: 0xC4C4C4, alpha: 0.7))
//                            .foregroundColor(.white)
//                            .cornerRadius(15)
//                    }.frame(width: 60, height: 60, alignment: .topLeading)
//
//                    Spacer()
//                }.frame(width: UIScreen.width - 50, height: 60)
//
//                Spacer()
//
//                MaskList(masks: viewModel.masks, maskSelected: viewModel.maskChanged)
//            }.zIndex(1)
//
//            MaskFittingSceneViewContainer(maskUrl: $viewModel.currentMaskUrl)
//                .edgesIgnoringSafeArea(.all)
//        }
//    }
//}
