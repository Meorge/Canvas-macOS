//
//  AssignmentsView.swift
//  Canvas
//
//  Created by Malcolm Anderson on 2/2/21.
//

import SwiftUI

struct AssignmentsView: View {
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
                        AssignmentRowView(assignment: assignment)
                    }
                }
            }
            
            if pastAssignments.count > 0 {
                Section(header: Text("Past")) {
                    ForEach(pastAssignments, id: \.id) { assignment in
                        AssignmentRowView(assignment: assignment)
                    }
                }
            }
        }
    }
}

struct AssignmentRowView: View {
    @StateObject var assignment = Assignment()
    
    static var icons: [SubmissionType: String] = [
        .DiscussionTopic : "bubble.left.and.bubble.right",
        .OnlineQuiz : "flag",
        .OnPaper : "doc.text",
        .None : "doc",
        .ExternalTool : "link",
        .OnlineTextEntry : "square.and.pencil",
        .OnlineURL : "link",
        .OnlineUpload : "arrow.up.doc",
        .MediaRecording : "camera"
    ]
    
    func getIcon() -> String {
        let submitted = (assignment.submission?.workflowState ?? .Unsubmitted) != .Unsubmitted
        
        var outString = ""
        
        if assignment.submissionTypes?.contains(.DiscussionTopic) ?? false {
            outString += "bubble.left.and.bubble.right"
        }
        
        else if assignment.submissionTypes?.contains(.OnlineQuiz) ?? false {
            outString += "flag"
        }
        
        else if assignment.submissionTypes?.contains(.OnlineUpload) ?? false {
            outString += "arrow.up.doc"
        }
        
        else if assignment.submissionTypes?.contains(.MediaRecording) ?? false {
            outString += "camera"
        }
        
        else if assignment.submissionTypes?.contains(.OnlineURL) ?? false {
            outString += "link"
        }
        
        else if assignment.submissionTypes?.contains(.OnlineTextEntry) ?? false {
            outString += "doc.text"
        }
        
        if (outString == "") {
            outString = "doc"
        }
        
        return outString + (submitted ? ".fill" : "")
    }
    
    var body: some View {
        Label {
            VStack(alignment: .leading) {
                Text(assignment.name ?? "Unnamed Assignment")
                    .font(.headline)
                    .fontWeight(.bold)
                Text("\(assignment.getFormattedDueDate())   |   \(assignment.getScoreAsString())")
            }
        } icon: {
            Image(systemName: self.getIcon())
        }
    }
}

struct AssignmentsView_Previews: PreviewProvider {
    static var previews: some View {
        AssignmentsView()
    }
}
