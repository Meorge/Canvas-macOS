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
            List(self.course.assignments ?? [], id: \.id) { assignment in
                SingleGradeRowView(assignment: assignment)
            }
        }
        .padding()
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
