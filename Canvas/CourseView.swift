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
    @State var course: Course

    var body: some View {
        List(self.course.modules, id: \.self) { module in
            ModuleView(module: module)
        }
        .listStyle(InsetListStyle())
        .onAppear {
            print("update modules")
            self.course.updateModules()
        }
    }
}

struct ModuleView: View {
    @State var module: Module?
    
    var body: some View {
        Text(self.module!.name!)
            .font(.title)
    }
}

struct CourseView_Previews: PreviewProvider {
    static var previews: some View {
        CourseView(course: nil)
    }
}

//struct ModuleListView_Previews: PreviewProvider {
//    static var previews: some View {
//        ModuleListView(course: nil)
//    }
//}
