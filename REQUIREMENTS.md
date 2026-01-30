# Inari - Budgeting App Requirements

## Overview

Inari is a budgeting application designed for iOS/macOS with full iCloud integration. The app supports both individual and shared (two-user) wallets, with flexible transaction types and budget tracking.

---

## Data Management

### iCloud Integration
- All application data is stored and synced via iCloud
- Single-user wallets are managed within the owner's iCloud account
- Multi-user wallets are managed via the iCloud account of the user who creates/invites
- Real-time sync across all user devices

---

## Wallets

### General Properties
- Each wallet is bound to a single currency (set at creation, immutable)
- Wallets can be archived (hidden from active views, data retained for reference)
- Wallets can be deleted (hard delete, data permanently removed)
- Wallet type (single/two-user) is set at creation and cannot be changed

### Single-User Wallets
- Owned and managed by one user
- Full control over all transactions and budgets

### Two-User Wallets
- Shared between exactly two users
- Created by one user who invites the second user
- Invitation mechanism via iCloud sharing
- **No kickout functionality** - users cannot be removed from a shared wallet
- Deletion requires action from the wallet owner (inviter)

### Burden Ratio
- Defined at wallet level (global default)
- Determines how shared expenses are split between two users
- Can be overridden on individual transactions
- Example: 50/50, 60/40, 70/30, etc.

---

## Transaction Types

### One-Time Payment
- Single occurrence transaction
- Fixed amount
- Assigned to a specific date

### Recurring Transaction
- Repeating transaction on a defined schedule
- Frequency options: Daily, Weekly, Bi-weekly, Monthly, Yearly, Custom
- Start date required
- Optional end date
- Fixed amount per occurrence

### Spread Out Transaction
- Large expense distributed over a time period
- Total amount divided across specified duration
- Impacts daily budget proportionally
- Example: Annual subscription of $120 spread as $10/month or ~$0.33/day

### Expectation Transaction
- Estimated/predicted expense (e.g., utility bills)
- Marked as "expected" until actual amount is known
- Supports correction/reconciliation when actual bill arrives
- Tracks variance between expected and actual amounts
- Example: Water bill estimated at $50, actual bill is $47

---

## Categories & Budgets

### Category Properties
- Name and optional icon/color
- Bound to expense type:
  - **Individual categories**: Personal expenses for one user
  - **Shared categories**: Expenses shared between wallet users (two-user wallets only)

### Budget Allocation
- Monthly budget limits can be set per category
- Tracking of spent vs. remaining budget
- Visual indicators for budget health (under/near/over budget)

---

## Daily Budget

### Calculation
- Aggregated from both individual and shared expenses
- Shared expenses factored according to burden ratio
- Formula: `Daily Budget = (Individual Expenses) + (Shared Expenses × User's Burden Ratio)`

### Display
- Shows available daily spending amount
- Updates in real-time as transactions are added
- Accounts for:
  - Remaining monthly income after fixed expenses
  - Spread out transaction daily portions
  - Expected (pending) transactions

---

## Open Questions / Future Considerations

1. **Income Tracking**: How should income be handled? Single source or multiple income streams?
2. **Transfer Between Wallets**: Should users be able to transfer funds between their wallets?
3. **Historical Data**: How long should archived wallet data be retained?
4. **Notifications**: Budget alerts, bill reminders, shared wallet activity?
5. **Reporting**: What reports/analytics should be available?
6. **Two-User Wallet Conversion**: Define process for converting to single-user if partnership ends
7. **Currency Display**: For users with multiple wallets in different currencies, show converted totals?
8. **Offline Support**: Define behavior when iCloud sync is unavailable

---

## Non-Functional Requirements

### Platform Support
- iOS (iPhone)
- iPadOS (iPad)
- macOS (via Catalyst or native)
- watchOS (future consideration)

### Security & Privacy
- No third-party data access
- Local authentication (Face ID / Touch ID) for app access
