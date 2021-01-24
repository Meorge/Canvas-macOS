//
//  SinglePersonView.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/23/21.
//

import SwiftUI

struct SinglePersonView: View {
    @EnvironmentObject var manager: Manager
    @ObservedObject var person: User
    var body: some View {
        VStack {
            VStack(alignment: .center) {
                AvatarView(person: person, size: 100)
                Text(self.person.name!)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
            }
            Divider()
            Spacer()
//            Spacer()
//            if self.person.enrollments != nil && self.person.enrollments!.count > 0 {
//                Text("Courses You're Both In")
//                    .font(.largeTitle)
//                    .fontWeight(.bold)
//                ForEach(self.person.enrollments!, id: \.self) { enrollment in
//                    Label("\(enrollment.courseID!)", systemImage: "book");
//                }
//            }
//            Spacer()
            if self.person.email != nil { Text(self.person.email!) }
            if self.person.bio != nil { Text(self.person.bio!) }
        }
        
    }
}
