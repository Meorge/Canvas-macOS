//
//  AnnouncementsView.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/17/21.
//
import Foundation
import SwiftUI

struct AnnouncementListView: View {
    @EnvironmentObject var manager: Manager
    @ObservedObject var course: CourseLike
    var body: some View {
        Group {
            VStack {
                if self.course.announcements.count > 0 {
                    List(self.course.announcements, id: \.self) { announcement in
                        AnnouncementRowView(announcement: announcement)
                    }
                    .id(UUID())
                    .listStyle(DefaultListStyle())
                    .frame(minWidth: 300)
                } else {
                    VStack {
                        Text("No Announcements")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("There's nothing to show here.")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .onAppear {
            self.manager.onRefresh = {
                self.course.updateTopLevel()
                self.course.updateAnnouncements()
            }
            self.course.updateAnnouncements()
        }
        .navigationTitle("Announcements")
        .navigationSubtitle(course.name ?? "Course")
    }
}

struct AnnouncementRowView: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var manager: Manager
    @ObservedObject var announcement: DiscussionTopic
    
    var body: some View {
        Button(action: self.open) {
            VStack(alignment: .leading) {
                HStack(alignment: .top) {
                    Label {
                        Text(self.announcement.title ?? "No title")
                            .font(.headline)
                    } icon: {
                        if (self.announcement.readState ?? nil) == .Unread { Image(systemName: "circle.fill") }
                    }
                    Spacer()
                    Text(self.getDateAsString())
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                Text(self.getPreviewText())
                    .font(.body)
                    .truncationMode(.tail)
                    .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                Divider()
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    func open() {
        if announcement.htmlURL != nil {
            openURL(announcement.htmlURL!)
        }
    }
    
    func getPreviewText() -> String {
        // from https://stackoverflow.com/a/41875127
        let message = self.announcement.message ?? "No content"
        let messageWithoutHTMLTags = message.replacingOccurrences(of: "<[^>]+>", with: "", options: String.CompareOptions.regularExpression, range: nil)
        let messageWithoutAmpersandThings = messageWithoutHTMLTags.replacingOccurrences(of: "&[^;]+;", with: "", options: String.CompareOptions.regularExpression, range: nil)
        return messageWithoutAmpersandThings
        
//        let attributed = try? NSAttributedString(data: (self.announcement.message?.data(using: .unicode))!, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
//        return attributed?.string ?? nil
    }
    func getDateAsString() -> String {
        if self.announcement.postedAt == nil {
            return "???"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: self.announcement.postedAt!)
    }
    
}

struct AnnouncementDetailView: View {
    var body: some View {
        VStack {
            Text("woop woop badoop")
        }
    }
}

//struct AnnouncementsView_Previews: PreviewProvider {
//    static var previews: some View {
//        AnnouncementListView(course: Course())
//    }
//}
