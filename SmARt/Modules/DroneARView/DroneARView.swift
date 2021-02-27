//
//  DroneARView.swift
//  SmARt
//
//  Created by MacBook on 24.02.21.
//

import SwiftUI
import Combine
import MapKit

struct DroneARView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewModel: DroneARViewModel

    var body: some View {
        ZStack(alignment: .topLeading) {
            Button(action: {
                AppDelegate.orientationLock = .portrait
                changeOrientation(to: .portrait)
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .frame(width: 30, height: 30)
                    .background(Color(hex: 0xC4C4C4, alpha: 0.7))
                    .foregroundColor(.white)
                    .cornerRadius(15)
            }.frame(width: 60, height: 60, alignment: .topLeading)
            .zIndex(2)
            .padding(.top)
            
            ZStack(alignment: .bottom) {
                JoysticksWithMapView(currentRegion: $viewModel.currentRegion,
                                     leftJoystickAction: viewModel.leftJoystickAction,
                                     rightJoystickAction: viewModel.rightJoystickAction)
                .zIndex(3)
                
                DroneARViewControllerContainer(viewModel: viewModel)
                    .ignoresSafeArea()
            }
        }
        .onAppear(perform: {
            AppDelegate.orientationLock = .landscape
            changeOrientation(to: .landscapeRight)
        })
    }
    
    func changeOrientation(to orientation: UIInterfaceOrientation) {
        UIDevice.current.setValue(orientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
}
