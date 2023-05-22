//
//  SampleWidgetExtensionAttributes.swift
//  SampleWidgetExtensionExtension
//
//  Created by William Shepherd on 5/22/23.
//

import Foundation
import ActivityKit

struct SampleWidgetExtensionAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var driverName: String
        var deliveryTimer: ClosedRange<Date>
    }

    // Fixed non-changing properties about your activity go here!
    var numberOfPizzas: Int
    var totalAmount: String
    var orderNumber: String
}
