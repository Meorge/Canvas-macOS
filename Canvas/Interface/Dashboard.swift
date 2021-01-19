//
//  Dashboard.swift
//  Canvas
//
//  Created by Test Account on 9/25/20.
//

import SwiftUI

struct Dashboard: View {
    var columns : [GridItem] = [
        GridItem(.adaptive(minimum: 250)),
        GridItem(.adaptive(minimum: 250)),
        GridItem(.adaptive(minimum: 250))
    ]
    var body: some View {
//        Text("idk what to put here")
        ProgressView()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct DashboardItem: View {
    var body: some View {
        ZStack {
            Rectangle()
                .frame(width: 250, height: 150)
            VStack {
                VStack(alignment: .leading) {
                    Text("Course Title")
                        .font(.title)
                        .foregroundColor(Color.black)
                    Text("Course subtitle")
                        .font(.subheadline)
                        .foregroundColor(Color.black)
                }
            }
        }
        .mask(RoundedRectangle(cornerRadius: 20))
    }
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}
