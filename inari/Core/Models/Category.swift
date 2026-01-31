//
//  Category.swift
//  inari
//
//  Created by Claude on 31.01.26.
//

import Foundation
import SwiftUI

/// Predefined color palette for categories
enum CategoryColor: String, Codable, Hashable, Sendable, CaseIterable {
    case red
    case orange
    case yellow
    case green
    case mint
    case teal
    case cyan
    case blue
    case indigo
    case purple
    case pink

    /// SwiftUI Color representation
    var color: Color {
        switch self {
        case .red: return .red
        case .orange: return .orange
        case .yellow: return .yellow
        case .green: return .green
        case .mint: return .mint
        case .teal: return .teal
        case .cyan: return .cyan
        case .blue: return .blue
        case .indigo: return .indigo
        case .purple: return .purple
        case .pink: return .pink
        }
    }

    /// Hex color value for reference
    var hexValue: String {
        switch self {
        case .red: return "#FF3B30"
        case .orange: return "#FF9500"
        case .yellow: return "#FFCC00"
        case .green: return "#34C759"
        case .mint: return "#00C7BE"
        case .teal: return "#30B0C7"
        case .cyan: return "#32ADE6"
        case .blue: return "#007AFF"
        case .indigo: return "#5856D6"
        case .purple: return "#AF52DE"
        case .pink: return "#FF2D55"
        }
    }
}

/// Expense classification for a wallet
struct Category: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    let walletID: UUID
    var name: String
    var iconName: String
    var color: CategoryColor
    var isShared: Bool
    var sortOrder: Int
    var modifiedAt: Date

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        walletID: UUID,
        name: String,
        iconName: String = "tag.fill",
        color: CategoryColor = .blue,
        isShared: Bool = false,
        sortOrder: Int = 0,
        modifiedAt: Date = Date()
    ) {
        precondition(!name.isEmpty, "Category name cannot be empty")
        precondition(!iconName.isEmpty, "Category icon name cannot be empty")

        self.id = id
        self.walletID = walletID
        self.name = name
        self.iconName = iconName
        self.color = color
        self.isShared = isShared
        self.sortOrder = sortOrder
        self.modifiedAt = modifiedAt
    }
}

// MARK: - Sample Data

extension Category {
    static let sampleGroceries = Category(
        walletID: UUID(),
        name: "Groceries",
        iconName: "cart.fill",
        color: .green,
        sortOrder: 0
    )

    static let sampleTransport = Category(
        walletID: UUID(),
        name: "Transport",
        iconName: "car.fill",
        color: .blue,
        sortOrder: 1
    )

    static let sampleEntertainment = Category(
        walletID: UUID(),
        name: "Entertainment",
        iconName: "tv.fill",
        color: .purple,
        sortOrder: 2
    )

    static let sampleShared = Category(
        walletID: UUID(),
        name: "Rent",
        iconName: "house.fill",
        color: .orange,
        isShared: true,
        sortOrder: 0
    )

    static var samples: [Category] {
        [sampleGroceries, sampleTransport, sampleEntertainment, sampleShared]
    }
}
