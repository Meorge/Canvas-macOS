//
//  QuizzesView.swift
//  Canvas
//
//  Created by Malcolm Anderson on 2/3/21.
//

import SwiftUI

struct QuizzesView: View {
    @ObservedObject var course: Course = Course()
    
    var quizzes: [Assignment] {
        (course.assignments ?? []).filter { assignment in
            assignment.submissionTypes?.contains(.OnlineQuiz) ?? false
        }
    }
    var body: some View {
        List(quizzes, id: \.id) { quiz in
            SingleGradeRowView(assignment: quiz)
        }
        .navigationTitle("Quizzes")
        .navigationSubtitle(course.name ?? "Course")
    }
}

struct QuizzesView_Previews: PreviewProvider {
    static var previews: some View {
        QuizzesView()
    }
}
