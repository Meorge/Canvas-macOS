//
//  ContentView.swift
//  Canvas
//
//  Created by Test Account on 9/25/20.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var manager: Manager
    
    var body: some View {
        NavigationView {
            
            List {
                Group {
                    NavigationLink(destination: Dashboard()) {
                        Label("Dashboard", systemImage: "square.grid.2x2")
                    }
                    NavigationLink(destination: Calendar()) {
                        Label("Calendar", systemImage: "calendar")
                    }
                    NavigationLink(destination: Inbox()) {
                        Label("Inbox", systemImage: "tray")
                    }
                }
                
                Divider()
                
                Group {
                    Text("Courses")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                
                    ForEach(self.manager.canvasAPI.courses, id: \.self) { course in
                        NavigationLink(destination: CourseView(course: course).accentColor(course.courseColor)) {CourseItem(course: course)}
                            .accentColor(course.courseColor)
                    }
                }
                Spacer()
            }.listStyle(SidebarListStyle())

            
        }
    }
}

struct CourseItem: View {
    @ObservedObject var course: Course
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Label(self.course.name ?? "Unnamed Course", systemImage: self.getCourseIcon())
                    
                Spacer()
                
                if self.course.unreadAnnouncements > 0 {
                    Badge(text: "\(self.course.unreadAnnouncements)", color: Color.red, minWidth: 25)
                }
                if (self.course.getScoreAsString() != nil) {
                    Badge(text: self.course.getScoreAsString()!, color: Color.secondary.opacity(0.5), minWidth: 60)
                    
                }
                
            }
        }
    }
    
    func getCourseIcon() -> String {
        if self.course.courseIcon == nil || self.course.courseIcon! == "" {
            return "book"
        }
        
        return self.course.courseIcon!
    }
}

struct Badge: View {
    @State var text: String
    @State var color: Color
    @State var minWidth: Double = 0.0
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .foregroundColor(color)
                .frame(minWidth: CGFloat(minWidth), maxHeight: .infinity)
            Text(self.text)
                .foregroundColor(.white)
                .font(.caption)
//                .padding(5)
        }
        .fixedSize()
    }
//    var body: some View {
//        Text(self.text)
//            .foregroundColor(.clear)
//            .frame(minWidth: CGFloat(self.minWidth))
//            .overlay(
//                ZStack {
//                    RoundedRectangle(cornerRadius: 50)
//                        .foregroundColor(color)
//                        .frame(minWidth: 25, minHeight: 25)
//                    Text(self.text)
//                        .foregroundColor(.primary)
//                }
//            )
//    }
}

struct Calendar: View {
    var body: some View {
        Text("Calendar")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Calendar")
    }
}

struct ToDo: View {
    var body: some View {
        Text("To Do")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("To Do")
    }
}

struct Notifications: View {
    var body: some View {
        Text("Notifications")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Notifications")
    }
}

struct Inbox: View {
    var body: some View {
        Text("Inbox")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Inbox")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
