//
//  CourseTabView.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/20/21.
//

import SwiftUI

struct CourseTabView: View {
    @Environment(\.openURL) var openURL
    @ObservedObject var course: Course
    @ObservedObject var tab: Tab
    
    
    func getDestination(_ id: String) -> some View {
        switch (id) {
        case "home": return AnyView(self.getDestination(self.course.defaultView!))
        case "announcements": return AnyView(AnnouncementListView(course: course))
        case "modules": return AnyView(ModuleListView(course: course))
        case "people": return AnyView(PeopleView(course: course))
        case "grades": return AnyView(GradesView(course: course))
        default: return AnyView(getPlaceholderView(id))
        }
    }
    
    let standardIcons: [String : String] = [
        "home": "house",
        "announcements": "megaphone",
        "modules": "folder",
        "syllabus": "doc.text",
        "people": "person.2",
        "rubrics": "doc.text.magnifyingglass",
        "assignments": "square.and.pencil",
        "discussions": "bubble.left",
        "grades": "character.book.closed",
        "quizzes": "flag",
        "pages": "doc",
        "files": "doc.on.doc",
        "outcomes": "wand.and.rays",
        "conferences": "quote.bubble",
        "collaborations": "figure.stand.line.dotted.figure.stand"
    ]
    
    func getPlaceholderView(_ id: String) -> some View {
        VStack {
            Text("Can't open \"\(id)\" in the app.")
            if self.tab.fullURL != nil && URL(string: self.tab.fullURL!) != nil {
                Button {
                    openURL(URL(string: self.tab.fullURL!)!)
                } label: {
                    Text("Open in Browser")
                }
            }
        }
    }
    
    var icon: String {
        standardIcons[self.tab.id!] ?? "link"
    }
    
    var label: some View {
        HStack {
            Label(self.tab.label ?? "Tab", systemImage: icon)
            Spacer()
            if self.tab.id == "announcements" && self.course.unreadAnnouncements > 0 {
                Badge(text: "\(self.course.unreadAnnouncements)", color: .red, minWidth: 25)
            }
        }
    }
    
    var link: some View {
        Button {
            openURL(URL(string: self.tab.fullURL!)!)
        } label: {
            label
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    var navLink: some View {
        NavigationLink(destination: self.getDestination(self.tab.id!)) {
            label
        }
    }
    
    var body: some View {
        if self.tab.type! == .External {
            link
        } else {
            navLink
        }
    }
}

//struct CourseTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        CourseTabView()
//    }
//}
