//
//  AppEnvironment.swift
//  inari
//
//  Created by Claude on 31.01.26.
//

import Foundation

/// Container for app-level dependencies and services
@MainActor
final class AppEnvironment: ObservableObject {
    // Will be populated in Task 03 with CloudKitService
    static let shared = AppEnvironment()

    private init() {}
}
