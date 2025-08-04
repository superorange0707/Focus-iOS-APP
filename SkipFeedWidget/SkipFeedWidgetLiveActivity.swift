//
//  SkipFeedWidgetLiveActivity.swift
//  SkipFeedWidget
//
//  Created by Wang Dechun on 2025/7/28.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SkipFeedWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct SkipFeedWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SkipFeedWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension SkipFeedWidgetAttributes {
    fileprivate static var preview: SkipFeedWidgetAttributes {
        SkipFeedWidgetAttributes(name: "World")
    }
}

extension SkipFeedWidgetAttributes.ContentState {
    fileprivate static var smiley: SkipFeedWidgetAttributes.ContentState {
        SkipFeedWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: SkipFeedWidgetAttributes.ContentState {
         SkipFeedWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: SkipFeedWidgetAttributes.preview) {
   SkipFeedWidgetLiveActivity()
} contentStates: {
    SkipFeedWidgetAttributes.ContentState.smiley
    SkipFeedWidgetAttributes.ContentState.starEyes
}
