//
//  SectionWithComplexDescriptionView.swift
//  SmARt
//
//  Created by MacBook on 19.02.21.
//

import SwiftUI

struct SectionWithComplexDescriptionView: View {
    var viewModel: SectionDetailBaseViewModel
    
    var body: some View {
        VStack {
            ImageFromFile(name: viewModel.section.logo2d.id)
                .scaledToFit()
                .frame(width: UIScreen.width - 20, height: 300)
            
            if viewModel.section.complexDescription != nil {
                ComplexDescriptionView(data: viewModel.section.complexDescription?.items ?? [],
                                       chunkValue: 2)
                    .padding(.top, 30)
                Spacer()
            } else {
                Spacer()
                SectionObjectsView(objects: viewModel.section.objects ?? [],
                                   objectSelected: viewModel.handleObjectSelected)
            }
            
            SectionDescription(text: viewModel.section.description)
                .padding(.bottom, 40)
            
            GetStartedButton(action: viewModel.handleGetStartedButtonPressed,
                             text: viewModel.getStartedButtonText)
                .padding(.bottom, 60)
        }
    }
}
