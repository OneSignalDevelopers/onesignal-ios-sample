//
//  OSControlBoardViewModel.swift
//  OneSignal iOS Sample
//
//  Created by William Shepherd on 6/22/24.
//

import Foundation
import ActivityKit
import OneSignalFramework
import OneSignalLiveActivities

struct ButtonAction {
    let text: String
    let action: () -> Void
}

class OSControlBoardViewModel: ObservableObject, OSUserStateObserver, OSPushSubscriptionObserver {
    @Published var isPushEnabled: Bool
    @Published var isSubscribed: Bool
    @Published var isLoggedIn: Bool
    @Published var isDeviceLiveActivityRunning: Bool

    
    private var activity: Activity<LiveActivityAttributes>? = nil
    private var activityId: String = "live_activity_id"
    
    init() {
        isLoggedIn = OneSignal.User.externalId != nil
        isPushEnabled = OneSignal.Notifications.permission
        isSubscribed = OneSignal.User.pushSubscription.optedIn
        isDeviceLiveActivityRunning = false
    }
    
    var loginBtn: ButtonAction {
        if isLoggedIn {
            return ButtonAction(text: "Logout", action: { [weak self] in
                OneSignal.logout()
                DispatchQueue.main.async {
                    self?.isLoggedIn = false
                }
            })
        } else {
            return ButtonAction(text: "Login", action: { [weak self] in
                OneSignal.login("him@kronos.local")
                DispatchQueue.main.async {
                    self?.isLoggedIn = true
                }
            })
        }
    }
    
    var requestPushPermissionBtn: ButtonAction {
        if isPushEnabled {
            return ButtonAction(
                text: "Push Permission Granted",
                action: { }
            )
        } else {
            return ButtonAction(
                text: "Request Push Permission",
                action: { OneSignal.Notifications.requestPermission() }
            )
        }
    }
    
    var subscribePushBtn: ButtonAction {
        if isSubscribed {
            return ButtonAction(
                text: "Unsubscribe from Push Notifications",
                action: { [weak self] in
                    OneSignal.User.pushSubscription.optOut()
                    self?.isSubscribed = false
                })
        } else {
            return ButtonAction(
                text: "Subscribe to Push Notifications",
                action: { [weak self] in
                    OneSignal.User.pushSubscription.optIn()
                    self?.isSubscribed = true
                })
        }
    }
    
    var externalId: String {
        OneSignal.User.externalId ?? "Anonymous User"
    }
    
    var onesignalId: String {
        OneSignal.User.onesignalId ?? "N/A"
    }
    
    var startLiveActivityBtn: ButtonAction {
        if isDeviceLiveActivityRunning {
            return ButtonAction(text: "End Live Activity", action: { [weak self] in
                self?.stopLiveActivity()
            })
        } else {
            return ButtonAction(text: "Start Live Activity", action: { [weak self] in
                self?.startLiveActivity()
            })
        }
    }
    
    func presentIAM() {
        OneSignal.InAppMessages.addTrigger("TESTITY_TEST_TEST", withValue: "test")
    }
    
    func presentPushPermissionSoftPrompt() {
        OneSignal.InAppMessages.addTrigger("show_push_permission_prompt", withValue: "1")
    }
    
    func presentPreferenceCenter() {
        OneSignal.InAppMessages.addTrigger("preferences", withValue: "show")
    }
    
    @available(iOS 17.2, *)
    func setupPushToStartToken() {
        Task {
            for try await data in Activity<LiveActivityAttributes>.pushToStartTokenUpdates {
                let token = data.map { String(format: "%02x", $0) }.joined()
                print("Push-to-start Token:: \(token)")
                
                OneSignal.LiveActivities.setPushToStartToken(LiveActivityAttributes.self, withToken: token)
            }
        }
    }
    
    func startLiveActivity() {
        let attributes = LiveActivityAttributes(name: "Switzerland vs. Germany", homeTeam: "Switzerland", awayTeam: "Germany", fifaLogo: "fifa_logo", sponsorLogo: "cocacola_logo")
        let contentState = LiveActivityAttributes.ContentState(homeScore: 0, awayScore: 0)
        let activityContent = ActivityContent(state: contentState, staleDate: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!)
        
        do {
            let activity = try Activity<LiveActivityAttributes>.request(
                 attributes: attributes,
                 content: activityContent,
                 pushType: .token)
            
            Task {
                for await data in activity.pushTokenUpdates {
                    let token = data.map {String(format: "%02x", $0)}.joined()
                    print("Live Activity Push Token:: ", token)
                    OneSignal.LiveActivities.enter(activityId, withToken: token)
                    DispatchQueue.main.async {
                        self.isDeviceLiveActivityRunning = true
                    }
                }
            }
         } catch (let error) {
             print(error.localizedDescription)
         }
    }
    
    func stopLiveActivity() {
        OneSignal.LiveActivities.exit(activityId)
        DispatchQueue.main.async {
            self.isDeviceLiveActivityRunning = false
        }
    }
    
    func onUserStateDidChange(state: OneSignalUser.OSUserChangedState) {
        print("#USER_CHANGED")
        print("OneSignal ID:: ", state.current.onesignalId ?? "Unknown OneSignal ID")
        print("External ID:: ", state.current.externalId ?? "Anonymous User")
        print("State:: ", state.current.jsonRepresentation())
        
        DispatchQueue.main.async {
            self.isLoggedIn = state.current.externalId != nil
        }
    }
    

    func onPushSubscriptionDidChange(state: OSPushSubscriptionChangedState) {
        print("#PUSH_SUBSCRIPTION_CHANGED")
        print("State:: ", state.jsonRepresentation())
        
        DispatchQueue.main.async {
            self.isSubscribed = state.current.optedIn
        }
    }
}
