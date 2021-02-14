//
//  LoginView.swift
//  Canvas
//
//  Created by Malcolm Anderson on 2/13/21.
//

import SwiftUI

struct UserAccountRowView: View {
    @EnvironmentObject var manager: Manager
    var body: some View {
        NavigationLink(destination: self.manager.canvasAPI.currentUser != nil ? AnyView(UserAccountView(user: self.manager.canvasAPI.currentUser!)) : AnyView(LoginView())) {
            HStack {
                if self.manager.canvasAPI.currentUser != nil { AvatarView(person: self.manager.canvasAPI.currentUser!) }
                Text(self.manager.canvasAPI.currentUser?.shortName ?? "Log in")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .padding()
    }
}

struct UserAccountView: View {
    @StateObject var user: User
    
    var body: some View {
        Text("\(user.shortName ?? "No short name")")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct LoginView: View {
    @EnvironmentObject var manager: Manager
    var body: some View {
        FindAccountDomainPageView()
    }
}

struct FindAccountDomainPageView: View {
    @State var selection: Domain? = nil
    @EnvironmentObject var manager: Manager
    @State var currentSearch: String = ""
    
    @State var possibilities: [Domain] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Find Your School")
                .fontWeight(.bold)
            Text("First, let's find your school's domain.")
            
            
            TextField("Search", text: $currentSearch)
                .onChange(of: currentSearch, perform: self.updateDomains)
            
            List(possibilities, id: \.self, selection: $selection) { item in
                Text("\(item.name)")
            }
            .listStyle(InsetListStyle())
            
            Spacer()
            HStack {
                Spacer()
                Button(action: {}) { Text("Cancel") }
                Button(action: {}) { Text("Next") }
                    .disabled(self.selection == nil)
            }
        }
        .padding()
    }
    
    func updateDomains(_ search: String) {
        self.manager.canvasAPI.getAccountDomains(forQuery: search) { data in
            self.possibilities = data.value ?? []
        }
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
