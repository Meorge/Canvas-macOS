//
//  AssignmentsView.swift
//  Canvas
//
//  Created by Malcolm Anderson on 2/2/21.
//

import SwiftUI

struct AssignmentsView: View {
    @EnvironmentObject var manager: Manager
    @ObservedObject var course: Course = Course()
    
    var upcomingAssignments: [Assignment] {
        (self.course.assignments ?? []).filter { assignment in
            (assignment.dueAt ?? Date()) >= Date()
        }
    }
    
    var pastAssignments: [Assignment] {
        (self.course.assignments ?? []).filter { assignment in
            (assignment.dueAt ?? Date()) < Date()
        }
    }
    
    var body: some View {
        List {
            if upcomingAssignments.count > 0 {
                Section(header: Text("Upcoming")) {
                    ForEach(upcomingAssignments, id: \.id) { assignment in
                        SingleGradeRowView(assignment: assignment)
                    }
                }
            }
            
            if pastAssignments.count > 0 {
                Section(header: Text("Past")) {
                    ForEach(pastAssignments, id: \.id) { assignment in
                        SingleGradeRowView(assignment: assignment)
                    }
                }
            }
        }
        .navigationTitle("Assignments")
        .navigationSubtitle(course.name ?? "Course")
        .onAppear {
            self.manager.onRefresh = {
                self.course.updateAssignmentGroups()
                self.course.updateAssignments()
            }
            self.course.updateAssignmentGroups()
            self.course.updateAssignments()
        }
    }
}

struct AssignmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentsView()
    }
}
