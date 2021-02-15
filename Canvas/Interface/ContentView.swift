//
//  ContentView.swift
//  Canvas
//
//  Created by Test Account on 9/25/20.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase
    @EnvironmentObject var manager: Manager
    
    @State var loginViewPresented: Bool = true
    
    var body: some View {
        NavigationView {
            List {
                Group {
                    NavigationLink(destination: DashboardView()) {
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
                        NavigationLink(destination: CourseLikeView(course: course).accentColor(course.courseColor)) {CourseItem(course: course)}
                            .accentColor(course.courseColor)
                    }
                }
                Divider()
                
                Group {
                    Text("Groups")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    
                    ForEach(self.manager.canvasAPI.groups, id: \.self) { group in
                        GroupItem(group: group)
//                        Label(group.name ?? "Unnamed Course", systemImage: "book")
                    }
                }
                Divider()
                UserAccountRowView()
            }.listStyle(SidebarListStyle())
            .frame(maxHeight: .infinity)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: { print("Overall refresh"); self.manager.refresh(); }) {
                        Label("Refresh", systemImage: "arrow.clockwise")
                    }
                }
            }
        }
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                self.manager.refresh()
            }
        }
        
        .sheet(isPresented: self.$manager.loggedOut) {
            LoginView()
        }
    }
}

struct GroupItem: View {
    @ObservedObject var group: CanvasGroup
    var body: some View {
        NavigationLink(destination: CourseLikeView(course: group)) {
            VStack(alignment: .leading) {
                HStack {
                    Label(self.group.name ?? "Unnamed Course", systemImage: "person.3")
                    
                    Spacer()
                    
                    if self.group.totalNotifications > 0 {
                        Badge(text: "\(self.group.totalNotifications)", color: Color.red, minWidth: 25)
                    }
                    
                }
            }
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
                
                if self.course.totalNotifications > 0 {
                    Badge(text: "\(self.course.totalNotifications)", color: Color.red, minWidth: 25)
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
        }
        .fixedSize()
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
