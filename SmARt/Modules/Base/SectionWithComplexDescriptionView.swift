//
//  SectionWithComplexDescriptionView.swift
//  SmARt
//
//  Created by MacBook on 19.02.21.
//

import SwiftUI

struct SectionWithComplexDescriptionView: View {
    var section: Section?
    var getStartedButtonText: String
    var objectSelected: (ObjectData) -> Void
    var getStartedButtonAction: () -> Void
    
    var body: some View {
        VStack {
            ImageFromFile(name: section?.logo2d?.id ?? .empty)
                .scaledToFit()
                .frame(width: UIScreen.width - 20, height: 300)
            
            if section?.complexDescription != nil {
                ComplexDescriptionView(data: section?.complexDescription?.items ?? [],
                                       chunkValue: 2)
                    .padding(.top, 30)
                Spacer()
            } else {
                Spacer()
                SectionObjectsView(objects: section?.objects ?? [],
                                   objectSelected: objectSelected)
            }
            
            SectionDescription(text: section?.description ?? .empty)
                .padding(.bottom, 40)
            
            GetStartedButton(action: getStartedButtonAction, text: getStartedButtonText)
                .padding(.bottom, 60)
        }
    }
}
