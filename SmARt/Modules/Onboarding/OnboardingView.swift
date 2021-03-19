//
//  OnboardingView.swift
//  SmARt
//
//  Created by MacBook on 19.03.21.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack {
            Color(hex: 0x1C242E)
                .ignoresSafeArea()
            VStack {
                OnboardingSectionListView(sectionsConfig: $viewModel.sectionsConfig,
                                          currentIndex: $viewModel.pageIndex)
                    .padding(.top, 40)
                Spacer()
                GetStartedButton(action: viewModel.getStartedButtonAction,
                                 text: viewModel.getStartedButtonText)
                    .padding(.bottom, 40)
            }
        }
    }
}

struct OnboardingSectionListView: View {
    @Binding var sectionsConfig: [(image: String, title: String)]
    @Binding var currentIndex: Int
    private let imageSize = UIScreen.width - 50
    
    var body: some View {
        VStack(spacing: 40) {
            ZStack {
                Image("radial_gradient")
                    .resizable()
                Image(sectionsConfig[currentIndex].image)
                    .resizable()
                    .zIndex(2)
            }
            .frame(width: imageSize, height: imageSize, alignment: .center)
            
            Text(sectionsConfig[currentIndex].title)
                .frame(width: UIScreen.width - 100, height: 70)
                .lineLimit(nil)
                .foregroundColor(Color.white)
                .font(.system(size: 22, weight: .bold))
                .multilineTextAlignment(.center)
            
            HStack(spacing: 6) {
                ForEach(0..<sectionsConfig.count) { index in
                    Capsule(style: .circular)
                        .frame(width: 28, height: 8)
                        .foregroundColor(index == currentIndex
                                        ? Color(hex: 0x0983FD)
                                        : Color(hex: 0x3A4451, alpha: 0.7))
                }
            }
        }
    }
}
