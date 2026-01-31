//
//  TransactionTests.swift
//  inariTests
//
//  Created by Claude on 31.01.26.
//

import XCTest
@testable import inari

@MainActor
final class TransactionTests: XCTestCase {

    // MARK: - Initialization Tests

    func testValidOneTimeTransaction() {
        let transaction = Transaction(
            walletID: UUID(),
            amount: Decimal(50.00),
            kind: .oneTime,
            categoryID: UUID(),
            date: Date(),
            description: "Coffee"
        )

        XCTAssertEqual(transaction.amount, 50.00)
        XCTAssertTrue(transaction.isOneTime)
        XCTAssertFalse(transaction.isSharedExpense)
        XCTAssertNil(transaction.customBurdenRatio)
    }

    func testValidRecurringTransaction() {
        let props = RecurringProperties(frequency: .monthly)
        let transaction = Transaction(
            walletID: UUID(),
            amount: Decimal(1200),
            kind: .recurring(props),
            categoryID: UUID(),
            description: "Rent"
        )

        XCTAssertEqual(transaction.amount, 1200)
        XCTAssertTrue(transaction.isRecurring)
        XCTAssertFalse(transaction.isOneTime)
    }

    func testValidSharedExpense() {
        let transaction = Transaction(
            walletID: UUID(),
            amount: Decimal(100),
            kind: .oneTime,
            categoryID: UUID(),
            isSharedExpense: true,
            customBurdenRatio: Decimal(0.7)
        )

        XCTAssertTrue(transaction.isSharedExpense)
        XCTAssertEqual(transaction.customBurdenRatio, 0.7)
        XCTAssertEqual(transaction.effectiveBurdenRatio, 0.7)
    }

    // MARK: - Computed Properties

    func testTypeCheckingProperties() {
        let oneTime = Transaction(
            walletID: UUID(),
            amount: Decimal(10),
            kind: .oneTime,
            categoryID: UUID()
        )
        XCTAssertTrue(oneTime.isOneTime)
        XCTAssertFalse(oneTime.isRecurring)
        XCTAssertFalse(oneTime.isSpreadOut)
        XCTAssertFalse(oneTime.isExpectation)

        let recurring = Transaction(
            walletID: UUID(),
            amount: Decimal(100),
            kind: .recurring(RecurringProperties(frequency: .weekly)),
            categoryID: UUID()
        )
        XCTAssertTrue(recurring.isRecurring)
        XCTAssertFalse(recurring.isOneTime)

        let spreadOut = Transaction(
            walletID: UUID(),
            amount: Decimal(300),
            kind: .spreadOut(SpreadOutProperties(
                totalAmount: Decimal(300),
                duration: 3,
                durationType: .months,
                startDate: Date()
            )),
            categoryID: UUID()
        )
        XCTAssertTrue(spreadOut.isSpreadOut)
        XCTAssertFalse(spreadOut.isOneTime)

        let expectation = Transaction(
            walletID: UUID(),
            amount: Decimal(50),
            kind: .expectation(ExpectationProperties(expectedAmount: Decimal(50))),
            categoryID: UUID()
        )
        XCTAssertTrue(expectation.isExpectation)
        XCTAssertFalse(expectation.isOneTime)
    }

    func testEffectiveBurdenRatio() {
        let withCustom = Transaction(
            walletID: UUID(),
            amount: Decimal(100),
            kind: .oneTime,
            categoryID: UUID(),
            customBurdenRatio: Decimal(0.6)
        )
        XCTAssertEqual(withCustom.effectiveBurdenRatio, 0.6)

        let withoutCustom = Transaction(
            walletID: UUID(),
            amount: Decimal(100),
            kind: .oneTime,
            categoryID: UUID()
        )
        XCTAssertNil(withoutCustom.effectiveBurdenRatio)
    }

    // MARK: - Codable Tests

    func testCodableRoundTrip() throws {
        let original = Transaction(
            walletID: UUID(),
            amount: Decimal(99.99),
            kind: .oneTime,
            categoryID: UUID(),
            date: Date(),
            description: "Test transaction",
            isSharedExpense: true,
            customBurdenRatio: Decimal(0.55)
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(original)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Transaction.self, from: data)

        XCTAssertEqual(decoded.id, original.id)
        XCTAssertEqual(decoded.walletID, original.walletID)
        XCTAssertEqual(decoded.amount, original.amount)
        XCTAssertEqual(decoded.categoryID, original.categoryID)
        XCTAssertEqual(decoded.description, original.description)
        XCTAssertEqual(decoded.isSharedExpense, original.isSharedExpense)
        XCTAssertEqual(decoded.customBurdenRatio, original.customBurdenRatio)
    }

    func testCodableWithRecurringKind() throws {
        let props = RecurringProperties(
            frequency: .biWeekly,
            endDate: Date(timeIntervalSince1970: 2000000)
        )
        let original = Transaction(
            walletID: UUID(),
            amount: Decimal(250),
            kind: .recurring(props),
            categoryID: UUID()
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(original)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Transaction.self, from: data)

        XCTAssertTrue(decoded.isRecurring)
        if case .recurring(let decodedProps) = decoded.kind {
            XCTAssertEqual(decodedProps.frequency, .biWeekly)
        } else {
            XCTFail("Expected recurring kind")
        }
    }

    // MARK: - Hashable Tests

    func testHashable() {
        let transaction1 = Transaction(
            walletID: UUID(),
            amount: Decimal(100),
            kind: .oneTime,
            categoryID: UUID()
        )

        let transaction2 = Transaction(
            walletID: UUID(),
            amount: Decimal(100),
            kind: .oneTime,
            categoryID: UUID()
        )

        // Different instances, different IDs
        XCTAssertNotEqual(transaction1, transaction2)
        XCTAssertNotEqual(transaction1.id, transaction2.id)

        // Can be used in sets
        var set = Set<Transaction>()
        set.insert(transaction1)
        set.insert(transaction2)
        XCTAssertEqual(set.count, 2)

        // Same instance is equal to itself
        XCTAssertEqual(transaction1, transaction1)
    }
}
