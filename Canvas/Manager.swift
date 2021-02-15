//
//  Manager.swift
//  Canvas
//
//  Created by Test Account on 9/26/20.
//

import Foundation
import SwiftUI
import Combine
import KeychainSwift
import SwiftyJSON

class Manager: ObservableObject {
    static var instance: Manager? = nil
    @Published var canvasAPI: CanvasAPI = CanvasAPI()
    @Published var loggedOut = false
    
    var onRefresh: () -> Void = {}
    
    
    var anyCancellable: AnyCancellable? = nil
    init() {
        let useKeychain: Bool
        #if DEBUG
        useKeychain = false
        #else
        useKeychain = true
        #endif
        
        // Check if login is possible
        if !login(useKeychain: useKeychain) {
            self.loggedOut = true
        }
        
        anyCancellable = self.canvasAPI.objectWillChange.sink { [weak self] (_) in
            self!.objectWillChange.send()
        }
        
        print(Bundle.main.bundleIdentifier!)
        Manager.instance = self
        

    }
    
    func logout() {
        let keychain = KeychainSwift(keyPrefix: "\(Bundle.main.bundleIdentifier!).")
        keychain.delete("token")
        keychain.delete("domain")
        self.loggedOut = true
    }
    
    func login(useKeychain: Bool = true) -> Bool {
        // Log in if possible
        if (useKeychain) {
            let keychain = KeychainSwift(keyPrefix: "\(Bundle.main.bundleIdentifier!).")
            if let token = keychain.get("token"), let domain = keychain.get("domain") {
                self.canvasAPI.token = token
                self.canvasAPI.domain = domain
                self.refresh()
                self.loggedOut = false
                return true
            }
            return false
        }
        
        else {
            if let filepath = Bundle.main.path(forResource: "login", ofType: "json") {
                do {
                    let jsonData = JSON(NSData(contentsOfFile: filepath))
                    self.canvasAPI.token = jsonData["token"].stringValue
                    self.canvasAPI.domain = jsonData["domain"].stringValue
                    self.refresh()
                    self.loggedOut = false
                    return true
                } catch {
                    print("contents couldn't be loaded")
                    return false
                }
            } else {
                print("not found")
                return false
            }
        }
    }
    
    func setAccessTokenAndDomain(withToken token: String, forDomain domain: String) {
        let keychain = KeychainSwift(keyPrefix: "\(Bundle.main.bundleIdentifier!).")
        keychain.set(token, forKey: "token")
        keychain.set(domain, forKey: "domain")
    }
    
    func refresh() {
        // Refresh the top-level info
        // That would be base course data, and the activity stream stuff
        
        self.canvasAPI.getCurrentUser()
        
        self.canvasAPI.getCourses()
        
        self.canvasAPI.getGroups()
        
        // Refresh whatever the current info is
        self.onRefresh()
    }
}
