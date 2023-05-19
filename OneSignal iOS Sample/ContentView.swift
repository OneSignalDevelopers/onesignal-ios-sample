//
//  ContentView.swift
//  OneSignal iOS Sample
//
//  Created by William Shepherd on 4/14/23.
//

import SwiftUI
import OneSignalFramework

struct ContentView: View {
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
                OneSignal.LiveActivities.enter("activityId", withToken: "token")
            }) {
                Text("Start Live Activity")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
