//
//  SectionDescription.swift
//  SmARt
//
//  Created by MacBook on 18.02.21.
//

import SwiftUI

struct SectionDescription: View {
    var text: String
    
    var body: some View {
        Text(text)
            .frame(width: UIScreen.width - 100, height: .none)
            .lineLimit(nil)
            .foregroundColor(Color(hex: 0x8E8E8E))
            .font(.system(size: 10))
            .multilineTextAlignment(.center)
    }
}

struct SectionDescription_Previews: PreviewProvider {
    static var previews: some View {
        SectionDescription(text: .empty)
    }
}
