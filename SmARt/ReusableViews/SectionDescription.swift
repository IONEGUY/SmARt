//
//  SectionDescription.swift
//  SmARt
//
//  Created by MacBook on 18.02.21.
//

import SwiftUI

struct SectionDescription: View {
    var text: String
    var color: Color
    var fontSize: CGFloat
    
    init(text: String, color: Color = Color(hex: 0x8E8E8E), fontSize: CGFloat = 10) {
        self.text = text
        self.color = color
        self.fontSize = fontSize
    }
    
    var body: some View {
        Text(text)
            .frame(width: UIScreen.width - 100, height: .none)
            .lineLimit(nil)
            .foregroundColor(color)
            .font(.system(size: fontSize))
            .multilineTextAlignment(.center)
    }
}
