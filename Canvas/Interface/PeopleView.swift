//
//  PeopleView.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/18/21.
//

import SwiftUI

struct PeopleView: View {
    @EnvironmentObject var manager: Manager
    @ObservedObject var course: Course
    var body: some View {
        Group {
            if self.course.people.count > 0 {
                List(self.course.people, id: \.id) { person in
                    PeopleRowView(course: course, person: person)
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
        .onAppear(perform: self.course.updatePeople)
    }
}

struct PeopleRowView: View {
    @ObservedObject var course: Course
    @ObservedObject var person: User
    var body: some View {
        HStack {
            AvatarView(avatar: Image("testAvatar"))
            VStack(alignment: .leading) {
                Text(person.shortName ?? "No name")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                Text(self.getPositionInCourse())
            }
        }
    }
    
    func getPositionInCourse() -> String {
        let enrollment = self.person.getEnrollment(forCourse: course)
        if enrollment == nil { return "Not enrolled" }
        
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
    var avatar: Image
    var body: some View {
        avatar
            .resizable()
            .aspectRatio(1, contentMode: .fit)
            .frame(maxWidth: 30, maxHeight: 30)
            .clipShape(Circle())
            
    }
}

//struct PeopleView_Previews: PreviewProvider {
//    static var previews: some View {
//        PeopleView()
//    }
//}
