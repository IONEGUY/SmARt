//
//  DroneSectionView.swift
//  SmARt
//
//  Created by MacBook on 17.02.21.
//

import SwiftUI

struct DroneSectionView: View {
    var body: some View {
        VStack {
            Image("drone")
                .resizable()
                .scaledToFit()
                .frame(width: UIScreen.width,
                       height: 225)
            
            Spacer()
            
            ComplexDescriptionView(data: data, chunkValue: 2)
            
            Spacer()
            
            SectionDescription(text: "Explore new places and use the drone. Observe in real time mode and record what you see!")
                .padding(.bottom, 40)
            
            GetStartedButton(action: {}, text: "Get Started")
                .padding(.bottom, 60)
        }
    }
}

struct DroneSectionView_Previews: PreviewProvider {
    static var previews: some View {
        DroneSectionView()
    }
}
