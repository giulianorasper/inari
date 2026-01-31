//
//  Wallet.swift
//  inari
//
//  Created by Claude on 31.01.26.
//

import Foundation

/// Type of wallet ownership
enum WalletType: String, Codable, Hashable, Sendable {
    case single
    case twoUser
}

/// A budget container that can be owned by one or two users
struct Wallet: Identifiable, Hashable, Sendable {
    let id: UUID
    var name: String
    let currency: CurrencyCode
    let type: WalletType
    var burdenRatio: Decimal
    var isArchived: Bool
    var ownerIDs: [String]
    let createdAt: Date
    var modifiedAt: Date

    // MARK: - Initialization

    init(
        id: UUID = UUID(),
        name: String,
        currency: CurrencyCode,
        type: WalletType,
        burdenRatio: Decimal = 0.5,
        isArchived: Bool = false,
        ownerIDs: [String],
        createdAt: Date = Date(),
        modifiedAt: Date = Date()
    ) {
        precondition(!name.isEmpty, "Wallet name cannot be empty")
        precondition(burdenRatio >= 0.0 && burdenRatio <= 1.0, "Burden ratio must be between 0.0 and 1.0")
        precondition(
            (type == .single && ownerIDs.count == 1) || (type == .twoUser && ownerIDs.count == 2),
            "Owner count must match wallet type (single: 1, twoUser: 2)"
        )

        self.id = id
        self.name = name
        self.currency = currency
        self.type = type
        self.burdenRatio = burdenRatio
        self.isArchived = isArchived
        self.ownerIDs = ownerIDs
        self.createdAt = createdAt
        self.modifiedAt = modifiedAt
    }

    // MARK: - Computed Properties

    /// Whether this is a two-user wallet
    var isTwoUser: Bool {
        type == .twoUser
    }

    /// Number of owners
    var ownerCount: Int {
        ownerIDs.count
    }
}

// MARK: - Codable

extension Wallet: Codable {
    enum CodingKeys: String, CodingKey {
        case id, name, currency, type, burdenRatio, isArchived, ownerIDs, createdAt, modifiedAt
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let currency = try container.decode(CurrencyCode.self, forKey: .currency)
        let type = try container.decode(WalletType.self, forKey: .type)
        let burdenRatioDouble = try container.decode(Double.self, forKey: .burdenRatio)
        let isArchived = try container.decode(Bool.self, forKey: .isArchived)
        let ownerIDs = try container.decode([String].self, forKey: .ownerIDs)
        let createdAt = try container.decode(Date.self, forKey: .createdAt)
        let modifiedAt = try container.decode(Date.self, forKey: .modifiedAt)

        self.init(
            id: id,
            name: name,
            currency: currency,
            type: type,
            burdenRatio: Decimal(burdenRatioDouble),
            isArchived: isArchived,
            ownerIDs: ownerIDs,
            createdAt: createdAt,
            modifiedAt: modifiedAt
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(currency, forKey: .currency)
        try container.encode(type, forKey: .type)
        try container.encode(NSDecimalNumber(decimal: burdenRatio).doubleValue, forKey: .burdenRatio)
        try container.encode(isArchived, forKey: .isArchived)
        try container.encode(ownerIDs, forKey: .ownerIDs)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(modifiedAt, forKey: .modifiedAt)
    }
}

// MARK: - Sample Data

extension Wallet {
    static let sampleSingle = Wallet(
        name: "Personal Budget",
        currency: .usd,
        type: .single,
        ownerIDs: ["user123"]
    )

    static let sampleTwoUser = Wallet(
        name: "Shared Expenses",
        currency: .eur,
        type: .twoUser,
        burdenRatio: 0.6,
        ownerIDs: ["user123", "user456"]
    )

    static let sampleArchived = Wallet(
        name: "Old Wallet",
        currency: .gbp,
        type: .single,
        isArchived: true,
        ownerIDs: ["user123"]
    )
}
