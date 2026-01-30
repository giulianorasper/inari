# Architecture Patterns

## Overview

Inari uses MVVM (Model-View-ViewModel) with Swift's native Observation framework for clean separation of concerns and testability.

## MVVM Components

### Models

**Location:** `Core/Models/`

**Rules:**
- Use value types (`struct`) for all domain models
- Conform to `Identifiable, Codable, Hashable, Sendable`
- Keep models pure - no business logic or side effects
- Use computed properties for derived data only

**Example:**
```swift
struct Wallet: Identifiable, Codable, Hashable, Sendable {
    let id: UUID
    var name: String
    var ownerIDs: [String]
    var createdAt: Date
    var modifiedAt: Date

    var isShared: Bool {
        ownerIDs.count > 1
    }
}
```

### Views

**Location:** `Features/*/Views/`

**Rules:**
- UI presentation only - no business logic
- Own ViewModel via `@State` property
- Delegate all actions to ViewModel
- Extract complex views into sub-components
- Keep view body under 50 lines (use computed properties or sub-views)

**Example:**
```swift
struct WalletListView: View {
    @State private var viewModel = WalletListViewModel()

    var body: some View {
        NavigationStack {
            contentView
                .navigationTitle("Wallets")
                .task {
                    await viewModel.loadWallets()
                }
        }
    }

    @ViewBuilder
    private var contentView: some View {
        if viewModel.state.isLoading {
            ProgressView()
        } else {
            walletList
        }
    }

    private var walletList: some View {
        List(viewModel.state.wallets) { wallet in
            WalletRow(wallet: wallet)
                .onTapGesture {
                    viewModel.selectWallet(wallet)
                }
        }
    }
}
```

### ViewModels

**Location:** `Features/*/ViewModels/`

**Rules:**
- MUST use `@Observable` macro
- MUST be marked `@MainActor`
- MUST conform to `ViewModel` protocol
- MUST have a nested `State` struct containing all state
- Use reference types (`class`) for ViewModels
- Contain all business logic for the view
- Call services for data operations
- Handle errors and map to user-facing messages

**Example:**
```swift
@MainActor
@Observable
final class WalletListViewModel: ViewModel {
    struct State {
        var wallets: [Wallet] = []
        var isLoading = false
        var errorMessage: String?
        var selectedWallet: Wallet?
    }

    var state = State()

    private let cloudKitService: CloudKitService

    init(cloudKitService: CloudKitService = .shared) {
        self.cloudKitService = cloudKitService
    }

    func loadWallets() async {
        state.isLoading = true
        state.errorMessage = nil

        do {
            state.wallets = try await cloudKitService.fetchWallets()
        } catch {
            state.errorMessage = "Failed to load wallets: \(error.localizedDescription)"
        }

        state.isLoading = false
    }

    func selectWallet(_ wallet: Wallet) {
        state.selectedWallet = wallet
    }

    func deleteWallet(_ wallet: Wallet) async {
        do {
            try await cloudKitService.deleteWallet(wallet)
            state.wallets.removeAll { $0.id == wallet.id }
        } catch {
            state.errorMessage = "Failed to delete wallet: \(error.localizedDescription)"
        }
    }
}
```

### Services

**Location:** `Core/Services/`

**Rules:**
- Protocol-based for testability
- Singletons or dependency-injected via `AppEnvironment`
- Handle all external interactions (CloudKit, authentication, etc.)
- Return typed errors using Swift's typed `throws`
- Mark as `@MainActor` if they update state

**Example:**
```swift
protocol CloudKitServiceProtocol {
    func fetchWallets() async throws -> [Wallet]
    func saveWallet(_ wallet: Wallet) async throws
    func deleteWallet(_ wallet: Wallet) async throws
}

@MainActor
final class CloudKitService: CloudKitServiceProtocol {
    static let shared = CloudKitService()

    private init() {}

    func fetchWallets() async throws -> [Wallet] {
        // CloudKit implementation
    }

    func saveWallet(_ wallet: Wallet) async throws {
        // CloudKit implementation
    }

    func deleteWallet(_ wallet: Wallet) async throws {
        // CloudKit implementation
    }
}
```

## Feature Organization

### Structure

Each feature module follows this structure:

```
Features/FeatureName/
├── Views/           # SwiftUI views
├── ViewModels/      # Observable ViewModels
└── Components/      # Feature-specific components
```

### When to Create a New Feature

Create a new feature module when:
- It represents a distinct user-facing capability
- It has its own navigation flow
- It can be developed and tested independently

### Shared Components

Components used across multiple features go in `Shared/UI/Components/`:
- Button styles
- Form fields
- Loading indicators
- Error views

## Dependency Injection

### AppEnvironment

**Location:** `App/AppEnvironment.swift`

Container for app-level dependencies:

```swift
@MainActor
final class AppEnvironment: ObservableObject {
    static let shared = AppEnvironment()

    let cloudKitService: CloudKitService
    let authService: AuthenticationService

    private init() {
        self.cloudKitService = CloudKitService.shared
        self.authService = AuthenticationService.shared
    }
}
```

Inject into app:

```swift
@main
struct InariApp: App {
    @StateObject private var environment = AppEnvironment.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(environment)
        }
    }
}
```

Access in views:

```swift
struct WalletListView: View {
    @EnvironmentObject private var environment: AppEnvironment
    @State private var viewModel: WalletListViewModel

    init() {
        // Initialize with injected dependencies if needed
        // For most cases, ViewModels use .shared singletons
        _viewModel = State(initialValue: WalletListViewModel())
    }
}
```

## Testing Approach

### ViewModel Testing

```swift
@MainActor
final class WalletListViewModelTests: XCTestCase {
    func testLoadWallets() async throws {
        // Given
        let mockService = MockCloudKitService()
        let viewModel = WalletListViewModel(cloudKitService: mockService)

        // When
        await viewModel.loadWallets()

        // Then
        XCTAssertFalse(viewModel.state.isLoading)
        XCTAssertEqual(viewModel.state.wallets.count, 2)
    }
}
```

### Service Testing

```swift
@MainActor
final class CloudKitServiceTests: XCTestCase {
    func testFetchWallets() async throws {
        // Test CloudKit operations
    }
}
```

## Anti-Patterns

### ❌ DON'T: Put business logic in Views

```swift
// BAD
struct WalletListView: View {
    var body: some View {
        List {
            // Direct CloudKit calls in view
            Button("Load") {
                Task {
                    let wallets = try await CKContainer.default()...
                }
            }
        }
    }
}
```

### ❌ DON'T: Use @StateObject for ViewModels

```swift
// BAD - @StateObject is for ObservableObject, not @Observable
struct WalletListView: View {
    @StateObject private var viewModel = WalletListViewModel()
}
```

### ❌ DON'T: Access ViewModel state directly without observation

```swift
// BAD - breaks observation
viewModel.state.wallets.append(newWallet)

// GOOD - replace entire state or use proper mutation
viewModel.addWallet(newWallet)
```

### ❌ DON'T: Make services with mutable state without `@Observable`

```swift
// BAD
class SomeService {
    var data: [Item] = []  // Untracked state
}

// GOOD - either use @Observable or make it immutable
@Observable
class SomeService {
    var data: [Item] = []
}
```

### ❌ DON'T: Mix SwiftData and CloudKit

```swift
// BAD - we're using CloudKit, not SwiftData
import SwiftData
@Model class Wallet { }
```

## Related

- See `conventions.md` for naming and code style
- See `cloudkit.md` (Task 03) for CloudKit patterns
- See `ui-patterns.md` (Task 04+) for SwiftUI patterns
