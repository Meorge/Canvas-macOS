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
                NavigationLink(destination: ModuleListView(course: course!)) { Label("Modules", systemImage: "folder") }
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
        List(self.course.modules, id: \.self) { module in
            ModuleView(module: module)
        }
//        .listStyle(InsetListStyle())
        .onAppear {
            self.course.updateModules()
        }
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
            
            
            // PROBLEM: it's only showing when there is little horizontal space for some weird reason
            List(self.module.moduleItems!, id: \.self) { moduleItem in
                ModuleItemView(moduleItem: moduleItem)
                    .padding()
            }
            .onAppear {
                self.module.updateModuleItems()
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
                if (true) {
                    Text("Subtitle")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        } icon: {
            Image(systemName: self.getIcon())
        }
        .padding(.leading, 25 * CGFloat(self.moduleItem.indent ?? 0))
        .onAppear {
            print("Created ModuleItemView for item \"\(moduleItem.title)\"")
        }
        
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

//struct ModuleListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ModuleListView(course: nil)
//    }
//}
