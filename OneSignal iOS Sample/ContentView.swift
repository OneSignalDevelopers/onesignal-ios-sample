//
//  ContentView.swift
//  OneSignal iOS Sample
//
//  Created by William Shepherd on 4/14/23.
//

import SwiftUI
import ActivityKit
import OneSignalFramework
import SampleWidgetExtensionExtension

struct ContentView: View {
    @State private var activity: Activity<SportsLiveActivityAttributes>? = nil
    
    let activityId = "SOME_LA_ID"
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("OneSignal iOS Sample")
          
            Button(action: {
                OneSignal.User.pushSubscription.optIn()
            }) {
                Text("Enable Push")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
                OneSignal.User.pushSubscription.optOut()
            }) {
                Text("Disable Push")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
                OneSignal.InAppMessages.addTrigger("show_push_permission_prompt", withValue: "1")
            }) {
                Text("Prompt Push Permission")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
                OneSignal.InAppMessages.addTrigger("TESTITY_TEST_TEST", withValue: "test")
            }) {
                Text("Present In-app Message")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
               startActivity()
            }) {
                Text("Start Live Activity")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
               stopActivity()
            }) {
                Text("End Live Activity")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
    
    func startActivity() {
        let future = Calendar.current.date(byAdding: .minute, value: (Int(15) ), to: Date())!
        let attributes = SportsLiveActivityAttributes(timer: Date.now...future, imageLeft: "Knights", teamNameLeft: "Knights", imageRight: "Pirates", teamNameRight: "Pirates", gameName: "Western Conference Round 1")
        let contentState = SportsLiveActivityAttributes.ContentState(quarter: 1, scoreLeft: 0, scoreRight: 0, bottomText: "The game has started!")
        let activityContent = ActivityContent(state: contentState, staleDate: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!)

        do {
            activity = try Activity<SportsLiveActivityAttributes>.request(
                 attributes: attributes,
                 content: activityContent,
                 pushType: .token)
            
            Task {
                for await data in activity!.pushTokenUpdates {
                    let token = data.map {String(format: "%02x", $0)}.joined()
                    print("Live Activity Push Token: ", token)
                    OneSignal.LiveActivities.enter(activityId, withToken: token)
                }
            }
         } catch (let error) {
             print(error.localizedDescription)
         }
    }
    
    func stopActivity() {
        OneSignal.LiveActivities.exit(activityId)
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
