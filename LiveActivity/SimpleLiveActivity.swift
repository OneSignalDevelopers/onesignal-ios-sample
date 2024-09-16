//
//  LiveActivityLiveActivity.swift
//  LiveActivity
//
//  Created by William Shepherd on 1/22/24.
//

import ActivityKit
import WidgetKit
import SwiftUI
import OneSignalLiveActivities

struct SimpleLiveActivityAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        // Update using the API by setting the `event_updates` parameter
        var message: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct SimpleLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: FIFALiveActivityAttributes.self) { context in
            // Lock screen/banner UI goes here
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                   Text("Trailing")
                }
                DynamicIslandExpandedRegion(.center) {
                    Text("C")
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("M")
            }
            .widgetURL(URL(string: "http://www.onesignal.com"))
            .keylineTint(Color.red)
            
            
        }
    }
}

extension SimpleLiveActivityAttributes {
    fileprivate static var preview: SimpleLiveActivityAttributes {
        SimpleLiveActivityAttributes(name: "Joe")
    }
}

extension SimpleLiveActivityAttributes.ContentState {
    fileprivate static var smiley: SimpleLiveActivityAttributes.ContentState {
        SimpleLiveActivityAttributes.ContentState(message: "👋🏽")
     }
     
}

#Preview("Expanded Dynamic Island", as: ActivityPreviewViewKind.dynamicIsland(.expanded) , using: SimpleLiveActivityAttributes.preview) {
   SimpleLiveActivity()
} contentStates: {
    SimpleLiveActivityAttributes.ContentState.smiley
}
