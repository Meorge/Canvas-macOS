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
                SingleGradeRowView()
                SingleGradeRowView()
                SingleGradeRowView()
            }
        }
        .padding()
    }
}

struct SingleGradeRowView: View {
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading) {
                Text("Assignment Name")
                    .font(.title3)
                    .bold()
                Text("Due Jan 2, 2021 by 10:30 AM")
                    .font(.subheadline)
            }
            Spacer()
            Text("10 / 10")
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
