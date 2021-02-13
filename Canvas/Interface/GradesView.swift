//
//  GradesView.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/23/21.
//

import SwiftUI

struct GradesView: View {
    @EnvironmentObject var manager: Manager
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
        .navigationTitle("Grades")
        .navigationSubtitle(course.name ?? "Course")
        .onAppear {
            self.manager.onRefresh = {
                self.course.updateTopLevel()
                self.course.updateAssignmentGroups()
                self.course.updateAssignments()
            }
            self.course.updateAssignmentGroups()
            self.course.updateAssignments()
        }
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
                Text(assignmentGroup.groupWeight != nil ? "\(assignmentGroup.groupWeight!.removeTrailingZeroes())% of total grade" : "No weight assigned")
                    .font(.subheadline)
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(assignmentGroup.groupScore != nil ? "\(self.getGroupScoreMultiplied().removeTrailingZeroes())%" : "N/A")
                    .font(.title)
                    .bold()
                Text(assignmentGroup.groupScore != nil ? self.getGroupScoreFraction() : "")
            }
        }
    }
    
    func getGroupScoreMultiplied() -> Double {
        let score = assignmentGroup.groupScore!
        return (score.0 / score.1) * 100
    }
    func getGroupScoreFraction() -> String {
        let score = assignmentGroup.groupScore!
        return "\(score.0.removeTrailingZeroes()) / \(score.1.removeTrailingZeroes())"
    }
    
}

struct SingleGradeRowView: View {
    @ObservedObject var assignment: Assignment
    @Environment(\.openURL) var openURL
    var allowModifyingGrade: Bool = false
    
    var scoreLabel: some View {
        Text(self.assignment.getScoreAsString())
            .font(.title3)
            .bold()
    }
    
    var body: some View {
        Button(action: self.open) {
            Label {
                HStack(alignment: .center) {
                    VStack(alignment: .leading) {
                        Text(self.assignment.name ?? "Assignment")
                            .font(.title3)
                            .bold()
                        Text(self.assignment.getFormattedDueDate())
                            .font(.subheadline)
                    }
                    Spacer()
                    
                    if allowModifyingGrade {
                        Button(action: {}) { scoreLabel }
                            .buttonStyle(PlainButtonStyle())
                    } else {
                        scoreLabel
                    }
                    
                }
            } icon: {
                Image(systemName: assignment.getIcon())
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
        
    func open() {
        if assignment.htmlURL != nil {
            openURL(assignment.htmlURL!)
        }
    }
    
    var minAsString: String {
        self.assignment.scoreStatistics?.min != nil ? self.assignment.scoreStatistics!.min!.removeTrailingZeroes() : "Unknown"
    }
    
    var maxAsString: String {
        self.assignment.scoreStatistics?.max != nil ? self.assignment.scoreStatistics!.max!.removeTrailingZeroes() : "Unknown"
    }
    
    var meanAsString: String {
        self.assignment.scoreStatistics?.mean != nil ? self.assignment.scoreStatistics!.mean!.removeTrailingZeroes() : "Unknown"
    }
    

}



//struct GradesView_Previews: PreviewProvider {
//    static var previews: some View {
//        GradesView()
//    }
//}
