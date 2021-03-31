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
        VStack(spacing: 20) {
            ImageFromFile(name: viewModel.section.logo2d.id)
                .scaledToFit()
                .frame(width: UIScreen.width - 20, height: 300)
                        
            if viewModel.section.complexDescription != nil {
                ComplexDescriptionView(data: viewModel.section.complexDescription?.items ?? [],
                                       chunkValue: 2)
            } else {
                SectionObjectsView(objects: viewModel.section.objects ?? [],
                                   objectSelected: viewModel.handleObjectSelected)
            }
                        
            if viewModel.sectionType != .section5G {
                SectionDescription(text: viewModel.section.description)
            }
                        
            GetStartedButton(action: viewModel.handleGetStartedButtonPressed)
        }
    }
}
