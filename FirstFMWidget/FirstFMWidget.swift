import WidgetKit
import SwiftUI
import Intents

struct FirstFMWidgetTimelineProvider: TimelineProvider {
    func placeholder(in context: Context) -> FirstFMWidgetTimelineEntry {
        FirstFMWidgetTimelineEntry(date: Date(), scrobblesCount: 123)
    }

    func getSnapshot(in context: Context, completion: @escaping (FirstFMWidgetTimelineEntry) -> ()) {
        let entry = FirstFMWidgetTimelineEntry(date: Date(), scrobblesCount: 123)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        FirstfmWidgetProvider().getProfile { profileResponse in
            var entries: [FirstFMWidgetTimelineEntry] = []
            var policy: TimelineReloadPolicy
            var entry: FirstFMWidgetTimelineEntry
            
            entry = FirstFMWidgetTimelineEntry(date: Date(), scrobblesCount: Int(profileResponse.user.playcount) ?? 0)
                
            policy = .after(Calendar.current.date(byAdding: .day, value: 1, to: Date())!)
            
            entries.append(entry)
            let timeline = Timeline(entries: entries, policy: policy)
            completion(timeline)
        }
    }
}

struct FirstFMWidgetTimelineEntry: TimelineEntry {
    var date: Date
    
    let scrobblesCount: Int
}

struct FirstFMWidgetEntryView : View {
    var entry: FirstFMWidgetTimelineProvider.Entry

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .bottom){
                Text("\(entry.scrobblesCount.formatted() ) scrobbles")
            }
        }
    }
}

@main
struct FirstFMWidget: Widget {
    let kind: String = "FirstFMWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: FirstFMWidgetTimelineProvider()) { entry in
            FirstFMWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Astronomy picture of the day")
        .description("This is a widget that shows the astronomy picture of the day.")
    }
}

struct FirstFMWidget_Previews: PreviewProvider {
    static var previews: some View {
        FirstFMWidgetEntryView(entry: FirstFMWidgetTimelineEntry(date: Date(), scrobblesCount: 123))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    
    }
}
