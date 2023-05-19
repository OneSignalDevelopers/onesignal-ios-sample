//
//  OneSignal_iOS_Sample_WidgetBundle.swift
//  OneSignal iOS Sample Widget
//
//  Created by William Shepherd on 4/23/23.
//

import WidgetKit
import SwiftUI

@main
struct OneSignal_iOS_Sample_WidgetBundle: WidgetBundle {
    var body: some Widget {
        OneSignal_iOS_Sample_Widget()
        OneSignal_iOS_Sample_WidgetLiveActivity()
    }
}
