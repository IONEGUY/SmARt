//
//  SmARtApp.swift
//  SmARt
//
//  Created by MacBook on 2/3/21.
//

import SwiftUI
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

@main
struct SmARtApp: App {
    @Environment(\.scenePhase) var scenePhase
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    private let appCenterAppSecret = "Needs to be created in AppCenter."

    init() {
        DIContainerConfigurator.initiate()
        initCrashlytics()
    }

    var body: some Scene {
        WindowGroup {
            MenuView()
        }
        .onChange(of: scenePhase) { (newScenePhase) in
            switch newScenePhase {
            case .background: break
            case .inactive: break
            case .active: break
            @unknown default: break
            }
        }
    }

    private func initCrashlytics() {
//        AppCenter.start(withAppSecret: appCenterAppSecret,
//                        services: [Analytics.self, Crashes.self])
    }
}
