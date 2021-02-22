//
//  ComplexDescription.swift
//  SmARt
//
//  Created by MacBook on 18.02.21.
//

import SwiftUI
import Kingfisher

struct ComplexDescriptionView: View {
    var data: [ComplexDescriptionItem]
    var chunkValue: Int
    
    var body: some View {
        let chunkedData = data.chunked(into: chunkValue)

        VStack(spacing: 10) {
            ForEach(0..<chunkedData.count) { index in
                HStack(spacing: 10) {
                    ForEach(0..<chunkedData[index].count) { innerIndex in
                        HStack {
                            KFImage(URL(string: chunkedData[index][innerIndex].icon.url))
                            Text(chunkedData[index][innerIndex].title)
                                .foregroundColor(.white)
                                .font(.system(size: 12))
                                .lineLimit(1)
                            Spacer()
                        }
                        .offset(x: 10, y: 0)
                        .padding(.vertical, 20)
                        .overlay(Image("corner")
                                    .resizable()
                                    .rotationEffect(Angle(degrees: index % 2 == 0 ? 0 : 180))
                                    .rotation3DEffect(
                                        Angle(degrees: (((index % 2 == 0) && (innerIndex % 2 == 1)) ||
                                                       ((index % 2 == 1) && (innerIndex % 2 == 0))) ? 180 : 0),
                                        axis: (x: 0, y: 1, z: 0)))
                        .cornerRadius(12)
                    }
                }
            }
        }
        .padding(.horizontal, 20)
    }
}

struct ComplexDescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        ComplexDescriptionView(data: [], chunkValue: 0)
    }
}
