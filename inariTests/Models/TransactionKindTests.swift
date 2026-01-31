//
//  TransactionKindTests.swift
//  inariTests
//
//  Created by Claude on 31.01.26.
//

import XCTest
@testable import inari

@MainActor
final class TransactionKindTests: XCTestCase {

    // MARK: - RecurringProperties Tests

    func testRecurringPropertiesMonthly() {
        let props = RecurringProperties(frequency: .monthly, endDate: nil)
        XCTAssertEqual(props.frequency, .monthly)
        XCTAssertNil(props.endDate)
        XCTAssertNil(props.customInterval)
    }

    func testRecurringPropertiesCustomInterval() {
        let props = RecurringProperties(
            frequency: .custom,
            customInterval: 14
        )
        XCTAssertEqual(props.frequency, .custom)
        XCTAssertEqual(props.customInterval, 14)
    }

    // MARK: - SpreadOutProperties Tests

    func testSpreadOutPropertiesDays() {
        let startDate = Date()
        let props = SpreadOutProperties(
            totalAmount: Decimal(600),
            duration: 30,
            durationType: .days,
            startDate: startDate
        )

        XCTAssertEqual(props.totalAmount, 600)
        XCTAssertEqual(props.duration, 30)
        XCTAssertEqual(props.durationType, .days)

        // Check daily amount calculation
        let expectedDaily = Decimal(600) / Decimal(30)
        XCTAssertEqual(props.dailyAmount, expectedDaily)
    }

    func testSpreadOutPropertiesMonths() {
        let startDate = Date()
        let props = SpreadOutProperties(
            totalAmount: Decimal(900),
            duration: 3,
            durationType: .months,
            startDate: startDate
        )

        XCTAssertEqual(props.totalAmount, 900)
        XCTAssertEqual(props.duration, 3)

        // Check monthly amount
        let expectedMonthly = Decimal(900) / Decimal(3)
        XCTAssertEqual(props.monthlyAmount, expectedMonthly)
    }

    func testSpreadOutEndDateCalculation() {
        let calendar = Calendar.current
        let startDate = Date()

        // Test days
        let dayProps = SpreadOutProperties(
            totalAmount: Decimal(100),
            duration: 7,
            durationType: .days,
            startDate: startDate
        )
        let expectedEndDate = calendar.date(byAdding: .day, value: 7, to: startDate)!
        XCTAssertEqual(calendar.component(.day, from: dayProps.endDate),
                      calendar.component(.day, from: expectedEndDate))

        // Test months
        let monthProps = SpreadOutProperties(
            totalAmount: Decimal(300),
            duration: 2,
            durationType: .months,
            startDate: startDate
        )
        let expectedMonthEnd = calendar.date(byAdding: .month, value: 2, to: startDate)!
        XCTAssertEqual(calendar.component(.month, from: monthProps.endDate),
                      calendar.component(.month, from: expectedMonthEnd))
    }

    // MARK: - ExpectationProperties Tests

    func testExpectationPropertiesNotReconciled() {
        let props = ExpectationProperties(expectedAmount: Decimal(100))

        XCTAssertEqual(props.expectedAmount, 100)
        XCTAssertNil(props.actualAmount)
        XCTAssertNil(props.variance)
        XCTAssertFalse(props.isReconciled)
    }

    func testExpectationPropertiesReconciled() {
        let props = ExpectationProperties(
            expectedAmount: Decimal(100),
            actualAmount: Decimal(95)
        )

        XCTAssertEqual(props.expectedAmount, 100)
        XCTAssertEqual(props.actualAmount, 95)
        XCTAssertEqual(props.variance, -5)
        XCTAssertTrue(props.isReconciled)
    }

    func testExpectationVariancePositive() {
        let props = ExpectationProperties(
            expectedAmount: Decimal(100),
            actualAmount: Decimal(110)
        )

        XCTAssertEqual(props.variance, 10) // Spent more than expected
    }

    // MARK: - TransactionKind Tests

