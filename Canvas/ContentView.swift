//
//  ContentView.swift
//  Canvas
//
//  Created by Test Account on 9/25/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            
            List {
                Group {
                    Text("Favorites")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
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
                
                    CourseItem(courseName: "Biology", courseIcon: "leaf", courseGrade: "80%")
                    CourseItem(courseName: "Math", courseIcon: "sum", courseGrade: "92.8%")
                    CourseItem(courseName: "English", courseIcon: "book.closed", courseGrade: "100%")
                    CourseItem(courseName: "Music", courseIcon: "pianokeys", courseGrade: "63%")
                }
            }.listStyle(SidebarListStyle())

            
        }
    }
}

struct CourseItem: View {
    @State var courseName = "Course"
    @State var courseIcon = "book"
    @State var courseGrade = "100%"
    var body: some View {
        HStack {
            Label(self.courseName, systemImage: self.courseIcon)
            Spacer()
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(Color.secondary.opacity(0.5))
                .frame(maxWidth: 50, maxHeight: 20)
                .overlay(Text(self.courseGrade)
                            .font(.caption))
            
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
