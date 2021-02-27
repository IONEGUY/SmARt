//
//  Covering5GView.swift
//  SmARt
//
//  Created by MacBook on 2/11/21.
//

import SwiftUI

struct SectionDetailContainerView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: SectionDetailContainerViewModel
    
    init(sectionInfo: Section?) {
        viewModel = SectionDetailContainerViewModel(sectionInfo: sectionInfo)
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            NavigationLink(destination: SmartRoomARView(viewModel:
                               SmartRoomARViewModel(object3dUrls: viewModel.object3dUrls,
                                                    augmentedObjectType: viewModel.augmentedObjectType)),
                           isActive: $viewModel.pushSmartRoomARViewActive,
                           label: { Text("") }).hidden()
            NavigationLink(destination: MaskFittingView(viewModel:
                               MaskFittingViewModel(masks: viewModel.masks)),
                           isActive: $viewModel.pushMaskFittingViewActive,
                           label: { Text("") }).hidden()
            NavigationLink(destination: DroneARView(viewModel:
                               DroneARViewModel(droneModelUrl: viewModel.object3dUrls.first ?? .empty)),
                           isActive: $viewModel.pushDroneARViewActive,
                           label: { Text("") }).hidden()
            
            Image("section_background")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                ZStack {
                    HStack {
                        Button(action: { presentationMode.wrappedValue.dismiss() }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.white)
                        }.frame(width: 60, height: 40)
                        Spacer()
                    }.frame(width: UIScreen.width, height: 40)
                    Text(viewModel.title)
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                        .font(.title3)
                }.frame(width: UIScreen.width, height: 40)
                
                switch viewModel.sectionType {
                case .droneSection, .smartRoom, .section5G, .smartRetail:
                    SectionWithComplexDescriptionView(section: viewModel.sectionInfo,
                                                      getStartedButtonText: viewModel.getStartedButtonText,
                                                      objectSelected: viewModel.objectSelected,
                                                      getStartedButtonAction: viewModel.getStartedButtonPressed)
                case .healthSection:
                    HealthSectionView(objects: viewModel.sectionInfo?.objects ?? [],
                                      getStartedButtonText: viewModel.getStartedButtonText,
                                      objectSelected: viewModel.objectSelected,
                                      getStartedButtonAction: viewModel.getStartedButtonPressed)
                case .smartTourism:
                    SmartTourismView(objects: viewModel.sectionInfo?.objects ?? [],
                                     objectSelected: viewModel.objectSelected,
                                     sectionDescription: viewModel.sectionDescription)
                        .padding(.top, 40)
                default:
                    EmptyView()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct SectionView_Previews: PreviewProvider {
    static var previews: some View {
        SectionDetailContainerView(sectionInfo: nil)
    }
}
