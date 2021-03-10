//
//  SmartTourismView.swift
//  SmARt
//
//  Created by MacBook on 24.02.21.
//

import SwiftUI
import Combine

struct SmartTourismView: View {
    var objects: [ObjectData]
    var objectSelected: (ObjectData) -> Void
    var sectionDescription: String
    
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                HStack {
                    Text(sectionDescription)
                        .frame(width: UIScreen.width - UIScreen.width / 2)
                        .lineLimit(nil)
                        .foregroundColor(.white)
                        .font(.system(size: 20, weight: .heavy))
                    Spacer()
                }
                HStack {
                    Spacer()
                    Image("location")
                        .resizable()
                        .frame(width: 100, height: 100)
                }
                              
            }
            .padding(.horizontal, 30)
            .frame(width: UIScreen.width - 60, height: 230)
            .background(
                LinearGradient(gradient: Gradient(colors: [
                                   Color(hex: 0x667CE7),
                                   Color(hex: 0x6973DA),
                                   Color(hex: 0x6B6CD0),
                                   Color(hex: 0x6F60C0),
                                   Color(hex: 0x7258B4),
                                   Color(hex: 0x7352AC),
                                   Color(hex: 0x754DA5)]),
                               startPoint: .leading,
                               endPoint: .trailing))
            .cornerRadius(26)
            
            Spacer()
            
            Text("Watch now")
                .frame(width: UIScreen.width - 60,
                       height: 30,
                       alignment: .leading)
                .foregroundColor(Color(hex: 0x0983FD))
                .font(.system(size: 30, weight: .heavy))
            
            VStack(spacing: 14) {
                ForEach(objects) { object in
                    ImageFromFile(name: object.icon.id)
                        .frame(width: UIScreen.width - 40, height: 140)
                        .onTapGesture { objectSelected(object) }
                }
            }.padding()
        }
    }
}
