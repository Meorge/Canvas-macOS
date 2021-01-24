//
//  DashboardView.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/23/21.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("To Do")
                    .font(.title)
                    .bold()
                
            }
            .frame(maxWidth: .infinity)
            Divider()
            VStack(alignment: .leading) {
                Text("To Do")
                    .font(.title)
                    .bold()
                
            }
            .frame(maxWidth: .infinity)
        }
    }
}

struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
    }
}
