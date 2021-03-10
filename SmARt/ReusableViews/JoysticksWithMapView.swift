//
//  JoysticksBar.swift
//  SmARt
//
//  Created by MacBook on 26.02.21.
//

import SwiftUI
import MapKit
import Combine

struct JoysticksWithMapView: View {
    @State var leftJoystickAction: (JoystickDirection) -> Void
    @State var rightJoystickAction: (JoystickDirection) -> Void
    
    @ObservedObject fileprivate var viewModel = JoysticksWithMapViewModel()
    
    var body: some View {
        HStack {
            Joystick(action: leftJoystickAction)
            Map(coordinateRegion: $viewModel.currentRegion,
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

fileprivate class JoysticksWithMapViewModel: ObservableObject {
    private var cancellabes = Set<AnyCancellable>()
    
    @Published var currentRegion = MKCoordinateRegion()
    
    init() {
        LocationManager.shared.onLocationUpdated
            .first()
            .map { MKCoordinateRegion(center: $0, span:
                       MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002)) }
            .assign(to: \.currentRegion, on: self)
            .store(in: &cancellabes)
    }
}
