//
//  AppDelegate.swift
//  SmARt
//
//  Created by MacBook on 25.02.21.
//

import Foundation
import UIKit
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes
import Alamofire

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var userDefaults = UserDefaults.standard
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GlobalStyles.initialize()
        initializeWindow()
        initCrashlytics()
        return true
    }
    
    private func initializeWindow() {
        let rootViewController: UIViewController
        if userDefaults.bool(forKey: "App Already Installed") {
            rootViewController = MenuViewController(viewModel: MenuViewModel())
        } else {
            rootViewController = OnboardingViewController()
            userDefaults.set(true, forKey: "App Already Installed")
        }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()
    }
    
    private func initCrashlytics() {
        AppCenter.start(withAppSecret: "c82edc1f-13cc-4d6d-bb8d-dfebea4761dd",
                        services: [ Analytics.self, Crashes.self ])
    }
    
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        debugPrint("handleEventsForBackgroundURLSession: \(identifier)")
        completionHandler()
    }
}
