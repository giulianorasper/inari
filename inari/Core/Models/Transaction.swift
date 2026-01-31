//
//  Transaction.swift
//  inari
//
//  Created by Claude on 31.01.26.
//

import Foundation

/// A financial transaction in a wallet
struct Transaction: Identifiable, Hashable, Sendable {
    let id: UUID
    let walletID: UUID
    var amount: Decimal
    var kind: TransactionKind
    let categoryID: UUID
    var date: Date
    var description: String
    var isSharedExpense: Bool
    var customBurdenRatio: Decimal?
    var modifiedAt: Date

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        walletID: UUID,
        amount: Decimal,
        kind: TransactionKind,
        categoryID: UUID,
        date: Date = Date(),
        description: String = "",
        isSharedExpense: Bool = false,
        customBurdenRatio: Decimal? = nil,
        modifiedAt: Date = Date()
    ) {
        precondition(amount != 0, "Transaction amount cannot be zero")
        if let ratio = customBurdenRatio {
            precondition(ratio >= 0.0 && ratio <= 1.0, "Burden ratio must be between 0.0 and 1.0")
        }

        self.id = id
        self.walletID = walletID
        self.amount = amount
        self.kind = kind
        self.categoryID = categoryID
        self.date = date
        self.description = description
        self.isSharedExpense = isSharedExpense
        self.customBurdenRatio = customBurdenRatio
        self.modifiedAt = modifiedAt
    }

    // MARK: - Computed Properties

    /// Whether this is a one-time transaction
    var isOneTime: Bool {
        kind.isOneTime
    }

    /// Whether this is a recurring transaction
    var isRecurring: Bool {
        kind.isRecurring
    }

    /// Whether this is a spread out transaction
    var isSpreadOut: Bool {
        kind.isSpreadOut
    }

    /// Whether this is an expectation transaction
    var isExpectation: Bool {
        kind.isExpectation
    }

    /// The effective burden ratio (custom if set, otherwise nil to use wallet default)
    var effectiveBurdenRatio: Decimal? {
        customBurdenRatio
    }
}

// MARK: - Codable

extension Transaction: Codable {
    enum CodingKeys: String, CodingKey {
        case id, walletID, amount, kind, categoryID, date, description
        case isSharedExpense, customBurdenRatio, modifiedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let walletID = try container.decode(UUID.self, forKey: .walletID)
        let amountDouble = try container.decode(Double.self, forKey: .amount)
        let kind = try container.decode(TransactionKind.self, forKey: .kind)
        let categoryID = try container.decode(UUID.self, forKey: .categoryID)
        let date = try container.decode(Date.self, forKey: .date)
        let description = try container.decode(String.self, forKey: .description)
        let isSharedExpense = try container.decode(Bool.self, forKey: .isSharedExpense)
        let customBurdenRatioDouble = try container.decodeIfPresent(Double.self, forKey: .customBurdenRatio)
        let modifiedAt = try container.decode(Date.self, forKey: .modifiedAt)

        self.init(
            id: id,
            walletID: walletID,
            amount: Decimal(amountDouble),
            kind: kind,
            categoryID: categoryID,
            date: date,
            description: description,
            isSharedExpense: isSharedExpense,
            customBurdenRatio: customBurdenRatioDouble.map { Decimal($0) },
            modifiedAt: modifiedAt
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(walletID, forKey: .walletID)
        try container.encode(NSDecimalNumber(decimal: amount).doubleValue, forKey: .amount)
        try container.encode(kind, forKey: .kind)
        try container.encode(categoryID, forKey: .categoryID)
        try container.encode(date, forKey: .date)
        try container.encode(description, forKey: .description)
        try container.encode(isSharedExpense, forKey: .isSharedExpense)
        if let ratio = customBurdenRatio {
            try container.encode(NSDecimalNumber(decimal: ratio).doubleValue, forKey: .customBurdenRatio)
        }
        try container.encode(modifiedAt, forKey: .modifiedAt)
    }
}

// MARK: - Sample Data

extension Transaction {
    static let sampleOneTime = Transaction(
        walletID: UUID(),
        amount: Decimal(42.50),
        kind: .oneTime,
        categoryID: UUID(),
        date: Date(),
        description: "Coffee"
    )

    static let sampleRecurring = Transaction(
        walletID: UUID(),
        amount: Decimal(1200.00),
        kind: .recurring(RecurringProperties(
            frequency: .monthly,
            endDate: nil
        )),
        categoryID: UUID(),
        date: Date(),
        description: "Rent"
    )

    static let sampleSpreadOut = Transaction(
        walletID: UUID(),
        amount: Decimal(600.00),
        kind: .spreadOut(SpreadOutProperties(
            totalAmount: Decimal(600.00),
            duration: 3,
            durationType: .months,
            startDate: Date()
        )),
        categoryID: UUID(),
        date: Date(),
        description: "New laptop"
    )

    static let sampleExpectation = Transaction(
        walletID: UUID(),
        amount: Decimal(150.00),
        kind: .expectation(ExpectationProperties(
            expectedAmount: Decimal(150.00),
            actualAmount: nil
        )),
        categoryID: UUID(),
        date: Date(),
        description: "Estimated utility bill"
    )

    static let sampleShared = Transaction(
        walletID: UUID(),
        amount: Decimal(80.00),
        kind: .oneTime,
        categoryID: UUID(),
        date: Date(),
        description: "Groceries",
        isSharedExpense: true,
        customBurdenRatio: Decimal(0.6)
    )

    static var samples: [Transaction] {
        [sampleOneTime, sampleRecurring, sampleSpreadOut, sampleExpectation, sampleShared]
    }
}
