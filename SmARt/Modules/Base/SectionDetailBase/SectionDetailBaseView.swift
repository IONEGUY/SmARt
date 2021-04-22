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
            
            ScrollView(showsIndicators: false) {
                VStack {
                    switch viewModel.sectionType {
                    case .healthSection: HealthSectionView(viewModel: viewModel)
                    case .smartTourism: SmartTourismView(viewModel: viewModel)
                    case .arDrawing, .arScanner: SimpleSectionView(viewModel: viewModel)
                    default: SectionWithComplexDescriptionView(viewModel: viewModel)
                    }
                }
                .padding(.vertical, 60)
            }
        }
        .navigationBarHidden(true)
    }
}
