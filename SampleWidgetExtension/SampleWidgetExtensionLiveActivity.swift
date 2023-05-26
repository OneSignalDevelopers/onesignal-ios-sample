//
//  OneSignal_iOS_Sample_WidgetLiveActivity.swift
//  OneSignal iOS Sample Widget
//
//  Created by William Shepherd on 4/23/23.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SampleWidgetExtensionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SampleWidgetExtensionAttributes.self) { context in
            // Create the presentation that appears on the Lock Screen and as a
            // banner on the Home Screen of devices that don't support the
            // Dynamic Island.
            // ...
            Text("View Live Activity in the Dynamic Island on iPhone 14 Pro")
        } dynamicIsland: { context in
            // Create the presentations that appear in the Dynamic Island.
            DynamicIsland {
                // Create the expanded presentation.
                DynamicIslandExpandedRegion(.leading) {
                                    Label("\(context.attributes.numberOfPizzas) Pizzas", systemImage: "bag")
                                        .foregroundColor(.indigo)
                                        .font(.title2)
                                }
                                
                                DynamicIslandExpandedRegion(.trailing) {
                                    Label {
                                        Text(timerInterval: context.state.deliveryTimer, countsDown: true)
                                            .multilineTextAlignment(.trailing)
                                            .frame(width: 50)
                                            .monospacedDigit()
                                    } icon: {
                                        Image(systemName: "timer")
                                            .foregroundColor(.indigo)
                                    }
                                    .font(.title2)
                                }
                                
                                DynamicIslandExpandedRegion(.center) {
                                    Text("\(context.state.driverName) is on their way!")
                                        .lineLimit(1)
                                        .font(.caption)
                                }
                                
                                DynamicIslandExpandedRegion(.bottom) {
                                    Button {
                                        // Deep link into your app.
                                    } label: {
                                        Label("Call driver", systemImage: "phone")
                                    }
                                    .foregroundColor(.indigo)
                                }
            } compactLeading: {
                Label {
                    Text("\(context.attributes.numberOfPizzas) Pizzas")
                } icon: {
                    Image(systemName: "bag")
                        .foregroundColor(.indigo)
                }
                .font(.caption2)
            } compactTrailing: {
                Text(timerInterval: context.state.deliveryTimer, countsDown: true)
                    .multilineTextAlignment(.center)
                    .frame(width: 40)
                    .font(.caption2)
            } minimal: {
                VStack(alignment: .center) {
                    Image(systemName: "timer")
                    Text(timerInterval: context.state.deliveryTimer, countsDown: true)
                        .multilineTextAlignment(.center)
                        .monospacedDigit()
                        .font(.caption2)
                }
            }
            .keylineTint(.cyan)
            .contentMargins(.trailing, 8, for: .expanded)
        }
    }
}

struct LockScreenLiveActivityView: View {
    let context: ActivityViewContext<SampleWidgetExtensionAttributes>
    
    var body: some View {
        VStack {
            Spacer()
            Text("\(context.state.driverName) is on their way with your pizza!")
            Spacer()
            HStack {
                Spacer()
                Label {
                    Text("\(context.attributes.numberOfPizzas) Pizzas")
                } icon: {
                    Image(systemName: "bag")
                        .foregroundColor(.indigo)
                }
                .font(.title2)
                Spacer()
                Label {
                    Text(timerInterval: context.state.deliveryTimer, countsDown: true)
                        .multilineTextAlignment(.center)
                        .frame(width: 50)
                        .monospacedDigit()
                } icon: {
                    Image(systemName: "timer")
                        .foregroundColor(.indigo)
                }
                .font(.title2)
                Spacer()
            }
            Spacer()
        }
        .activitySystemActionForegroundColor(.indigo)
        .activityBackgroundTint(.cyan)
    }
}

struct SampleWidgetExtensionPreviews: PreviewProvider {
    static let attributes = SampleWidgetExtensionAttributes(numberOfPizzas: 4, totalAmount: "$43.56", orderNumber: "27FB89")
    static let contentState = SampleWidgetExtensionAttributes.ContentState(driverName: "William", deliveryTimer: Date.now...Date())

    static var previews: some View {
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.compact))
            .previewDisplayName("Island Compact")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.expanded))
            .previewDisplayName("Island Expanded")
        attributes
            .previewContext(contentState, viewKind: .dynamicIsland(.minimal))
            .previewDisplayName("Minimal")
        attributes
            .previewContext(contentState, viewKind: .content)
            .previewDisplayName("Notification")
    }
}
