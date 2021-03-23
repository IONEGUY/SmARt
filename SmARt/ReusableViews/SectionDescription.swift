//
//  SectionDescription.swift
//  SmARt
//
//  Created by MacBook on 18.02.21.
//

import SwiftUI

struct SectionDescription: View {
    private let textWidth = UIScreen.width - 100
    
    var text: String
    var color: Color
    var font: Font
    
    init(text: String, color: Color = Color(hex: 0x8E8E8E), font: Font = .system(size: 10)) {
        self.text = text
        self.color = color
        self.font = font
    }
    
    var body: some View {
        Text(text)
            .frame(width: textWidth, height: 70)
            .lineLimit(nil)
            .foregroundColor(color)
            .font(font)
            .multilineTextAlignment(.center)
    }
}
