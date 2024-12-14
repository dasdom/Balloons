//  Created by Dominik Hauser on 26.11.24.
//  
//


import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> BirthdaysEntry {
        BirthdaysEntry(date: .now, birthdays: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (BirthdaysEntry) -> ()) {
        let entry = BirthdaysEntry(date: .now, birthdays: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<BirthdaysEntry>) -> ()) {

        let storage = DDHStorage()
        let birthdays = storage.birthdays()

        var entries: [BirthdaysEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        entries.append(BirthdaysEntry(date: .now, birthdays: birthdays))

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }

    //    func relevances() async -> WidgetRelevances<Void> {
    //        // Generate a list containing the contexts this widget is relevant in.
    //    }
}

struct Widgets: Widget {
    let kind: String = "Widgets"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                BirthdaysEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                BirthdaysEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

#Preview(as: .systemSmall) {
    Widgets()
} timeline: {
    BirthdaysEntry(date: .now, birthdays: [])
}
