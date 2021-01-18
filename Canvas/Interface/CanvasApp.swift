//
//  CanvasApp.swift
//  Canvas
//
//  Created by Test Account on 9/25/20.
//

import SwiftUI

@main
struct CanvasApp: App {
    @StateObject private var canvasAPI = Manager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(canvasAPI)
        }
    }
}
