//
//  YPDWidget.swift
//  YPDWidget
//
//  Created by Aaron Baw on 06/08/2020.
//  Copyright © 2020 Ventr. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    public typealias Entry = SimpleEntry

    public func snapshot(with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    // What is the purpose of the timeline? What does this help us to achieve with regards to widgets?
    public func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
}

struct PlaceholderView : View {
    var body: some View {
        Text("Loading")
    }
}

struct YPDWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
//        Text(entry.date, style: .time)
//
//        YPDRecentCheckinView(displayedCheckin: _sampleCheckin)
//        YPDCardView(aboveFold: {
//            Text("Insights Overview")
//        }, mainContent: {
//            Text("Your vitality has dropped this week.")
//        }, belowFold: {
//            Text("10 Days Ago")
//        }, displayShadow: false, hideBelowFoldSeparator: false)
        
        YPDRecentCheckinView(displayedCheckin: _sampleCheckin, displayShadow: false)
    }
}

@main
struct YPDWidget: Widget {
    private let kind: String = "YPDWidget"

    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(), placeholder: PlaceholderView()) { entry in
            YPDWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct YPDWidget_Previews: PreviewProvider {
    static var previews: some View {
        YPDWidgetEntryView(entry: .init(date: Date())).previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
