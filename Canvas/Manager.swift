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
    @Published var canvasAPI: CanvasAPI
    
    
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
        
        anyCancellable = self.canvasAPI.objectWillChange.sink { [self] (_) in
            self.objectWillChange.send()
        }
    }
    
    func refresh() {
        self.canvasAPI.getCourses()
    }
}
