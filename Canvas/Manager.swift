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

class Manager: ObservableObject {
    static var instance: Manager? = nil
    @Published var canvasAPI: CanvasAPI = CanvasAPI()
    @Published var loggedOut = false
    
    var onRefresh: () -> Void = {}
    
    
    var anyCancellable: AnyCancellable? = nil
    init() {
//        var token = ""
//        if let filepath = Bundle.main.path(forResource: "token", ofType: "txt") {
//            do {
//                token = try String(contentsOfFile: filepath)
//            } catch {
//                print("contents couldn't be loaded")
//            }
//        } else {
//            print("not found")
//        }
        
        anyCancellable = self.canvasAPI.objectWillChange.sink { [weak self] (_) in
            self!.objectWillChange.send()
        }
        
        print(Bundle.main.bundleIdentifier!)
        Manager.instance = self
        
        // Check if login is possible
        if !login() {
            self.loggedOut = true
        }
    }
    
    
    func login() -> Bool {
        // Log in if possible
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
