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
                NavigationLink(destination: AnnouncementListView(course: course!))
                {
                    Label("Announcements", systemImage: "megaphone")
                }
                Label("Discussions", systemImage: "text.bubble")
                Label("Grades", systemImage: "graduationcap")
                
                NavigationLink(destination: PeopleView(course: course!)) {
                    Label("People", systemImage: "person")
                }
                Label("Syllabus", systemImage: "doc.text")
                Divider()
                Label("Customize", systemImage: "paintbrush")
                    .accentColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
            }
        }
        .navigationTitle(course?.name ?? "Course")
    }
}

struct ModuleListView: View {
    @EnvironmentObject var manager: Manager
    @ObservedObject var course: Course

    var body: some View {
        Group {
            if self.course.modules.count > 0 {
                List(self.course.modules, id: \.id) { module in
                    ModuleView(module: module)
                }

            } else {
                VStack {
                    Text("No Modules")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("There's nothing to show here.")
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .onAppear(perform: self.course.updateModules)
        .navigationTitle((course.name ?? "Course") + " - Modules")
    }
}

struct ModuleView: View {
    @Environment(\.openURL) var openURL
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
                    Button(action: {self.openModuleItem(moduleItem)}) {
                        ModuleItemView(moduleItem: moduleItem)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            Divider()
        }
    }
    
    func openModuleItem(_ item: ModuleItem) {
        if let url = URL(string: item.htmlURL!) {
            openURL(url)
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
                    .fontWeight(.bold)
                    .padding((self.moduleItem.type ?? ModuleItemType.Page) == ModuleItemType.Header ? 10 : 0)
                if (self.moduleItem.type != ModuleItemType.Header) {
                    Text(self.getSubtitle())
                        
                }
            }
        } icon: {
            if self.getIcon() != "" { Image(systemName: self.getIcon()) }
        }
        .padding(5)
        .padding(.leading, (self.moduleItem.type != ModuleItemType.Header ? 25 : 0) + (25 * CGFloat(self.moduleItem.indent ?? 0)))
        
    }
    
    func getSubtitle() -> String {
        var output: [String] = []
        if let details = self.moduleItem.contentDetails {
            if let dueDate = details.dueAt {
                // Get human-readable due date
                
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                
                let dateString = formatter.string(from: dueDate)
                output.append(dateString)
            }
            
            if let pointsPossible = details.pointsPossible {
                output.append("\(pointsPossible) pts")
            }
        }
        
        return output.joined(separator: " | ")
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
//struct CourseView_Previews: PreviewProvider {
//    static var previews: some View {
//        CourseView(course: nil)
//    }
//}
//
//struct ModuleView_Previews: PreviewProvider {
//    static var previews: some View {
//        ModuleView(module: Module())
//    }
//}