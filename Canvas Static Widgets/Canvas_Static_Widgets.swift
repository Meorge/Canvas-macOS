//
//  Canvas_Static_Widgets.swift
//  Canvas Static Widgets
//
//  Created by Malcolm Anderson on 1/24/21.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> GradesEntry {
        GradesEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (GradesEntry) -> ()) {
        let entry = GradesEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [GradesEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = GradesEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct GradesEntry: TimelineEntry {
    let date: Date
    let courses: [Course] = []
}

struct Canvas_Static_WidgetsEntryView : View {
    @EnvironmentObject private var canvasAPI: WidgetManager
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
            Spacer()
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
struct Canvas_Static_Widgets: Widget {
    let kind: String = "Canvas_Static_Widgets"

    @StateObject private var canvasAPI: WidgetManager = WidgetManager()
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            Canvas_Static_WidgetsEntryView(entry: entry)
        }
        .configurationDisplayName("Course Scores")
        .description("View all of your current course grades.")
        .supportedFamilies([.systemLarge])
    }
}

struct Canvas_Static_Widgets_Previews: PreviewProvider {
    static var previews: some View {
        Canvas_Static_WidgetsEntryView(entry: GradesEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
