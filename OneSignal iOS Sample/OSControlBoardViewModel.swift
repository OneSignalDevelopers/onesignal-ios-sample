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
    
    init(text: String, action: @escaping () -> Void) {
        self.text = text
        self.action = action // Store the closure, don't call it
    }
}

class OSControlBoardViewModel: ObservableObject {
    @Published var isPushEnabled: Bool
    @Published var isSubscribed: Bool
    @Published var isLoggedIn: Bool

    // The Activity must be bound to a unique ActivityId
    // This is how OneSignal knows about your activity
    private var simpleLiveActivityId = "unique_simple_id"
    // Note that OneSignal does not know anything about
    // you ActivityAttributes structure; Use the Activity ID
    // to help keep track of each Activities' ActivityAttributes
    private var simpleLiveActivity: Activity<SimpleLiveActivityAttributes>? = nil
    
    private var FIFALiveActivityId = "sui_vs_ger_2024_06_23"
    private var FIFALiveActivity: Activity<FIFALiveActivityAttributes>? = nil
    
    init() {
        isLoggedIn = OneSignal.User.externalId != nil
        isPushEnabled = OneSignal.Notifications.permission
        isSubscribed = OneSignal.User.pushSubscription.optedIn
    }
    
    var LoginAction: ButtonAction {
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
    
    var RequestPushPermissionAction: ButtonAction {
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
    
    var subscribeToPushAction: ButtonAction {
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
    
    var canRequestPushPermission: Bool {
        OneSignal.Notifications.canRequestPermission
    }
    
    var SimpleLiveActivityAction: ButtonAction {
        if simpleLiveActivity != nil {
            return ButtonAction(text: "End Simple Live Activity", action: { [weak self] in
                self?.stopSimpleLiveActivity()
            })
        } else {
            return ButtonAction(text: "Start Simple Live Activity", action: { [weak self] in
                self?.startSimpleLiveActivity()
            })
        }
    }
    
    var FIFALiveActivityAction: ButtonAction {
        if FIFALiveActivity != nil {
            return ButtonAction(text: "End FIFA Live Activity", action: { [weak self] in
                self?.stopFIFALiveActivity()
            })
        } else {
            return ButtonAction(text: "Start FIFA Live Activity", action: { [weak self] in
                self?.startFIFALiveActivity()
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
    
    func startSimpleLiveActivity() {
        let attributes = SimpleLiveActivityAttributes(name: "him")
        let contentState = SimpleLiveActivityAttributes.ContentState(message: "👋🏽")
        let activityContent = ActivityContent(state: contentState, staleDate: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!)
        
        do {
            simpleLiveActivity = try Activity<SimpleLiveActivityAttributes>.request(
                attributes: attributes,
                content: activityContent,
                pushType: .token)
                
            Task {
                for await data in simpleLiveActivity!.pushTokenUpdates {
                    let token = data.map {String(format: "%02x", $0)}.joined()
                    print("Simple Live Activity Push Token::", token)
                    OneSignal.LiveActivities.enter(simpleLiveActivityId, withToken: token)
                    print("Simple Live Activity Started")
                }
            }
         } catch (let error) {
             print(error.localizedDescription)
         }
    }
    
    func stopSimpleLiveActivity() {
        if simpleLiveActivity == nil {
            return
        }
            
        simpleLiveActivity = nil
        OneSignal.LiveActivities.exit(simpleLiveActivityId)
        print("Simple Live Activity Stopped")
    }
    
    func startFIFALiveActivity() {
        let attributes = FIFALiveActivityAttributes(name: "Switzerland vs. Germany", homeTeam: "Switzerland", awayTeam: "Germany", fifaLogo: "fifa_logo", sponsorLogo: "cocacola_logo")
        let contentState = FIFALiveActivityAttributes.ContentState(homeScore: 0, awayScore: 0)
        let activityContent = ActivityContent(state: contentState, staleDate: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!)
        
        do {
            FIFALiveActivity = try Activity<FIFALiveActivityAttributes>.request(
                 attributes: attributes,
                 content: activityContent,
                 pushType: .token)
            
            Task {
                for await data in FIFALiveActivity!.pushTokenUpdates {
                    let token = data.map {String(format: "%02x", $0)}.joined()
                    print("FIFA Live Activity Push Token::", token)
                    OneSignal.LiveActivities.enter(FIFALiveActivityId, withToken: token)
                    print("FIFA Live Activity Started")
                }
            }
         } catch (let error) {
             print(error.localizedDescription)
         }
    }
    
    func stopFIFALiveActivity() {
        if FIFALiveActivity == nil {
            return
        }
        
        FIFALiveActivity = nil
        OneSignal.LiveActivities.exit(FIFALiveActivityId)
        print("FIFA Live Activity Stopped")
    }
    
    @available(iOS 17.2, *)
    func setupFIFALiveActivityPushToStart() {
        Task {
            for try await data in Activity<FIFALiveActivityAttributes>.pushToStartTokenUpdates {
                let token = data.map { String(format: "%02x", $0) }.joined()
                OneSignal.LiveActivities.setPushToStartToken(FIFALiveActivityAttributes.self, withToken: token)
                print("FIFA Live Activity pushToStart Token:: \(token)")
            }
        }
    }
}
