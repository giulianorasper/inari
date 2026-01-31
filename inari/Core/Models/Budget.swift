//
//  Budget.swift
//  inari
//
//  Created by Claude on 31.01.26.
//

import Foundation

/// Represents a year and month for budget periods
struct BudgetPeriod: Hashable, Sendable, Comparable {
    let year: Int
    let month: Int

    // MARK: - Initialization

    init(year: Int, month: Int) {
        precondition(month >= 1 && month <= 12, "Month must be between 1 and 12")
        self.year = year
        self.month = month
    }

    /// Creates a budget period for the current month
    static var current: BudgetPeriod {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: now)
        return BudgetPeriod(
            year: components.year!,
            month: components.month!
        )
    }

    // MARK: - Computed Properties

    /// The first day of this period as a Date
    var date: Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        return Calendar.current.date(from: components)!
    }

    // MARK: - Comparable

    static func < (lhs: BudgetPeriod, rhs: BudgetPeriod) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        }
        return lhs.month < rhs.month
    }
}

// MARK: - Codable

extension BudgetPeriod: Codable {
    enum CodingKeys: String, CodingKey {
        case year, month
    }
}

/// Monthly spending limit for a category
struct Budget: Identifiable, Hashable, Sendable {
    let id: UUID
    let categoryID: UUID
    var limit: Decimal
    var period: BudgetPeriod
    var modifiedAt: Date

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        categoryID: UUID,
        limit: Decimal,
        period: BudgetPeriod,
        modifiedAt: Date = Date()
    ) {
        precondition(limit >= 0, "Budget limit must be non-negative")

        self.id = id
        self.categoryID = categoryID
        self.limit = limit
        self.period = period
        self.modifiedAt = modifiedAt
    }
}

// MARK: - Codable

extension Budget: Codable {
    enum CodingKeys: String, CodingKey {
        case id, categoryID, limit, period, modifiedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let categoryID = try container.decode(UUID.self, forKey: .categoryID)
        let limitDouble = try container.decode(Double.self, forKey: .limit)
        let period = try container.decode(BudgetPeriod.self, forKey: .period)
        let modifiedAt = try container.decode(Date.self, forKey: .modifiedAt)

        self.init(
            id: id,
            categoryID: categoryID,
            limit: Decimal(limitDouble),
            period: period,
            modifiedAt: modifiedAt
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(categoryID, forKey: .categoryID)
        try container.encode(NSDecimalNumber(decimal: limit).doubleValue, forKey: .limit)
        try container.encode(period, forKey: .period)
        try container.encode(modifiedAt, forKey: .modifiedAt)
    }
}

// MARK: - Sample Data

extension Budget {
    static let sample = Budget(
        categoryID: UUID(),
        limit: Decimal(500.00),
        period: .current
    )

    static let samplePrevious = Budget(
        categoryID: UUID(),
        limit: Decimal(450.00),
        period: BudgetPeriod(year: 2026, month: 12)
    )
}
