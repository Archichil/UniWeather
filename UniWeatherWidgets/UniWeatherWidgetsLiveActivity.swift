//
//  UniWeatherWidgetsLiveActivity.swift
//  UniWeatherWidgets
//
//  Created by Daniil on 19.04.25.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct UniWeatherWidgetsAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct UniWeatherWidgetsLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: UniWeatherWidgetsAttributes.self) { context in
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

extension UniWeatherWidgetsAttributes {
    fileprivate static var preview: UniWeatherWidgetsAttributes {
        UniWeatherWidgetsAttributes(name: "World")
    }
}

extension UniWeatherWidgetsAttributes.ContentState {
    fileprivate static var smiley: UniWeatherWidgetsAttributes.ContentState {
        UniWeatherWidgetsAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: UniWeatherWidgetsAttributes.ContentState {
         UniWeatherWidgetsAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: UniWeatherWidgetsAttributes.preview) {
   UniWeatherWidgetsLiveActivity()
} contentStates: {
    UniWeatherWidgetsAttributes.ContentState.smiley
    UniWeatherWidgetsAttributes.ContentState.starEyes
}
