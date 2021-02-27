//
//  JoystickButton.swift
//  SmARt
//
//  Created by MacBook on 24.02.21.
//

import Foundation
import SwiftUI

struct JoystickButton: View {
    @Binding var timer: Timer?
    @State var direction: JoystickDirection
    @State var action: (JoystickDirection) -> Void
    @State var isLongPressing = false
    
    var body: some View {
        Button(action: longPressEnded, label: {
            Image(systemName: getIconName(direction))
                .frame(width: 50, height: 50)
                .foregroundColor(.white)
        })
        .simultaneousGesture(DragGesture(minimumDistance: 0)
            .onEnded { _ in longPressEnded() })
        .simultaneousGesture(LongPressGesture(minimumDuration: 0.2)
            .onEnded { _ in
                isLongPressing = true
                timer?.invalidate()
                timer = Timer.scheduledTimer(withTimeInterval: 0.02,
                                             repeats: true,
                                             block: { _ in
                    action(direction)
                })
        })}
    
    func getIconName(_ direction: JoystickDirection) -> String {
        switch direction {
        case .up: return "chevron.up"
        case .down: return "chevron.down"
        case .left: return "chevron.left"
        case .right: return "chevron.right"
        }
    }
    
    func longPressEnded() {
        isLongPressing = false
        timer?.invalidate()
    }
}
