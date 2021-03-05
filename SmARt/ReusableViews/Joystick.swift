//
//  Joystick.swift
//  SmARt
//
//  Created by MacBook on 24.02.21.
//

import SwiftUI

struct Joystick: View {
    @State var timer: Timer? = Timer()
    @State var action: (JoystickDirection) -> Void
    
    var body: some View {
        ZStack {
            VStack(alignment: .center) {
                Circle()
                    .foregroundColor(Color(hex: 0xC4C4C4, alpha: 0.7))
                    .frame(width: 70, height: 70)
            }
            .frame(width: 100, height: 100)
            .overlay(Circle().stroke(Color(hex: 0xC4C4C4, alpha: 0.2),lineWidth: 20))
            .foregroundColor(Color.red)
            
            VStack {
                JoystickButton(timer: $timer, direction: .up, action: action)
                HStack {
                    JoystickButton(timer: $timer, direction: .left, action: action)
                    Spacer()
                    JoystickButton(timer: $timer, direction: .right, action: action)
                }.frame(width: 150, height: 50)
                JoystickButton(timer: $timer, direction: .down, action: action)
            }.frame(width: 110, height: 110)
            .zIndex(1)
        }
    }
}
