//
//  SkipFeedWidgetBundle.swift
//  SkipFeedWidget
//
//  Created by Wang Dechun on 2025/7/28.
//

import WidgetKit
import SwiftUI

@main
struct SkipFeedWidgetBundle: WidgetBundle {
    var body: some Widget {
        SkipFeedWidget()
        SkipFeedWidgetControl()
        SkipFeedWidgetLiveActivity()
    }
}
