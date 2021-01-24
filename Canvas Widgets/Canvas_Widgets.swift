//
//  Canvas_Widgets.swift
//  Canvas Widgets
//
//  Created by Malcolm Anderson on 1/24/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> GradesEntry {
        GradesEntry(date: Date(), configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (GradesEntry) -> ()) {
        let entry = GradesEntry(date: Date(), configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let entries = [GradesEntry(date: Date(), configuration: configuration)]
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct GradesEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let courses: [Course] = []
}

struct Canvas_WidgetsEntryView : View {
    
    var entry: Provider.Entry

    var body: some View {
        VStack {
//            if (WidgetManager.instance != nil) { Text("Widget manager exists")}
            if WidgetManager.instance != nil {
                ForEach(WidgetManager.instance!.canvasAPI.courses, id: \.id) { course in
                    SingleCourseRow(course: course)
                }
            } else {
                Text("CanvasAPI.instance is nil")
            }
        }
    }
}

struct SingleCourseRow: View {
    @ObservedObject var course: Course
    var body: some View {
        HStack {
            Label(self.course.name ?? "Course", systemImage: "book")
                .accentColor(self.course.courseColor ?? .accentColor)
            Spacer()
            Text(self.course.getScoreAsString() ?? "N/A")
        }
        .padding()
    }
}

@main
struct Canvas_Widgets: Widget {
    let kind: String = "Canvas_Widgets"
    @StateObject private var canvasAPI = WidgetManager()

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: ConfigurationIntent.self,
            provider: Provider()
        ) { entry in
            Canvas_WidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Course Scores")
        .description("View all of your current course grades.")
        .supportedFamilies([.systemLarge])
    }
}

struct Canvas_Widgets_Previews: PreviewProvider {
    static var previews: some View {
        Canvas_WidgetsEntryView(entry: GradesEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
