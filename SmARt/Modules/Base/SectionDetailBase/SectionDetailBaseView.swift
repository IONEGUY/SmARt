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
            
            VStack {
                switch viewModel.sectionType {
                case .droneSection, .smartRoom, .section5G, .smartRetail:
                    SectionWithComplexDescriptionView(viewModel: viewModel)
                case .healthSection: HealthSectionView(viewModel: viewModel)
                case .smartTourism: SmartTourismView(viewModel: viewModel)
                case .arDrawing: ARDrawingSectionView(viewModel: viewModel)
                default: EmptyView()
                }
            }
            .padding(.top, 50)
        }
        .navigationBarHidden(true)
    }
}
