//
//  HealthSectionView.swift
//  SmARt
//
//  Created by MacBook on 19.02.21.
//

import SwiftUI

struct HealthSectionView: View {
    var viewModel: SectionDetailBaseViewModel
    
    var body: some View {
        let objects = viewModel.section.objects ?? []
        let videos = objects.filter { $0.video != nil }
        let charts = objects.filter { $0.video == nil }
            
        VStack(spacing: 30) {
            VStack(spacing: 14) {
                ForEach(videos) { video in
                    HStack {
                        ImageFromFile(name: video.icon.id)
                            .frame(width: 54, height: 54)
                        VStack(alignment: .leading) {
                            Text(video.name)
                                .accentColor(Color.white)
                                .font(.system(size: 14))
                            Text(video.description)
                                .accentColor(Color(hex: 0x969696))
                                .font(.system(size: 10))
                        }
                        Spacer()
                        Button(action: { viewModel.handleObjectSelected(video) }) {
                            Text("VIEW")
                                .accentColor(Color.white)
                                .font(.system(size: 10))
                        }
                        .frame(width: 60, height: 20)
                        .background(Color(hex: 0x0983FD))
                        .cornerRadius(10)
                    }
                }
            }
            .frame(width: UIScreen.width - 40)
            .padding(.top)
            
            Spacer()
            
            VStack(spacing: 14) {
                ForEach(charts) { chart in
                    ImageFromFile(name: chart.icon.id)
                        .frame(width: UIScreen.width - 40, height: 120)
                        .onTapGesture { viewModel.handleObjectSelected(chart) }
                }
            }.padding()
        }
    }
}
