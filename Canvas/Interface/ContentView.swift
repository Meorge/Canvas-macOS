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
                        NavigationLink(destination: CourseView(course: course)) {CourseItem(course: course)}
                    }
                }
                Spacer()
            }.listStyle(SidebarListStyle())

            
        }
    }
}

struct CourseItem: View {
    @State var course: Course
    var body: some View {
        HStack {
            Label(self.course.name ?? "Unnamed Course", systemImage: "book")
            Spacer()
            if (self.course.getScoreAsString() != nil) {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.secondary.opacity(0.5))
                    .frame(maxWidth: 50, maxHeight: 20)
                    .overlay(Text(self.course.getScoreAsString()!))
                                .font(.caption)
                
            }
            
        }
    }
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
