# Data Models

## Overview

This document defines patterns and conventions for data models in the Inari project. All models are value types (structs) in `Core/Models/` and follow consistent patterns for protocol conformance, validation, and CloudKit compatibility.

## Required Protocol Conformance

All models MUST conform to these protocols:

```swift
struct ModelName: Identifiable, Codable, Hashable, Sendable {
    // Model properties
}
```

### Protocol Requirements

- **Identifiable**: All models have a `let id: UUID` property
- **Codable**: For JSON serialization and CloudKit persistence
- **Hashable**: For use in Sets and Dictionary keys
- **Sendable**: For Swift 6 concurrency safety

## Currency and Decimal Handling

### Use Decimal for All Amounts

**ALWAYS** use `Decimal` type for currency amounts, **NEVER** use `Double` or `Float`:

```swift
// GOOD
var amount: Decimal
var limit: Decimal
var burdenRatio: Decimal

// BAD - precision loss
var amount: Double
var price: Float
```

### Codable Implementation for Decimal

Since `Decimal` doesn't automatically conform to `Codable`, manually implement encoding/decoding:

```swift
struct Transaction: Identifiable, Hashable, Sendable {
    let id: UUID
    var amount: Decimal
    // ... other properties
}

extension Transaction: Codable {
    enum CodingKeys: String, CodingKey {
        case id, amount
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(UUID.self, forKey: .id)
        let amountDouble = try container.decode(Double.self, forKey: .amount)

        self.init(
            id: id,
            amount: Decimal(amountDouble)
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(NSDecimalNumber(decimal: amount).doubleValue, forKey: .amount)
    }
}
```

### CloudKit Conversion

For CloudKit, convert `Decimal` to `NSDecimalNumber`:

```swift
// Store in CloudKit
record["amount"] = NSDecimalNumber(decimal: amount)

// Retrieve from CloudKit
let nsDecimal = record["amount"] as! NSDecimalNumber
let amount = Decimal(nsDecimal.decimalValue)
```

## Validation Patterns

### Use Preconditions in Initializers

Validate input in initializers using `precondition`:

```swift
init(
    id: UUID = UUID(),
    name: String,
    burdenRatio: Decimal = 0.5
) {
    precondition(!name.isEmpty, "Name cannot be empty")
    precondition(burdenRatio >= 0.0 && burdenRatio <= 1.0, "Burden ratio must be between 0.0 and 1.0")

    self.id = id
    self.name = name
    self.burdenRatio = burdenRatio
}
```

### Common Validations

```swift
// Non-empty strings
precondition(!name.isEmpty, "Name cannot be empty")

// Range checks
precondition(ratio >= 0.0 && ratio <= 1.0, "Ratio must be between 0.0 and 1.0")
precondition(amount != 0, "Amount cannot be zero")
precondition(month >= 1 && month <= 12, "Month must be between 1 and 12")

// Array count matching type
precondition(
    (type == .single && ownerIDs.count == 1) || (type == .twoUser && ownerIDs.count == 2),
    "Owner count must match wallet type"
)

// Conditional requirements
precondition(
    frequency != .custom || customInterval != nil,
    "Custom frequency requires customInterval"
)
```

## Enum with Associated Values

### Pattern

Use enums with associated values for type-safe variants:

```swift
enum TransactionKind: Codable, Hashable, Sendable {
    case oneTime
    case recurring(RecurringProperties)
    case spreadOut(SpreadOutProperties)
    case expectation(ExpectationProperties)
}
```

### Codable Implementation

Manually implement Codable for enums with associated values:

```swift
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
        }
    }
}
```

### Type Checking Helpers

Add computed properties for type checking:

```swift
extension TransactionKind {
    var isOneTime: Bool {
        if case .oneTime = self { return true }
        return false
    }

    var isRecurring: Bool {
        if case .recurring = self { return true }
        return false
    }

    var typeName: String {
        switch self {
        case .oneTime: return "oneTime"
        case .recurring: return "recurring"
        case .spreadOut: return "spreadOut"
        case .expectation: return "expectation"
        }
    }
}
```

## Relationships Between Models

### Use UUID References

Store relationships as UUID properties, not object references:

```swift
struct Transaction {
    let id: UUID
    let walletID: UUID      // Reference to Wallet
    let categoryID: UUID    // Reference to Category
}

struct Category {
    let id: UUID
    let walletID: UUID      // Reference to Wallet
}
```

### Relationship Patterns

```
One-to-Many:
Wallet (1) ─> (N) Transactions
  - Transaction.walletID references Wallet.id

Many-to-One:
Transactions (N) ─> (1) Category
  - Transaction.categoryID references Category.id

Nested One-to-Many:
Wallet (1) ─> (N) Categories (1) ─> (N) Budgets
  - Category.walletID references Wallet.id
  - Budget.categoryID references Category.id
```

## Immutable vs Mutable Properties

### Guideline

- Use `let` for properties that should never change
- Use `var` for properties that can be updated

```swift
struct Wallet {
    let id: UUID              // Never changes
    var name: String          // Can be updated
    let currency: CurrencyCode // Set once, immutable
    let type: WalletType      // Set once, immutable
    var burdenRatio: Decimal  // Can be adjusted
    let createdAt: Date       // Never changes
    var modifiedAt: Date      // Updated on changes
}
```

