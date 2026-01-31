//
//  CurrencyCode.swift
//  inari
//
//  Created by Claude on 31.01.26.
//

import Foundation

/// ISO 4217 currency code (e.g., "USD", "EUR", "GBP")
struct CurrencyCode: Codable, Hashable, Sendable {
    let code: String

    init(_ code: String) {
        precondition(code.count == 3, "Currency code must be exactly 3 characters")
        precondition(code.allSatisfy { $0.isUppercase || $0.isNumber }, "Currency code must be uppercase letters or numbers")
        self.code = code
    }

    // MARK: - Common Currencies

    static let usd = CurrencyCode("USD")
    static let eur = CurrencyCode("EUR")
    static let gbp = CurrencyCode("GBP")
    static let jpy = CurrencyCode("JPY")
    static let cad = CurrencyCode("CAD")
    static let aud = CurrencyCode("AUD")
    static let chf = CurrencyCode("CHF")
    static let cny = CurrencyCode("CNY")
    static let inr = CurrencyCode("INR")
    static let brl = CurrencyCode("BRL")

    // MARK: - Display

    /// Returns the currency symbol (e.g., "$", "€", "£")
    var symbol: String {
        let locale = Locale.availableIdentifiers
            .lazy
            .map { Locale(identifier: $0) }
            .first { $0.currency?.identifier == code }

        return locale?.currencySymbol ?? code
    }

    /// Formatted display with symbol (e.g., "$" for USD, "€" for EUR)
    var displayName: String {
        "\(symbol) (\(code))"
    }
}

// MARK: - Codable

extension CurrencyCode {
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let code = try container.decode(String.self)
        self.init(code)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(code)
    }
}

// MARK: - CustomStringConvertible

extension CurrencyCode: CustomStringConvertible {
    var description: String {
        code
    }
}
