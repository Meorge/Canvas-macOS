//
//  AnnouncementsView.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/17/21.
//

import SwiftUI

struct AnnouncementListView: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var manager: Manager
    @ObservedObject var course: Course
    var body: some View {
        Group {
            if self.course.announcements.count > 0 {
                List(self.course.announcements, id: \.id) { announcement in
                    Button(action: {self.openAnnouncement(announcement)}) {
                        AnnouncementRowView(announcement: announcement)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .listStyle(InsetListStyle())
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
        .onAppear(perform: self.course.updateAnnouncements)
    }
    
    func openAnnouncement(_ item: DiscussionTopic) {
        if let url = URL(string: item.htmlURL!) {
            openURL(url)
        }
    }
}

struct AnnouncementRowView: View {
    @ObservedObject var announcement: DiscussionTopic
    var body: some View {
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
            Text(self.announcement.message ?? "No content")
                .font(.body)
                .truncationMode(.tail)
                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                .padding(.leading, 20)
        }
        .padding(.vertical, 8)
    }
    
    func getDateAsString() -> String {
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
