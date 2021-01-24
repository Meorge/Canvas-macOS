//
//  WidgetManager.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/24/21.
//

import Foundation
import Combine

class WidgetManager: ObservableObject {
    static var instance: WidgetManager? = nil
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
        
        anyCancellable = self.canvasAPI.objectWillChange.sink { [weak self] (_) in
            self!.objectWillChange.send()
        }
        
        WidgetManager.instance = self
        
        // TODO: only get the grades n stuff
        self.canvasAPI.getCourses()
    }
}
