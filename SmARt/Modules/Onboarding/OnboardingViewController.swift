//
//  OnboardingViewController.swift
//  SmARt
//
//  Created by MacBook on 19.03.21.
//

import Foundation
import UIKit
import SwiftUI
import Combine

class OnboardingViewController: UIViewController {
    private var cancellableSet = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewModel = OnboardingViewModel()
        let onboardingView = UIHostingController(rootView: OnboardingView(viewModel: viewModel))
        addChild(onboardingView)
        view.addSubview(onboardingView.view)
        onboardingView.view.fillSuperview()
        
        viewModel.pushMenuPage
            .receive(on: RunLoop.main)
            .sink(receiveValue: setRootVC)
            .store(in: &cancellableSet)
    }
    
    private func setRootVC() {
        var window: UIWindow?
        if (UIApplication.shared.delegate as? AppDelegate)?.window == nil {
            window = UIWindow(frame: UIScreen.main.bounds)
            (UIApplication.shared.delegate as? AppDelegate)?.window = window
        } else {
            window = (UIApplication.shared.delegate as? AppDelegate)?.window
        }
        
        window?.rootViewController =
            UINavigationController(rootViewController: MenuViewController(viewModel: MenuViewModel()))
        window?.makeKeyAndVisible()
    }
}
