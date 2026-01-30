# Inari - Claude Project Context

> This file is updated during task implementation. It provides context for Claude when working on this project.

## Project Overview

Inari is a budgeting application for iOS/iPadOS/macOS with iCloud sync. Supports single-user and two-user shared wallets.

## Quick Start

### Building and Running

```bash
# Open project in Xcode
open inari.xcodeproj

# Build for iOS
xcodebuild -project inari.xcodeproj -scheme inari \
  -destination 'platform=iOS Simulator,name=iPhone 15' build

# Build for macOS
xcodebuild -project inari.xcodeproj -scheme inari \
  -destination 'platform=macOS' build

# Run tests
xcodebuild test -project inari.xcodeproj -scheme inari \
  -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Platform Support
- iOS 17.0+
- iPadOS 17.0+
- macOS 14.0+

## Project Structure

```
inari/
├── CLAUDE.md              # This file - project context for Claude
├── REQUIREMENTS.md        # Business requirements
├── .swiftlint.yml         # SwiftLint configuration
├── specs/
│   └── mvp/
│       ├── DEPENDENCY_GRAPH.md
│       └── tasks/         # Task specifications
├── .claude/
│   └── rules/             # Detailed implementation rules
└── inari/
    ├── App/
    │   ├── InariApp.swift       # App entry point
    │   └── AppEnvironment.swift # Dependency injection container
    ├── Core/
    │   ├── Models/              # Domain models (Task 02+)
    │   ├── Services/            # Services (CloudKit, etc.)
    │   │   └── ViewModelProtocol.swift
    │   └── Extensions/          # Swift extensions
    ├── Features/
    │   ├── Wallets/
    │   │   ├── Views/           # Wallet UI screens
    │   │   │   └── ContentView.swift
    │   │   ├── ViewModels/      # Wallet business logic
    │   │   └── Components/      # Wallet-specific components
    │   ├── Categories/
    │   │   ├── Views/
    │   │   ├── ViewModels/
    │   │   └── Components/
    │   ├── Transactions/
    │   │   ├── Views/
    │   │   ├── ViewModels/
    │   │   └── Components/
    │   ├── DailyBudget/
    │   │   ├── Views/
    │   │   └── ViewModels/
    │   └── Sharing/
    │       ├── Views/
    │       └── ViewModels/
    ├── Shared/
    │   ├── UI/
    │   │   ├── Components/      # Reusable UI components
    │   │   └── Styles/          # SwiftUI styles
    │   └── Utilities/           # Helper functions
    └── Resources/
        ├── Assets.xcassets
        └── inari.entitlements
```

## Architecture

### Pattern: MVVM with Observation

Inari uses **MVVM (Model-View-ViewModel)** with Swift's native `@Observable` macro:

- **Models**: Domain entities in `Core/Models/` (Task 02+)
- **Views**: SwiftUI views in `Features/*/Views/`
- **ViewModels**: Business logic in `Features/*/ViewModels/`
  - Use `@Observable` for state management
  - Marked with `@MainActor` for thread safety
  - Conform to `ViewModel` protocol

**Example:**
```swift
@MainActor
@Observable
final class WalletListViewModel: ViewModel {
    struct State {
        var wallets: [Wallet] = []
        var isLoading = false
    }

    var state = State()

    func loadWallets() async {
        // Business logic here
    }
}
```

### Services
- Services live in `Core/Services/`
- **CloudKitService** (Task 03): Handles all CloudKit operations
- Injected via `AppEnvironment`

### View-ViewModel Binding
```swift
struct WalletListView: View {
    @State private var viewModel = WalletListViewModel()

    var body: some View {
        List(viewModel.state.wallets) { wallet in
            // UI code
        }
        .task {
            await viewModel.loadWallets()
        }
    }
}
```

## Key Patterns

### Feature Organization
Each feature follows this structure:
- `Views/` - SwiftUI views (UI only, no business logic)
- `ViewModels/` - Observable view models (business logic)
- `Components/` - Feature-specific reusable components

### Naming Conventions
- Views: `WalletListView`, `CategoryPickerView`
- ViewModels: `WalletListViewModel`, `CategoryFormViewModel`
- Services: `CloudKitService`, `AuthenticationService`
- Models: `Wallet`, `Transaction`, `Category`

See `.claude/rules/conventions.md` for complete conventions.

## Data Models

> To be documented after Task 02: Data Models

## CloudKit

> To be documented after Task 03: CloudKit Integration

## Feature Modules

> To be documented as features are implemented

---

## Updating This File

When completing tasks, update relevant sections with:
- Actual commands and paths
- Architecture decisions made
- Patterns established
- Key implementation details

Keep information concise and actionable. This file should help any developer (or Claude) quickly understand and work on the project.
