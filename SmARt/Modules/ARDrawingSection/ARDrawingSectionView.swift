//
//  ARDrawingSectionView.swift
//  SmARt
//
//  Created by MacBook on 18.03.21.
//

import Foundation
import SwiftUI

struct ARDrawingSectionView: View {
    var viewModel: SectionDetailBaseViewModel

    var body: some View {
        VStack(spacing: 30) {
            ImageFromFile(name: viewModel.section.logo2d.id)
                .scaledToFit()
                .frame(width: UIScreen.width - 20, height: 300)
            Spacer()
            SectionDescription(text: viewModel.section.description,
                               color: .white,
                               font: .system(size: 16))
            Spacer()
            GetStartedButton(action: viewModel.handleGetStartedButtonPressed)
        }
    }
}
