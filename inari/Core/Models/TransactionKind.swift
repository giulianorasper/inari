//
//  TransactionKind.swift
//  inari
//
//  Created by Claude on 31.01.26.
//

import Foundation

// MARK: - Recurring Transaction

/// Frequency of recurring transactions
enum RecurringFrequency: String, Codable, Hashable, Sendable {
    case daily
    case weekly
    case biWeekly
    case monthly
    case yearly
    case custom
}

/// Properties for recurring transactions
struct RecurringProperties: Codable, Hashable, Sendable {
    let frequency: RecurringFrequency
    let endDate: Date?
    let customInterval: Int?

    init(
        frequency: RecurringFrequency,
        endDate: Date? = nil,
        customInterval: Int? = nil
    ) {
        precondition(
            frequency != .custom || customInterval != nil,
            "Custom frequency requires customInterval to be set"
        )
        precondition(
            customInterval == nil || customInterval! > 0,
            "Custom interval must be positive"
        )

        self.frequency = frequency
        self.endDate = endDate
        self.customInterval = customInterval
    }
}

// MARK: - Spread Out Transaction

/// Duration unit for spread out transactions
enum SpreadDuration: String, Codable, Hashable, Sendable {
    case days
    case weeks
    case months
}

/// Properties for spread out transactions
struct SpreadOutProperties: Codable, Hashable, Sendable {
    let totalAmount: Decimal
    let duration: Int
    let durationType: SpreadDuration
    let startDate: Date
    let endDate: Date

    init(
        totalAmount: Decimal,
        duration: Int,
        durationType: SpreadDuration,
        startDate: Date
    ) {
        precondition(duration > 0, "Duration must be positive")

        self.totalAmount = totalAmount
        self.duration = duration
        self.durationType = durationType
        self.startDate = startDate

        // Calculate end date
        let calendar = Calendar.current
        switch durationType {
        case .days:
            self.endDate = calendar.date(byAdding: .day, value: duration, to: startDate)!
        case .weeks:
            self.endDate = calendar.date(byAdding: .weekOfYear, value: duration, to: startDate)!
        case .months:
            self.endDate = calendar.date(byAdding: .month, value: duration, to: startDate)!
        }
    }

    // MARK: - Computed Properties

    /// Daily amount for this spread out transaction
    var dailyAmount: Decimal {
        let calendar = Calendar.current
        let days = calendar.dateComponents([.day], from: startDate, to: endDate).day ?? 1
        return totalAmount / Decimal(max(days, 1))
    }

    /// Monthly amount for this spread out transaction
    var monthlyAmount: Decimal {
        switch durationType {
        case .days:
            let daysInMonth = Decimal(30) // Average
            return dailyAmount * daysInMonth
        case .weeks:
            return totalAmount / Decimal(duration) * Decimal(4.33) // Average weeks per month
        case .months:
            return totalAmount / Decimal(duration)
        }
    }
}

// MARK: - Codable for SpreadOutProperties

extension SpreadOutProperties {
    enum CodingKeys: String, CodingKey {
        case totalAmount, duration, durationType, startDate, endDate
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let totalAmountDouble = try container.decode(Double.self, forKey: .totalAmount)
        let duration = try container.decode(Int.self, forKey: .duration)
        let durationType = try container.decode(SpreadDuration.self, forKey: .durationType)
        let startDate = try container.decode(Date.self, forKey: .startDate)
        let endDate = try container.decode(Date.self, forKey: .endDate)

        self.totalAmount = Decimal(totalAmountDouble)
        self.duration = duration
        self.durationType = durationType
        self.startDate = startDate
        self.endDate = endDate
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(NSDecimalNumber(decimal: totalAmount).doubleValue, forKey: .totalAmount)
        try container.encode(duration, forKey: .duration)
        try container.encode(durationType, forKey: .durationType)
        try container.encode(startDate, forKey: .startDate)
        try container.encode(endDate, forKey: .endDate)
    }
}

// MARK: - Expectation Transaction

/// Properties for expectation transactions
struct ExpectationProperties: Codable, Hashable, Sendable {
    let expectedAmount: Decimal
    var actualAmount: Decimal?

    init(expectedAmount: Decimal, actualAmount: Decimal? = nil) {
        self.expectedAmount = expectedAmount
        self.actualAmount = actualAmount
    }

    // MARK: - Computed Properties

    /// Difference between expected and actual (nil if not reconciled)
    var variance: Decimal? {
        guard let actual = actualAmount else { return nil }
        return actual - expectedAmount
    }

    /// Whether this expectation has been reconciled
    var isReconciled: Bool {
        actualAmount != nil
    }
}

// MARK: - Codable for ExpectationProperties

extension ExpectationProperties {
    enum CodingKeys: String, CodingKey {
        case expectedAmount, actualAmount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let expectedDouble = try container.decode(Double.self, forKey: .expectedAmount)
        let actualDouble = try container.decodeIfPresent(Double.self, forKey: .actualAmount)

        self.expectedAmount = Decimal(expectedDouble)
        self.actualAmount = actualDouble.map { Decimal($0) }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(NSDecimalNumber(decimal: expectedAmount).doubleValue, forKey: .expectedAmount)
        if let actual = actualAmount {
            try container.encode(NSDecimalNumber(decimal: actual).doubleValue, forKey: .actualAmount)
        }
    }
}

// MARK: - Transaction Kind

/// Type of transaction with associated properties
enum TransactionKind: Codable, Hashable, Sendable {
    case oneTime
    case recurring(RecurringProperties)
    case spreadOut(SpreadOutProperties)
    case expectation(ExpectationProperties)

    // MARK: - Type Checking

    var isOneTime: Bool {
        if case .oneTime = self { return true }
        return false
    }

    var isRecurring: Bool {
        if case .recurring = self { return true }
        return false
    }

    var isSpreadOut: Bool {
        if case .spreadOut = self { return true }
        return false
    }

    var isExpectation: Bool {
        if case .expectation = self { return true }
        return false
    }

    /// Type name for CloudKit queries
    var typeName: String {
        switch self {
        case .oneTime: return "oneTime"
        case .recurring: return "recurring"
        case .spreadOut: return "spreadOut"
        case .expectation: return "expectation"
        }
    }
}

// MARK: - Codable

extension TransactionKind {
    enum CodingKeys: String, CodingKey {
        case type, properties
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "oneTime":
            self = .oneTime
        case "recurring":
            let props = try container.decode(RecurringProperties.self, forKey: .properties)
            self = .recurring(props)
        case "spreadOut":
            let props = try container.decode(SpreadOutProperties.self, forKey: .properties)
            self = .spreadOut(props)
        case "expectation":
            let props = try container.decode(ExpectationProperties.self, forKey: .properties)
            self = .expectation(props)
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "Unknown transaction kind: \(type)"
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .oneTime:
            try container.encode("oneTime", forKey: .type)
        case .recurring(let props):
            try container.encode("recurring", forKey: .type)
            try container.encode(props, forKey: .properties)
        case .spreadOut(let props):
            try container.encode("spreadOut", forKey: .type)
            try container.encode(props, forKey: .properties)
        case .expectation(let props):
            try container.encode("expectation", forKey: .type)
            try container.encode(props, forKey: .properties)
        }
    }
}
