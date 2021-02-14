//
//  Manager.swift
//  Canvas
//
//  Created by Test Account on 9/26/20.
//

import Foundation
import SwiftUI
import Combine

class Manager: ObservableObject {
    static var instance: Manager? = nil
    @Published var canvasAPI: CanvasAPI
    
    var onRefresh: () -> Void = {}
    
    
    var anyCancellable: AnyCancellable? = nil
    init() {
        var token = ""
        if let filepath = Bundle.main.path(forResource: "token", ofType: "txt") {
            do {
                token = try String(contentsOfFile: filepath)
            } catch {
                print("contents couldn't be loaded")
            }
        } else {
            print("not found")
        }
        
        self.canvasAPI = CanvasAPI(token)
        
        anyCancellable = self.canvasAPI.objectWillChange.sink { [weak self] (_) in
            self!.objectWillChange.send()
        }
        
        Manager.instance = self
        
        self.refresh()
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
