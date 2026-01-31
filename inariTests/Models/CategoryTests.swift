//
//  CategoryTests.swift
//  inariTests
//
//  Created by Claude on 31.01.26.
//

import XCTest
@testable import inari

@MainActor
final class CategoryTests: XCTestCase {

    // MARK: - Initialization Tests

    func testValidCategory() {
        let category = Category(
            walletID: UUID(),
            name: "Groceries",
            iconName: "cart.fill",
            color: .green
        )

        XCTAssertEqual(category.name, "Groceries")
        XCTAssertEqual(category.iconName, "cart.fill")
        XCTAssertEqual(category.color, .green)
        XCTAssertFalse(category.isShared)
        XCTAssertEqual(category.sortOrder, 0)
    }

    func testSharedCategory() {
        let category = Category(
            walletID: UUID(),
            name: "Rent",
            isShared: true,
            sortOrder: 1
        )

        XCTAssertTrue(category.isShared)
        XCTAssertEqual(category.sortOrder, 1)
    }

    // MARK: - CategoryColor Tests

    func testCategoryColorCount() {
        XCTAssertEqual(CategoryColor.allCases.count, 11)
    }

    func testCategoryColorCases() {
        let expectedColors: [CategoryColor] = [
            .red, .orange, .yellow, .green, .mint,
            .teal, .cyan, .blue, .indigo, .purple, .pink
        ]

        XCTAssertEqual(CategoryColor.allCases, expectedColors)
    }

    func testCategoryColorHexValues() {
        XCTAssertEqual(CategoryColor.red.hexValue, "#FF3B30")
        XCTAssertEqual(CategoryColor.blue.hexValue, "#007AFF")
        XCTAssertEqual(CategoryColor.green.hexValue, "#34C759")
        XCTAssertEqual(CategoryColor.purple.hexValue, "#AF52DE")
    }

    // MARK: - Codable Tests

    func testCategoryCodable() throws {
        let original = Category(
            walletID: UUID(),
            name: "Transport",
            iconName: "car.fill",
            color: .blue,
            isShared: true,
            sortOrder: 5
        )

        let encoder = JSONEncoder()
        let data = try encoder.encode(original)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(Category.self, from: data)

        XCTAssertEqual(decoded.id, original.id)
        XCTAssertEqual(decoded.walletID, original.walletID)
        XCTAssertEqual(decoded.name, original.name)
        XCTAssertEqual(decoded.iconName, original.iconName)
        XCTAssertEqual(decoded.color, original.color)
        XCTAssertEqual(decoded.isShared, original.isShared)
        XCTAssertEqual(decoded.sortOrder, original.sortOrder)
    }

    func testCategoryColorCodable() throws {
        let color = CategoryColor.purple

        let encoder = JSONEncoder()
        let data = try encoder.encode(color)

        let decoder = JSONDecoder()
        let decoded = try decoder.decode(CategoryColor.self, from: data)

        XCTAssertEqual(decoded, .purple)
    }

    // MARK: - Hashable Tests

    func testCategoryHashable() {
        let id = UUID()
        let category1 = inari.Category(
            id: id,
            walletID: UUID(),
            name: "Category 1",
            color: .red
        )

        let category2 = inari.Category(
            id: id,
            walletID: UUID(),
            name: "Category 2",
            color: .blue
        )

        XCTAssertEqual(category1.hashValue, category2.hashValue)

        var set = Set<inari.Category>()
        set.insert(category1)
        set.insert(category2)

        XCTAssertEqual(set.count, 1)
    }

    // MARK: - Sample Data Tests

    func testSampleData() {
        XCTAssertEqual(Category.sampleGroceries.name, "Groceries")
        XCTAssertEqual(Category.sampleTransport.name, "Transport")
        XCTAssertTrue(Category.sampleShared.isShared)
        XCTAssertEqual(Category.samples.count, 4)
    }
}
