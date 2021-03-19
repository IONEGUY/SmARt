//
//  ARDrawingSectionView.swift
//  SmARt
//
//  Created by MacBook on 18.03.21.
//

import Foundation
import SwiftUI

struct ARDrawingSectionView: View {
    var getStartedButtonText: String
    var getStartedButtonAction: () -> Void
    var section: Section?
    
    var body: some View {
        VStack(spacing: 30) {
            ImageFromFile(name: section?.logo2d?.id ?? .empty)
                .scaledToFit()
                .frame(width: UIScreen.width - 20, height: 300)
            Spacer()
            SectionDescription(text: section?.description ?? .empty,
                               color: .white,
                               fontSize: 16)
            Spacer()
            GetStartedButton(action: getStartedButtonAction,
                             text: getStartedButtonText)
        }
    }
}
