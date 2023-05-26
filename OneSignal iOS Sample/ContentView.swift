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
    @State private var activity: Activity<SampleWidgetExtensionAttributes>? = nil
    
    let activityId = "Some_LA_ID"
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            
            Text("Hello, world!")
            
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
        let attributes =  SampleWidgetExtensionAttributes(numberOfPizzas: 4, totalAmount: "$45.43", orderNumber: "420")
        let contentState = SampleWidgetExtensionAttributes.ContentState(driverName: "William", deliveryTimer: Date.now...Date())
        let activityContent = ActivityContent(state: contentState, staleDate: Calendar.current.date(byAdding: .minute, value: 30, to: Date())!)

        do {
            activity = try Activity<SampleWidgetExtensionAttributes>.request(
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
