
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
    
    
    @State var currentDomainSearch: String = ""
    @State var currentToken: String = ""
    @State var domain: Domain? = nil
    
    @State var state: LoginViewState = .FindAccountDomain
    
    var body: some View {
        switch (state) {
        case .FindAccountDomain: FindAccountDomainPageView(search: $currentDomainSearch, selection: $domain, state: $state)
        case .EnterAccessToken: EnterAccessTokenPageView(token: $currentToken, domain: $domain, state: $state)
        }
    }
    
    enum LoginViewState {
        case FindAccountDomain
        case EnterAccessToken
    }
}

struct FindAccountDomainPageView: View {
    @Binding var search: String
    @Binding var selection: Domain?
    @Binding var state: LoginView.LoginViewState
    
    
    @EnvironmentObject var manager: Manager
    @State var possibilities: [Domain] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .center) {
                Text("Find Your School")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            
            Text("First, let's find your school's domain.")
            
            TextField("Search", text: $search)
                .onChange(of: search, perform: self.updateDomains)
            
            List(possibilities, id: \.self, selection: $selection) { item in
                Text("\(item.name)")
            }
            .listStyle(InsetListStyle())
            .frame(minHeight: 100)
            
            Spacer()
            HStack {
                Spacer()
                Button(action: {}) { Text("Cancel") }
                Button(action: self.progressToTokenPage) { Text("Next") }
                    .disabled(self.selection == nil)
            }
        }
        .padding()
        .onAppear { self.updateDomains(search) }
    }
    
    func updateDomains(_ search: String) {
        self.manager.canvasAPI.getAccountDomains(forQuery: search) { data in
            self.possibilities = data.value ?? []
        }
    }
    
    func progressToTokenPage() {
        self.state = .EnterAccessToken
    }
    

}


struct EnterAccessTokenPageView: View {
    @Binding var token: String
    @Binding var domain: Domain?
    @Binding var state: LoginView.LoginViewState
    @EnvironmentObject var manager: Manager
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .center) {
                Text("Enter Your Access Token")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding()
                
            Text("Next, enter your access token below. To generate an access token, go to your account settings on the Canvas website, and click \"New Access Token\".")
            
            TextField("Token", text: $token)
            Label("Authentication was unsuccessful. Please double-check your access token and domain, then try again.", systemImage: "exclamationmark.triangle.fill")
                .foregroundColor(.red)
            
            Spacer()
            HStack {
                Spacer()
                Button(action: self.returnToDomainPage) { Text("Back") }
                Button(action: self.checkIfValid) { Text("Log in") }
            }
        }
        .padding()
    }
    
    func returnToDomainPage() {
        self.token = ""
        self.state = .FindAccountDomain
    }
    
    func checkIfValid() {
        self.manager.canvasAPI.domain = self.domain!.domain
        self.manager.canvasAPI.tryLogin { response in
            if response.error != nil {
                print("Error logging in: \(response.error!.localizedDescription)")
            } else {
                print("Success!")
            }
        }
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
