//
//  Covering5GView.swift
//  SmARt
//
//  Created by MacBook on 2/11/21.
//

import SwiftUI

struct SectionDetailBaseView: View {
    @ObservedObject var viewModel: SectionDetailBaseViewModel
    
    init(viewModel: SectionDetailBaseViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            Image("section_background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            
            switch viewModel.sectionType {
            case .droneSection, .smartRoom, .section5G, .smartRetail:
                SectionWithComplexDescriptionView(section: viewModel.sectionInfo,
                                                  getStartedButtonText: viewModel.getStartedButtonText,
                                                  objectSelected: viewModel.objectSelected,
                                                  getStartedButtonAction: viewModel.getStartedButtonPressed)
                    .padding(.top, 50)
            case .healthSection:
                HealthSectionView(objects: viewModel.sectionInfo?.objects ?? [],
                                  getStartedButtonText: viewModel.getStartedButtonText,
                                  objectSelected: viewModel.objectSelected,
                                  getStartedButtonAction: viewModel.getStartedButtonPressed)
                    .padding(.top, 50)
            case .smartTourism:
                SmartTourismView(objects: viewModel.sectionInfo?.objects ?? [],
                                 objectSelected: viewModel.objectSelected,
                                 sectionDescription: viewModel.sectionDescription)
                    .padding(.top, 50)
            default: EmptyView()
            }
        }
        .navigationBarHidden(true)
    }
}
