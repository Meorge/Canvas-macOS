//
//  AnnouncementsView.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/17/21.
//

import SwiftUI

struct AnnouncementListView: View {
    @EnvironmentObject var manager: Manager
    @ObservedObject var course: Course
    var body: some View {
        List {
            AnnouncementRowView()
            AnnouncementRowView()
            AnnouncementRowView()
            AnnouncementRowView()
        }
        .listStyle(InsetListStyle())
        .frame(minWidth: 300)
    }
}

struct AnnouncementRowView: View {
    var unread: Bool = true
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Label {
                    Text("Title of Announcement with a Very Long Name Woo Boy")
                        .font(.headline)
                } icon: {
                    if unread { Image(systemName: "circle.fill") }
                }
                Spacer()
                Text("9:41 AM")
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            Text("This is some of the text in the announcement...")
                .font(.body)
                .padding(.leading, 20)
        }
        .padding(.vertical, 8)
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
