//
//  OneSignal_iOS_SampleApp.swift
//  OneSignal iOS Sample
//
//  Created by William Shepherd on 4/14/23.
//

import SwiftUI
import ActivityKit
import OneSignalFramework
import OneSignalLiveActivities

@main
struct OneSignal_iOS_SampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            OSControlBoardView()
                .environmentObject(appDelegate.vm!)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate, OSInAppMessageLifecycleListener, OSNotificationPermissionObserver, OSUserStateObserver, OSPushSubscriptionObserver  {
    var vm: OSControlBoardViewModel?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
//        OneSignal.Debug.setLogLevel(.LL_VERBOSE)
        OneSignal.initialize("202d4f61-1ca9-42df-9d36-bb17d8613abf", withLaunchOptions: launchOptions)
          
        vm = OSControlBoardViewModel()
//        Setup pushToStartToken if iOS version supports it
        if #available(iOS 17.2, *) {
            vm?.setupFIFALiveActivityPushToStart()
        }
        
        OneSignal.Notifications.addPermissionObserver(self)
        OneSignal.User.addObserver(self)
        OneSignal.User.pushSubscription.addObserver(self)
    
        return true
    }
    
    func onNotificationPermissionDidChange(_ permission: Bool) {
        print("#PUSH_PERMISSION_CHANGED")
        print("Permission:: ", permission)
    
        DispatchQueue.main.async {
            self.vm?.isPushEnabled = permission
        }
    }
    
    func onPushSubscriptionDidChange(state: OSPushSubscriptionChangedState) {
        print("#PUSH_SUBSCRIPTION_CHANGED")
        print("State:: ", state.jsonRepresentation())
        
        DispatchQueue.main.async {
            self.vm?.isSubscribed = state.current.optedIn
        }
    }
    
    func onUserStateDidChange(state: OneSignalUser.OSUserChangedState) {
        print("#USER_CHANGED")
        print("OneSignal ID:: ", state.current.onesignalId ?? "Unknown OneSignal ID")
        print("External ID:: ", state.current.externalId ?? "Anonymous User")
        print("State:: ", state.current.jsonRepresentation())
        
        DispatchQueue.main.async {
            self.vm?.isLoggedIn = state.current.externalId != nil
        }
    }

}
