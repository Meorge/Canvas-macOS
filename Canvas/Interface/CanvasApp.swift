//
//  CanvasApp.swift
//  Canvas
//
//  Created by Test Account on 9/25/20.
//

import SwiftUI
import AppKit


@main
struct CanvasApp: App {
    @StateObject private var canvasAPI = Manager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(canvasAPI)
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        if self.canvasAPI.canvasAPI.numberOfActiveRequests > 0 {
                            ProgressView()
                                .frame(maxHeight: 20)
                        }
                    }
                }
        }
    }
}
