//
//  OneSignal_iOS_SampleApp.swift
//  OneSignal iOS Sample
//
//  Created by William Shepherd on 4/14/23.
//

import SwiftUI
import ActivityKit
import OneSignalFramework

@main
struct OneSignal_iOS_SampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate, OSInAppMessageLifecycleHandler {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        OneSignal.initialize("202d4f61-1ca9-42df-9d36-bb17d8613abf", withLaunchOptions: launchOptions)
        OneSignal.InAppMessages.setLifecycleHandler(self)
    
        return true
    }
    
    func onWillDisplay(_ message: OSInAppMessage) {
        print("IAM onWillDisplay \(message)")
    }
    
    func onDidDisplay(_ message: OSInAppMessage) {
        print("IAM onDidDisplay \(message)")
    }
    
    func onWillDismiss(_ message: OSInAppMessage) {
        print("IAM onWillDismiss \(message)")
    }
    
    func onDidDismiss(_ message: OSInAppMessage) {
        print("IAM onDidDismiss \(message)")
    }
}
