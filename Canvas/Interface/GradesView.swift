//
//  GradesView.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/23/21.
//

import SwiftUI

struct GradesView: View {
    @ObservedObject var course: Course
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Text("Total Grade")
                    .font(.largeTitle)
                    .bold()
                Spacer()
                Text("\(self.course.getScoreAsString() ?? "Unknown")")
                    .font(.largeTitle)
                    .bold()
            }
            Divider()
            List {
                ForEach(self.course.assignmentGroups ?? [], id: \.id) { group in
                    Section(header: AssignmentGroupHeaderView(assignmentGroup: group), footer: Divider()) {
                        ForEach(group.assignments ?? [], id: \.id) { assignment in
                            SingleGradeRowView(assignment: assignment)
                            
                        }
                    }
                }
            }.padding(0)
        }
        .padding()
    }
}

struct AssignmentGroupHeaderView: View {
    @ObservedObject var assignmentGroup: AssignmentGroup
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(assignmentGroup.name ?? "Untitled Assignment Group")
                    .font(.title)
                    .bold()
                Text(assignmentGroup.groupWeight != nil ? "\(assignmentGroup.groupWeight!)% of total grade" : "No weight assigned")
                    .font(.subheadline)
            }
            Spacer()
            Text("75%")
                .font(.title)
                .bold()
        }
    }
}

struct SingleGradeRowView: View {
    @ObservedObject var assignment: Assignment
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text(self.assignment.name ?? "Assignment")
                    .font(.title3)
                    .bold()
                Text(self.assignment.getFormattedDueDate())
                    .font(.subheadline)
            }
            Spacer()
            Text(self.assignment.getScoreAsString())
                .font(.title3)
                .bold()
        }
    }
    

}

//struct GradesView_Previews: PreviewProvider {
//    static var previews: some View {
//        GradesView()
//    }
//}
