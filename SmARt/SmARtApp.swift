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
    
    private let appCenterAppSecret = "Needs to be created in AppCenter."
    
    init() {
        DIContainerConfigurator.initiate()
        initCrashlytics()
        initializeStartView()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
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
        AppCenter.start(withAppSecret: appCenterAppSecret,
                        services: [Analytics.self, Crashes.self])
    }
    
    private func initializeStartView() {
    }
}
