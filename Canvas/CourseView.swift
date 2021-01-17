//
//  CourseView.swift
//  Canvas
//
//  Created by Test Account on 9/26/20.
//

import SwiftUI

struct CourseView: View {
    @State var course: Course?
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: ModuleListView(course: course!))
                {
                    Label("Modules", systemImage: "folder")
                }
                Label("Announcements", systemImage: "megaphone")
                Label("Discussions", systemImage: "text.bubble")
                Label("Grades", systemImage: "graduationcap")
                Label("People", systemImage: "person")
                Label("Syllabus", systemImage: "doc.text")
            }
        }
        .navigationTitle(course?.name ?? "Course")
    }
}

struct ModuleListView: View {
    @EnvironmentObject var manager: Manager
    @ObservedObject var course: Course

    var body: some View {
//        NavigationView {
            List(self.course.modules, id: \.id) { module in
                // PROBLEM: Every one of these ModuleViews acts like they have their own NavigationLink
                ModuleView(module: module)
            }
//        }
        .onAppear(perform: self.course.updateModules)
        .navigationTitle((course.name ?? "Course") + " - Modules")
    }
}

struct ModuleView: View {
    @EnvironmentObject var manager: Manager
    @ObservedObject var module: Module
    var body: some View {
        VStack(alignment: .leading) {
            Text(self.module.name!)
                .font(.largeTitle)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .padding(10)
            
            ForEach(self.module.moduleItems!, id: \.id) { moduleItem in
                if moduleItem.type == ModuleItemType.Header
                {
                    ModuleItemView(moduleItem: moduleItem)
                } else
                {
                    // PROBLEM: These NavigationLinks don't seem to work, since
                    // the ModuleView as a whole acts like it's inside of one...
                    // but the destinations from the ModuleView's NavigationLink
                    // point to these??
                    Button(action: {print("\(moduleItem.apiURL!)")}) {
                        ModuleItemView(moduleItem: moduleItem)
                    }
                    .buttonStyle(PlainButtonStyle())
//                    NavigationLink(destination: Text("\(moduleItem.title!)")) {
//                        ModuleItemView(moduleItem: moduleItem)
//                    }
                }
            }
            Divider()
        }
    }
}

struct ModuleItemView: View {
    @EnvironmentObject var manager: Manager
    @ObservedObject var moduleItem: ModuleItem
    var body: some View {
        Label {
            VStack(alignment: .leading) {
                Text(self.moduleItem.title ?? "Module item")
                    .font((self.moduleItem.type ?? ModuleItemType.Page) == ModuleItemType.Header ? .title : .headline)
                    .padding((self.moduleItem.type ?? ModuleItemType.Page) == ModuleItemType.Header ? 10 : 0)
                if (self.moduleItem.type != ModuleItemType.Header) {
                    Text("Subtitle")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        } icon: {
            if self.getIcon() != "" { Image(systemName: self.getIcon()) }
        }
        .padding(.leading, (self.moduleItem.type != ModuleItemType.Header ? 25 : 0) + (25 * CGFloat(self.moduleItem.indent ?? 0)))
        
    }
    
    func getIcon() -> String {
        switch (self.moduleItem.type ?? ModuleItemType.Page) {
        case .Assignment:
            return ModuleItemIcon.Assignment.rawValue
        case .Quiz:
            return ModuleItemIcon.Quiz.rawValue
        case .File:
            return ModuleItemIcon.File.rawValue
        case .Page:
            return ModuleItemIcon.Page.rawValue
        case .Discussion:
            return ModuleItemIcon.Discussion.rawValue
        case .ExternalURL:
            return ModuleItemIcon.Link.rawValue
        case .ExternalTool:
            return ModuleItemIcon.Link.rawValue
        default:
            return ModuleItemIcon.None.rawValue
        }
    }
}

struct ModuleItemDetailView: View {
    @EnvironmentObject var manager: Manager
    @ObservedObject var moduleItem: ModuleItem
    
    var body: some View {
        Text("beep")
    }
}

enum ModuleItemIcon : String {
    case None = ""
    case Page = "doc"
    case Discussion = "bubble.left.and.bubble.right"
    case Quiz = "pencil"
    case Assignment = "doc.text"
    case File = "arrow.down.doc"
    case Link = "link"
    
}
struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        CourseView(course: nil)
    }
}

struct ModuleView_Previews: PreviewProvider {
    static var previews: some View {
        ModuleView(module: Module())
    }
}
