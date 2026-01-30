# Coding Conventions

## Overview

This document defines naming, style, and organizational conventions for the Inari project.

## File Naming

### Swift Files

- Use **PascalCase** matching the primary type name
- One primary type per file (exceptions: small related types)

**Examples:**
```
WalletListView.swift          # Contains WalletListView struct
WalletListViewModel.swift     # Contains WalletListViewModel class
CloudKitService.swift         # Contains CloudKitService class
Wallet.swift                  # Contains Wallet struct
```

### File Headers

Use Xcode's default header format:

```swift
//
//  FileName.swift
//  inari
//
//  Created by [Name] on DD.MM.YY.
//
```

## Type Naming

### Views

- Suffix: `View`
- PascalCase
- Descriptive of what they display

**Examples:**
```swift
WalletListView
WalletDetailView
CategoryPickerView
TransactionFormView
```

### ViewModels

- Suffix: `ViewModel`
- PascalCase
- Match corresponding view name

**Examples:**
```swift
WalletListViewModel       // For WalletListView
CategoryFormViewModel     // For CategoryFormView
TransactionDetailViewModel
```

### Models

- No suffix
- PascalCase
- Singular noun

**Examples:**
```swift
Wallet
Transaction
Category
DailyBudget
```

### Services

- Suffix: `Service`
- PascalCase

**Examples:**
```swift
CloudKitService
AuthenticationService
NotificationService
```

### Protocols

- Descriptive name or `Protocol` suffix for service protocols
- PascalCase

**Examples:**
```swift
ViewModel                    // Base protocol
CloudKitServiceProtocol      // Service protocol
Authenticatable              // Capability protocol
```

## Variable Naming

### General Rules

- Use **camelCase**
- Descriptive, avoid abbreviations
- No Hungarian notation or type prefixes

**Examples:**
```swift
// GOOD
let walletName: String
var selectedCategory: Category?
let transactionList: [Transaction]

// BAD
let wName: String           // Too abbreviated
let strWalletName: String   // Type prefix
let wallet_name: String     // snake_case
```

### Boolean Properties

- Use `is`, `has`, `should` prefixes for clarity

**Examples:**
```swift
var isLoading: Bool
var hasUnsavedChanges: Bool
var shouldShowError: Bool
```

### Collections

- Use plural nouns

**Examples:**
```swift
var wallets: [Wallet]
var categories: [Category]
var transactions: [Transaction]
```

### Closures

- Use descriptive names for stored closures
- Use `completion` or `handler` suffix for callback parameters

**Examples:**
```swift
var onWalletSelected: ((Wallet) -> Void)?
func loadWallets(completion: @escaping ([Wallet]) -> Void)
```

## Code Style

### Indentation

- **4 spaces** (not tabs)
- Configured in Xcode settings

### Line Length

- **Warning:** 120 characters
- **Error:** 140 characters
- Break long lines at logical points

**Example:**
```swift
// GOOD
let wallet = Wallet(
    id: UUID(),
    name: "My Wallet",
    ownerIDs: [currentUserID],
    createdAt: Date(),
    modifiedAt: Date()
)

// BAD - too long
let wallet = Wallet(id: UUID(), name: "My Wallet", ownerIDs: [currentUserID], createdAt: Date(), modifiedAt: Date())
```

### Spacing

- One blank line between methods
- Two blank lines between major sections (types, extensions)
- No blank line at start/end of type body

**Example:**
```swift
struct WalletListView: View {
    @State private var viewModel = WalletListViewModel()

    var body: some View {
        // View body
    }

    private func loadData() {
        // Implementation
    }
}


extension WalletListView {
    // Extension body
}
```

### Braces

- Opening brace on same line
- Closing brace on new line

**Example:**
```swift
if condition {
    // Code
} else {
    // Code
}
```

## Access Control

### Default to Internal