### Always Immutable

- `id` - Entity identifier
- `createdAt` - Creation timestamp
- Foreign keys (walletID, categoryID, etc.) - Relationships don't change

### Often Immutable

- `currency` - Changing currency requires data migration
- `type` - Changing wallet type has complex implications

## Sample Data Pattern

### Create Sample Data Extensions

Add sample data for SwiftUI previews and testing:

```swift
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

    static var samples: [Wallet] {
        [sampleSingle, sampleTwoUser]
    }
}
```

### Usage in Previews

```swift
#Preview {
    WalletListView()
        .environmentObject(mockEnvironment(with: Wallet.samples))
}
```

## Computed Properties

### Use for Derived Data

Computed properties should derive data from stored properties, not perform expensive operations:

```swift
struct Wallet {
    let type: WalletType
    var ownerIDs: [String]

    var isTwoUser: Bool {
        type == .twoUser
    }

    var ownerCount: Int {
        ownerIDs.count
    }
}

struct ExpectationProperties {
    let expectedAmount: Decimal
    var actualAmount: Decimal?

    var variance: Decimal? {
        guard let actual = actualAmount else { return nil }
        return actual - expectedAmount
    }

    var isReconciled: Bool {
        actualAmount != nil
    }
}
```

## Date Handling

### Use Date for Timestamps

```swift
let createdAt: Date
var modifiedAt: Date
var date: Date
```

### Custom Date Structures

For period-based dates, create custom types:

```swift
struct BudgetPeriod: Codable, Hashable, Sendable, Comparable {
    let year: Int
    let month: Int  // 1-12

    var date: Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = 1
        return Calendar.current.date(from: components)!
    }

    static var current: BudgetPeriod {
        let now = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: now)
        return BudgetPeriod(year: components.year!, month: components.month!)
    }

    static func < (lhs: BudgetPeriod, rhs: BudgetPeriod) -> Bool {
        if lhs.year != rhs.year {
            return lhs.year < rhs.year
        }
        return lhs.month < rhs.month
    }
}
```

## String-Based Enums

### Use for CloudKit Compatibility

Simple enums without associated values can use raw values:

```swift
enum WalletType: String, Codable, Hashable, Sendable {
    case single
    case twoUser
}

enum CategoryColor: String, Codable, Hashable, Sendable, CaseIterable {
    case red
    case blue
    case green
}
```

### CloudKit Storage

Raw value enums store as strings in CloudKit:

```swift
record["type"] = walletType.rawValue  // "single" or "twoUser"
```

## Adding New Models

### Checklist

When adding a new model, follow these steps:

1. **Create file in `Core/Models/`**
   - Use PascalCase filename matching struct name
   - Add standard file header

2. **Define struct with protocols**
   ```swift
   struct ModelName: Identifiable, Hashable, Sendable {
       let id: UUID
       // ... properties
   }
   ```

3. **Add Codable conformance**
   - Manual implementation if using `Decimal` or complex types
   - Ensure all properties are Codable

4. **Add initializer with validation**
   - Use preconditions for validation
   - Provide default values where appropriate

5. **Add computed properties**
   - Type checking flags
   - Derived values

6. **Add sample data extension**
   ```swift
   extension ModelName {
       static let sample = ModelName(...)
   }
   ```

7. **Update CLAUDE.md**
   - Add to Data Models section
   - Document relationships

8. **Write tests**
   - Creation validation
   - Codable round-trip
   - Computed properties

## Common Patterns

### Optional Foreign Keys

Use optional UUID for nullable relationships:

```swift
var parentCategoryID: UUID?  // Optional parent category
```

### Owner References

Store CloudKit user IDs as strings:

```swift
var ownerIDs: [String]  // CloudKit userRecordID.recordName
```

### Flags and States

Use Boolean flags for simple state:

```swift
var isArchived: Bool
var isShared: Bool
var isReconciled: Bool
```

Use enums for complex state:

```swift
enum Status: String, Codable {
    case pending
    case completed
    case cancelled
}
var status: Status
```

## Anti-Patterns

### ❌ DON'T: Use Double for Currency

```swift
// BAD - precision loss
var amount: Double = 10.10

// GOOD
var amount: Decimal = 10.10
```

### ❌ DON'T: Use Object References

```swift
// BAD - not Codable, circular references
var wallet: Wallet

// GOOD
var walletID: UUID
```

### ❌ DON'T: Skip Validation

```swift
// BAD - no validation
init(name: String, ratio: Decimal) {
    self.name = name
    self.ratio = ratio
}

// GOOD
init(name: String, ratio: Decimal) {
    precondition(!name.isEmpty, "Name cannot be empty")
    precondition(ratio >= 0.0 && ratio <= 1.0, "Ratio must be 0.0-1.0")
    self.name = name
    self.ratio = ratio
}
```

### ❌ DON'T: Use Classes for Models

```swift
// BAD - models should be value types
class Transaction { }

// GOOD
struct Transaction { }
```

### ❌ DON'T: Make Everything Mutable

```swift
// BAD - id should be immutable
var id: UUID

// GOOD
let id: UUID
```

## Related

- See `architecture.md` for MVVM patterns
- See `conventions.md` for naming conventions
- See `cloudkit.md` (Task 03) for CloudKit persistence patterns
