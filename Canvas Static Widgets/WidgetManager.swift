//
//  WidgetManager.swift
//  Canvas
//
//  Created by Malcolm Anderson on 1/24/21.
//

import Foundation
import Combine
import WidgetKit

class WidgetManager: ObservableObject {
    static var instance: WidgetManager? = nil
    @Published var canvasAPI: CanvasAPI = CanvasAPI()
    
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
        
//        self.canvasAPI = CanvasAPI(token)
        
        anyCancellable = self.canvasAPI.objectWillChange.sink { [weak self] (_) in
            self!.objectWillChange.send()
            
            print("widget stuff should update now")
            WidgetCenter.shared.reloadTimelines(ofKind: "com.malcolminyo.Canvas.Canvas-Static-Widgets")
        }
        
        WidgetManager.instance = self

        self.canvasAPI.getCourses()
    }
}
