//
//  Pomodoro_appApp.swift
//  Pomodoro app
//
//  Created by Fatima Amantay on 21.04.2023.
//

import SwiftUI

@main
struct Pomodoro_appApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
            FocusCategoryView()
            PauseView()
            
        }
    }
}