- Omit `internal` keyword (it's default)
- Explicitly mark `private`, `fileprivate`, `public`

**Example:**
```swift
// GOOD
struct Wallet {
    let id: UUID                    // internal (default)
    private var cachedValue: Int    // explicitly private
}

// UNNECESSARY
internal struct Wallet {
    internal let id: UUID
}
```

### Use Private When Possible

- Mark implementation details `private`
- Only expose what's needed

**Example:**
```swift
@MainActor
@Observable
final class WalletListViewModel: ViewModel {
    struct State {
        var wallets: [Wallet] = []  // internal - accessed by view
        var isLoading = false
    }

    var state = State()             // internal - accessed by view

    private let service: CloudKitService  // private - implementation detail

    func loadWallets() async {      // internal - called by view
        await fetchAndUpdate()
    }

    private func fetchAndUpdate() async {  // private - internal helper
        // Implementation
    }
}
```

## SwiftUI View Organization

### View Body

- Keep `body` under 50 lines
- Extract complex views into computed properties or sub-components

**Example:**
```swift
struct WalletDetailView: View {
    @State private var viewModel = WalletDetailViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    walletHeader
                    budgetSection
                    transactionsList
                }
            }
            .navigationTitle(viewModel.state.wallet.name)
        }
    }

    private var walletHeader: some View {
        // Complex header view
    }

    private var budgetSection: some View {
        // Budget information
    }

    private var transactionsList: some View {
        // Transactions list
    }
}
```

### Modifiers

- Group related modifiers
- Put navigation/toolbar modifiers last

**Example:**
```swift
Text("Hello")
    .font(.title)
    .foregroundStyle(.primary)
    .padding()
    .background(.tint.opacity(0.1))
    .clipShape(RoundedRectangle(cornerRadius: 8))
    .navigationTitle("Welcome")
    .toolbar {
        // Toolbar items
    }
```

## Async/Await

### Use Structured Concurrency

- Prefer `async/await` over completion handlers
- Use `Task` for bridging sync to async contexts
- Use `.task` modifier in SwiftUI views

**Example:**
```swift
// GOOD
func loadWallets() async {
    do {
        let wallets = try await service.fetchWallets()
        state.wallets = wallets
    } catch {
        state.errorMessage = error.localizedDescription
    }
}

// In view
.task {
    await viewModel.loadWallets()
}

// BAD - old completion handler style
func loadWallets(completion: @escaping (Result<[Wallet], Error>) -> Void) {
    // Don't use this pattern
}
```

### Task Groups for Parallel Operations

```swift
func loadAllData() async {
    await withTaskGroup(of: Void.self) { group in
        group.addTask {
            await self.loadWallets()
        }
        group.addTask {
            await self.loadCategories()
        }
    }
}
```

## Error Handling

### Typed Errors

- Define custom error types conforming to `Error`
- Use Swift 6 typed throws when possible

**Example:**
```swift
enum WalletError: Error, LocalizedError {
    case notFound
    case unauthorized
    case invalidData

    var errorDescription: String? {
        switch self {
        case .notFound:
            return "Wallet not found"
        case .unauthorized:
            return "You don't have permission to access this wallet"
        case .invalidData:
            return "Invalid wallet data"
        }
    }
}

func fetchWallet(id: UUID) async throws(WalletError) -> Wallet {
    // Implementation
}
```

### Handle Errors in ViewModels

- Catch errors in ViewModels
- Map to user-facing error messages
- Store in ViewModel state

**Example:**
```swift
func deleteWallet(_ wallet: Wallet) async {
    do {
        try await service.deleteWallet(wallet)
        state.wallets.removeAll { $0.id == wallet.id }
    } catch let error as WalletError {
        state.errorMessage = error.localizedDescription
    } catch {
        state.errorMessage = "An unexpected error occurred"
    }
}
```

## Documentation

### Public APIs

- Use `///` for documentation comments
- Include parameter and return value descriptions
- Add code examples for complex APIs

**Example:**
```swift
/// Fetches all wallets accessible to the current user.
///
/// This method retrieves wallets from CloudKit, including both
/// owned and shared wallets.
///
/// - Returns: An array of `Wallet` objects
/// - Throws: `CloudKitError` if the fetch fails
///
/// Example:
/// ```swift
/// let wallets = try await service.fetchWallets()
/// ```
func fetchWallets() async throws -> [Wallet] {
    // Implementation
}
```

### Internal Code

- Use `//` for inline comments
- Explain "why", not "what"
- Keep comments updated with code changes

**Example:**
```swift
// GOOD - explains why
// Cache the result to avoid redundant CloudKit queries
private var cachedWallets: [Wallet]?

// BAD - explains what (obvious from code)
// Set isLoading to true
state.isLoading = true
```

## Imports

### Organization

- Sort imports alphabetically
- Group: System frameworks, then third-party

**Example:**
```swift
import CloudKit
import Foundation
import SwiftUI

// Third-party would go here (currently none)
```

### Avoid Wildcard Imports

```swift
// GOOD
import Foundation

// BAD
import Foundation.*
```

## Git Commit Format

### Conventional Commits

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic changes)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(wallets): add wallet list view with CloudKit integration

- Implement WalletListView with MVVM pattern
- Add CloudKitService for fetching wallets
- Include loading and error states

Closes #12
```

```
fix(transactions): correct date formatting in transaction list

Transaction dates were showing in UTC instead of local timezone.
```

```
docs(architecture): update MVVM patterns in architecture.md
```

## SwiftLint Integration

### Running SwiftLint

```bash
# Lint all files
swiftlint

# Auto-fix violations
swiftlint --fix

# Lint specific path
swiftlint --path inari/Features/Wallets
```

### Disable Rules Sparingly

Use inline comments only when absolutely necessary:

```swift
// swiftlint:disable:next line_length
let veryLongString = "This is an exceptionally long string that cannot reasonably be broken into multiple lines without harming readability"
```

## Testing Conventions

### Test File Naming

- Suffix: `Tests`
- Match the file being tested

**Example:**
```
WalletListViewModel.swift     → WalletListViewModelTests.swift
CloudKitService.swift         → CloudKitServiceTests.swift
```

### Test Method Naming

- Use `test` prefix
- Descriptive of what's being tested
- Format: `test<Method>_<Condition>_<ExpectedResult>`

**Example:**
```swift
func testLoadWallets_whenSuccessful_populatesState() async {
    // Test implementation
}

func testLoadWallets_whenError_setsErrorMessage() async {
    // Test implementation
}

func testDeleteWallet_removesWalletFromList() async {
    // Test implementation
}
```

## Related

- See `architecture.md` for MVVM patterns
- See `.swiftlint.yml` for linting rules
- See project `REQUIREMENTS.md` for business logic
