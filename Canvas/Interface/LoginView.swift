
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
    
    @State var domainQueryResult: ConnectionAttemptResult = .Success
    
    
    @EnvironmentObject var manager: Manager
    @State var possibilities: [Domain] = []
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .center) {
                Image(systemName: "building.columns.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
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
            
            if case .Failure(let errorText) = domainQueryResult {
                Label("Error encountered: \"\(errorText)\"", systemImage: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
            }
            
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
            if data.error != nil {
                self.domainQueryResult = .Failure(message: data.error!.localizedDescription)
                return
            }
            
            if data.response!.statusCode != 200 {
                self.domainQueryResult = .Failure(message: "Response code \(data.response!.statusCode)")
            }
            
            self.domainQueryResult = .Success
            self.possibilities = data.value!
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
    
    @State var connectionAttemptResult: ConnectionAttemptResult = .Success
    @State var connecting = false
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .center) {
                Image(systemName: "key.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 50)
                Text("Enter Your Access Token")
                    .font(.largeTitle)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding()
                
            Text("Next, enter your access token below. To generate an access token, go to your account settings on the Canvas website, and click \"New Access Token\".")
            
            TextField("Token", text: $token)
            if case .Failure(let errorText) = connectionAttemptResult {
                Label(errorText, systemImage: "exclamationmark.triangle.fill")
                    .foregroundColor(.red)
            }
            
            if connecting {
                ProgressView()
            }
            
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
        self.connecting = true
        let domain = self.domain!.domain
        let token = self.token
        self.manager.canvasAPI.attemptToConnect(token, domain) { result in
            self.connecting = false
            self.connectionAttemptResult = result
            
            // If we succeeded, let's log in!!
            if case .Success = result {
                self.manager.setAccessTokenAndDomain(withToken: token, forDomain: domain)
                self.manager.login()
            }
        }
    }
}
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
