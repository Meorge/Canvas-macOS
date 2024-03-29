//
//  PeopleView.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/18/21.
//

import SwiftUI
import Alamofire
import SDWebImageSwiftUI

struct PeopleView: View {
    @EnvironmentObject var manager: Manager
    @ObservedObject var course: CourseLike
    
    @State var filter = FilterCategory.all
    
    @State var searchContent = ""
    
    enum FilterCategory: String, CaseIterable, Identifiable {
        case all = "All"
        case students = "Students"
        case teachers = "Teachers"
        case tas = "TAs"
        case designers = "Designers"
        case observers = "Observers"
        
        var id: FilterCategory { self }
    }

    var filteredPeople: [User] {
//        print(self.course.people.count)
        return self.course.people.filter { user in
            self.filter == .all
            ||
            (
                (self.filter.id == .students) && (user.getEnrollment(forCourse: course)?.role! == .StudentEnrollment)
                ||
                (self.filter.id == .teachers) && (user.getEnrollment(forCourse: course)?.role! == .TeacherEnrollment)
                ||
                (self.filter.id == .tas) && (user.getEnrollment(forCourse: course)?.role! == .TaEnrollment)
                ||
                (self.filter.id == .designers) && (user.getEnrollment(forCourse: course)?.role! == .DesignerEnrollment)
                ||
                (self.filter.id == .observers) && (user.getEnrollment(forCourse: course)?.role! == .ObserverEnrollment)
            )
        }
    }
    
    var body: some View {
        Group {
            VStack {
                if self.filteredPeople.count > 0 {
                    NavigationView {
                        List(self.filteredPeople, id: \.id) { person in
                            PeopleRowView(course: course, person: person)
                        }
                    }
                } else {
                    VStack {
                        Text("No People")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        Text("There's nothing to show here.")
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .navigationTitle("People")
        .navigationSubtitle(course.name ?? "Course")
        .onAppear {
            self.manager.onRefresh = {
                self.course.updateTopLevel()
                self.course.updatePeople()
            }
            self.course.updatePeople()
        }
        
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Menu {
                    Picker("Roles", selection: $filter) {
                        ForEach(FilterCategory.allCases) { category in
                            Text(category.rawValue).tag(category)
                        }
                    }
                    .pickerStyle(InlinePickerStyle())
                } label: {
                    Label("Filter", systemImage: "line.horizontal.3.decrease.circle")
                }
                .disabled(!(course is Course))
            }
//            ToolbarItemGroup(placement: .navigationBarTrailing) {
//                // adapting from https://github.com/Dimillian/RedditOS/blob/master/RedditOs/Features/Search/ToolbarSearchBar.swift
//                TextField("Search", text: $searchContent)
//                    .padding()
//                    .textFieldStyle(RoundedBorderTextFieldStyle())
//                    .frame(width: 300)
////                Button(action: {}) {
////                    Label("Search", systemImage: "magnifyingglass")
////                }
//            }
        }
    }
}

struct PeopleRowView: View {
    @EnvironmentObject var manager: Manager
    @ObservedObject var course: CourseLike
    @ObservedObject var person: User
    var body: some View {
        NavigationLink(destination: SinglePersonView(person: person)) {
            HStack {
                AvatarView(person: person)
                VStack(alignment: .leading) {
                    Text(person.shortName ?? "No name")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text(self.getPositionInCourse())
                }
            }
        }
    }
    
    func getPositionInCourse() -> String {
        let enrollment = self.person.getEnrollment(forCourse: course)
        if enrollment == nil { return "" }
        
        return self.getHumanReadablePosition(enrollment!.role)
    }
    
    func getHumanReadablePosition(_ pos: StudentEnrollmentType?) -> String {
        
        switch (pos) {
        case .StudentEnrollment: return "Student"
        case .TeacherEnrollment: return "Teacher"
        case .TaEnrollment: return "TA"
        case .DesignerEnrollment: return "Designer"
        case .ObserverEnrollment: return "Observer"
        default: return "Unknown"
        }
    }
}

struct AvatarView: View {
    @EnvironmentObject var manager: Manager
    @ObservedObject var person: User
    @State var size: Double = 30
    var body: some View {
        WebImage(url: person.avatarURL)
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: CGFloat(size), maxHeight: CGFloat(size))
            .clipShape(Circle())
            
    }
}


//struct PeopleView_Previews: PreviewProvider {
//    static var previews: some View {
//        PeopleView()
//    }
//}
