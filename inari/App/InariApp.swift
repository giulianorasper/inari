//
//  InariApp.swift
//  inari
//
//  Created by Giuliano Rasper on 27.12.25.
//

import SwiftUI

@main
struct InariApp: App {
    @StateObject private var environment = AppEnvironment.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(environment)
        }
    }
}
