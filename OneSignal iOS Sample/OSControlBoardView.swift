//
//  ContentView.swift
//  OneSignal iOS Sample
//
//  Created by William Shepherd on 4/14/23.
//

import SwiftUI
import ActivityKit
import OneSignalFramework

struct OSControlBoardView: View {
    @EnvironmentObject var vm: OSControlBoardViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Image(systemName: "bell.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                    .padding(.top, 40)

                Text("OneSignal iOS Sample")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.bottom, 20)

                VStack(spacing: 15) {
                    Group {
                        Text(vm.onesignalId)
                        Text(vm.externalId)
                    }
                    
                    ActionButton(title: vm.LoginAction.text, action: vm.LoginAction.action)
            
                    ActionButton(title: vm.RequestPushPermissionAction.text, action: vm.RequestPushPermissionAction.action)
                        .disabled(!vm.canRequestPushPermission)

                    ActionButton(title: "Soft Prompt Push Permission", action: {
                        vm.presentPushPermissionSoftPrompt()
                    }).disabled(vm.isPushEnabled)
                    
                    ActionButton(title: vm.subscribeToPushAction.text, action: vm.subscribeToPushAction.action)
                    
 
                    ActionButton(title: "Present In-app Message", action: {
                        vm.presentIAM()
                    })

//                    ActionButton(title: vm.FIFALiveActivityAction.text, action: vm.FIFALiveActivityAction.action)
                    ActionButton(title: vm.SimpleLiveActivityAction.text, action: vm.SimpleLiveActivityAction.action)

                    ActionButton(title: "Show Preference Center", action: {
                        vm.presentPreferenceCenter()
                    }, buttonColor: .orange)
                }

                Spacer()
            }
            .navigationTitle("Control Board")
            .navigationBarTitleDisplayMode(.inline)
            .padding()
        }
    }
}

struct ActionButton: View {
    let title: String
    let action: () -> Void
    var buttonColor: Color = .blue

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.body)
                .frame(maxWidth: .infinity)
                .padding()
                .background(buttonColor)
                .foregroundColor(.white)
                .cornerRadius(8)
        }
        .padding(.horizontal)
        .buttonStyle(PlainButtonStyle())
    }
}


struct ContentView_Previews: PreviewProvider {
    static let previewVm = OSControlBoardViewModel()
    static var previews: some View {
        OSControlBoardView().environmentObject(previewVm)
    }
}
