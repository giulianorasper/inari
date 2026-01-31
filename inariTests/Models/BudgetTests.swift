//
//  BudgetTests.swift
//  inariTests
//
//  Created by Claude on 31.01.26.
//

import XCTest
@testable import inari

@MainActor
final class BudgetTests: XCTestCase {

    // MARK: - BudgetPeriod Tests

    func testValidBudgetPeriod() {
        let period = BudgetPeriod(year: 2026, month: 1)
        XCTAssertEqual(period.year, 2026)
        XCTAssertEqual(period.month, 1)
    }

    func testCurrentPeriod() {
        let current = BudgetPeriod.current
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: now)

        XCTAssertEqual(current.year, components.year)
        XCTAssertEqual(current.month, components.month)
    }

    func testBudgetPeriodDate() {
        let period = BudgetPeriod(year: 2026, month: 3)
        let date = period.date

        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)

        XCTAssertEqual(components.year, 2026)
        XCTAssertEqual(components.month, 3)
        XCTAssertEqual(components.day, 1)
    }

    func testBudgetPeriodComparable() {
        let jan2026 = BudgetPeriod(year: 2026, month: 1)
        let feb2026 = BudgetPeriod(year: 2026, month: 2)
        let jan2027 = BudgetPeriod(year: 2027, month: 1)

        XCTAssertTrue(jan2026 < feb2026)
        XCTAssertTrue(feb2026 < jan2027)
        XCTAssertTrue(jan2026 < jan2027)
        XCTAssertFalse(feb2026 < jan2026)
    }

    func testBudgetPeriodEquality() {
        let period1 = BudgetPeriod(year: 2026, month: 6)
        let period2 = BudgetPeriod(year: 2026, month: 6)
        let period3 = BudgetPeriod(year: 2026, month: 7)

        XCTAssertEqual(period1, period2)
        XCTAssertNotEqual(period1, period3)
    }

    func testBudgetPeriodCodable() throws {
        let period = BudgetPeriod(year: 2026, month: 12)

        let encoder = JSONEncoder()
        let data = try encoder.encode(period)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(BudgetPeriod.self, from: data)

        XCTAssertEqual(decoded.year, 2026)
        XCTAssertEqual(decoded.month, 12)
    }

    // MARK: - Budget Tests

    func testValidBudget() {
        let budget = Budget(
            categoryID: UUID(),
            limit: Decimal(500),
            period: BudgetPeriod(year: 2026, month: 1)
        )

        XCTAssertEqual(budget.limit, 500)
        XCTAssertEqual(budget.period.year, 2026)
        XCTAssertEqual(budget.period.month, 1)
    }

    func testBudgetCodable() throws {
        let original = Budget(
            categoryID: UUID(),
            limit: Decimal(750.50),
            period: BudgetPeriod(year: 2026, month: 3)
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(original)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Budget.self, from: data)

        XCTAssertEqual(decoded.id, original.id)
        XCTAssertEqual(decoded.categoryID, original.categoryID)
        XCTAssertEqual(decoded.limit, original.limit)
        XCTAssertEqual(decoded.period, original.period)
    }

    func testBudgetHashable() {
        let budget1 = Budget(
            categoryID: UUID(),
            limit: Decimal(100),
            period: .current
        )

        let budget2 = Budget(
            categoryID: UUID(),
            limit: Decimal(100),
            period: .current
        )

        // Different instances, different IDs
        XCTAssertNotEqual(budget1, budget2)
        XCTAssertNotEqual(budget1.id, budget2.id)

        // Can be used in sets
        var set = Set<Budget>()
        set.insert(budget1)
        set.insert(budget2)
        XCTAssertEqual(set.count, 2)

        // Same instance is equal to itself
        XCTAssertEqual(budget1, budget1)
    }
}
