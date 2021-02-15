//
//  LogoutCommand.swift
//  Canvas
//
//  Created by Malcolm Anderson on 2/15/21.
//

import SwiftUI

struct CanvasCommands: Commands {
    @EnvironmentObject var manager: Manager
    private struct MenuContent: View {
        var body: some View {
            Button("Log Out") {
                print("time to log out, yeet")
            }
        }
    }
    
    var body: some Commands {
        CommandMenu("Account") {
            MenuContent()
        }
    }
}
