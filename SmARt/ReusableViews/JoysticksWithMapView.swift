//
//  JoysticksBar.swift
//  SmARt
//
//  Created by MacBook on 26.02.21.
//

import SwiftUI
import MapKit

struct JoysticksWithMapView: View {
    @State var currentRegion: MKCoordinateRegion
    @State var leftJoystickAction: (JoystickDirection) -> Void
    @State var rightJoystickAction: (JoystickDirection) -> Void
    
    var body: some View {
        HStack {
            Joystick(action: leftJoystickAction)
            Map(coordinateRegion: $currentRegion,
                showsUserLocation: true)
                .frame(height: 60)
                .cornerRadius(10)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 24, style: .continuous)
                            .stroke(Color(hex: 0xC4C4C4, alpha: 0.2),lineWidth: 20))
                .padding(.horizontal, 80)
            Joystick(action: rightJoystickAction)
        }
        .padding()
    }
}