    func testOneTimeKind() {
        let kind = TransactionKind.oneTime

        XCTAssertTrue(kind.isOneTime)
        XCTAssertFalse(kind.isRecurring)
        XCTAssertFalse(kind.isSpreadOut)
        XCTAssertFalse(kind.isExpectation)
        XCTAssertEqual(kind.typeName, "oneTime")
    }

    func testRecurringKind() {
        let props = RecurringProperties(frequency: .monthly)
        let kind = TransactionKind.recurring(props)

        XCTAssertFalse(kind.isOneTime)
        XCTAssertTrue(kind.isRecurring)
        XCTAssertFalse(kind.isSpreadOut)
        XCTAssertFalse(kind.isExpectation)
        XCTAssertEqual(kind.typeName, "recurring")
    }

    func testSpreadOutKind() {
        let props = SpreadOutProperties(
            totalAmount: Decimal(300),
            duration: 3,
            durationType: .months,
            startDate: Date()
        )
        let kind = TransactionKind.spreadOut(props)

        XCTAssertFalse(kind.isOneTime)
        XCTAssertFalse(kind.isRecurring)
        XCTAssertTrue(kind.isSpreadOut)
        XCTAssertFalse(kind.isExpectation)
        XCTAssertEqual(kind.typeName, "spreadOut")
    }

    func testExpectationKind() {
        let props = ExpectationProperties(expectedAmount: Decimal(100))
        let kind = TransactionKind.expectation(props)

        XCTAssertFalse(kind.isOneTime)
        XCTAssertFalse(kind.isRecurring)
        XCTAssertFalse(kind.isSpreadOut)
        XCTAssertTrue(kind.isExpectation)
        XCTAssertEqual(kind.typeName, "expectation")
    }

    // MARK: - Codable Tests

    func testOneTimeCodable() throws {
        let kind = TransactionKind.oneTime

        let encoder = JSONEncoder()
        let data = try encoder.encode(kind)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(TransactionKind.self, from: data)

        XCTAssertTrue(decoded.isOneTime)
    }

    func testRecurringCodable() throws {
        let props = RecurringProperties(
            frequency: .weekly,
            endDate: Date(timeIntervalSince1970: 1000000)
        )
        let kind = TransactionKind.recurring(props)

        let encoder = JSONEncoder()
        let data = try encoder.encode(kind)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(TransactionKind.self, from: data)

        XCTAssertTrue(decoded.isRecurring)
        if case .recurring(let decodedProps) = decoded {
            XCTAssertEqual(decodedProps.frequency, .weekly)
            XCTAssertNotNil(decodedProps.endDate)
        } else {
            XCTFail("Expected recurring kind")
        }
    }

    func testSpreadOutCodable() throws {
        let props = SpreadOutProperties(
            totalAmount: Decimal(600),
            duration: 30,
            durationType: .days,
            startDate: Date()
        )
        let kind = TransactionKind.spreadOut(props)

        let encoder = JSONEncoder()
        let data = try encoder.encode(kind)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(TransactionKind.self, from: data)

        XCTAssertTrue(decoded.isSpreadOut)
        if case .spreadOut(let decodedProps) = decoded {
            XCTAssertEqual(decodedProps.totalAmount, 600)
            XCTAssertEqual(decodedProps.duration, 30)
            XCTAssertEqual(decodedProps.durationType, .days)
        } else {
            XCTFail("Expected spreadOut kind")
        }
    }

    func testExpectationCodable() throws {
        let props = ExpectationProperties(
            expectedAmount: Decimal(150),
            actualAmount: Decimal(145.50)
        )
        let kind = TransactionKind.expectation(props)

        let encoder = JSONEncoder()
        let data = try encoder.encode(kind)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(TransactionKind.self, from: data)

        XCTAssertTrue(decoded.isExpectation)
        if case .expectation(let decodedProps) = decoded {
            XCTAssertEqual(decodedProps.expectedAmount, 150)
            XCTAssertEqual(decodedProps.actualAmount, 145.50)
        } else {
            XCTFail("Expected expectation kind")
        }
    }
}
