//
//  GetStartedButton.swift
//  SmARt
//
//  Created by MacBook on 18.02.21.
//

import SwiftUI
import Combine

struct GetStartedButton: View {
    var action: () -> Void
    var text: String
    
    var body: some View {
        Button(action: action, label: {
            Text(text)
                .foregroundColor(.white)
                .fontWeight(.heavy)
                .font(.headline)
        })
        .frame(width: UIScreen.width - 60, height: 50)
        .background(
            LinearGradient(gradient: Gradient(colors: [
                               Color(hex: 0x667CE7),
                               Color(hex: 0x6973DA),
                               Color(hex: 0x6B6CD0),
                               Color(hex: 0x6F60C0),
                               Color(hex: 0x7258B4),
                               Color(hex: 0x7352AC),
                               Color(hex: 0x754DA5)]),
                           startPoint: .leading,
                           endPoint: .trailing))
        .cornerRadius(17)
        .shadow(color: Color(hex: 0x705FBE), radius: 5)
    }
}
