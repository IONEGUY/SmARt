//
//  LoadingView.swift
//  SmARt
//
//  Created by MacBook on 2.03.21.
//

import SwiftUI
import Lottie
import UIKit
import Combine
//
//struct LoadingView: View {
//    @State var text: String
//    func updateText(_ text: String) {
//        self.text = "\(text)"
//    }
//
//    var body: some View {
//        VStack {
//            SpinnerViewRepresentable()
//            Spacer()
//            Text(text)
//                .multilineTextAlignment(.center)
//                .lineLimit(nil)
//                .foregroundColor(.white)
//                .font(.system(size: 15, weight: .heavy))
//                .padding(.bottom, 30)
//        }
//        .frame(width: 200, height: 200)
//        .background(LinearGradient(gradient: Gradient(colors: [Color(hex: 0x3C506A),
//                                                               Color(hex: 0x1D242E)]),
//                                   startPoint: .top, endPoint: .bottom))
//        .cornerRadius(16)
//    }
//}
//
//fileprivate struct SpinnerViewRepresentable: UIViewRepresentable {
//    func makeUIView(context: Context) -> UIView {
//        let view = UIView()
//        let animationView = AnimationView(name: "loading_animation")
//        animationView.loopMode = .loop
//        view.addSubview(animationView)
//        animationView.fillSuperview()
//        animationView.play()
//        return view
//    }
//
//    func updateUIView(_ uiView: UIView, context: Context) {}
//}

class LoadingView: UIView {
    private var startingFrame: CGFloat = 0
    private var animationView = AnimationView(name: "loading_animation")
    
    func setup() {
        layer.cornerRadius = 16
        animationView.contentMode = .scaleToFill
        animationView.backgroundColor = .blue
        animationView.loopMode = .playOnce
        addSubview(animationView)
        animationView.fillSuperview()
    }
    
    func updateProgress(_ percentDownloaded: CGFloat) {
        animationView.play(fromFrame: startingFrame,
                           toFrame: percentDownloaded * 180,
                           loopMode: .playOnce,
                           completion: nil)
        startingFrame = percentDownloaded
    }
}
