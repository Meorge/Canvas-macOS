//
//  CourseTabView.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/20/21.
//

import SwiftUI

struct TabItemView: View {
    @Environment(\.openURL) var openURL
    @EnvironmentObject var manager: Manager
    @ObservedObject var course: CourseLike
    @ObservedObject var tab: Tab
    
    
    func getDestination(_ id: String) -> some View {
        switch (id) {
        case "home": return AnyView(self.getDestination(self.course.defaultView ?? "none"))
        case "announcements": return AnyView(AnnouncementListView(course: course))
        case "modules": return AnyView(ModuleListView(course: course as! Course))
        case "people": return AnyView(PeopleView(course: course))
        case "grades": return AnyView(GradesView(course: course as! Course))
        case "assignments": return AnyView(AssignmentsView(course: course as! Course))
        case "quizzes": return AnyView(QuizzesView(course: course as! Course))
        case "discussions": return AnyView(DiscussionTopicsView(course: course))
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
        "discussions": "bubble.left.and.bubble.right",
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
    
    var badgeCount: Int {
        switch (self.tab.id) {
        case "announcements": return self.course.announcementNotifications
        case "discussions": return self.course.discussionTopicsNotifications
        default: return 0
        }
    }
    
    var label: some View {
        HStack {
            Label(self.tab.label ?? "Tab", systemImage: icon)
            Spacer()
            if badgeCount > 0 {
                Badge(text: "\(badgeCount)", color: .red, minWidth: 25)
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
