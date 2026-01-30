# Task 04: Wallet Management

## Overview

Implement the complete wallet management feature for single-user wallets, including creation, viewing, editing, archiving, and deletion.

## Dependencies

- Task 03: CloudKit Integration (completed)

## Objectives

1. **Wallet List View**
   - Display all active (non-archived) wallets
   - Show wallet name, currency, and type indicator
   - Support pull-to-refresh for manual sync
   - Option to show/hide archived wallets

2. **Wallet Creation**
   - Form to create a new wallet
   - Required fields: name, currency
   - Currency selection from ISO 4217 list (common currencies prioritized)
   - Wallet type selection (single-user only in this task; two-user in Task 11)
   - Validation before submission

3. **Wallet Detail View**
   - Display wallet information
   - Show summary of transactions/budgets (placeholder for now)
   - Navigation to edit wallet

4. **Wallet Editing**
   - Edit wallet name
   - Currency and type are immutable (display only)
   - Update burden ratio (for two-user wallets, placeholder for now)

5. **Wallet Archiving**
   - Archive wallet (soft hide from active list)
   - Unarchive wallet (restore to active list)
   - Archived wallets visible in separate section/filter

6. **Wallet Deletion**
   - Hard delete with confirmation dialog
   - Warning about permanent data loss
   - Delete all associated transactions, categories, and budgets

## Acceptance Criteria

- [ ] User can create a new single-user wallet
- [ ] User can view list of their wallets
- [ ] User can edit wallet name
- [ ] User can archive and unarchive wallets
- [ ] User can permanently delete a wallet with confirmation
- [ ] Wallet changes sync across devices
- [ ] Empty state shown when no wallets exist

## Knowledge Sharing Requirements

After completing this task, update the project documentation:

1. **Update `CLAUDE.md`** with:
   - How wallet management works
   - Navigation structure established by this feature

2. **Update `.claude/rules/`** with:
   - `ui-patterns.md` - Document established UI patterns (list views, forms, confirmation dialogs)
   - `feature-structure.md` - How feature modules are organized (if pattern is established)

## Notes for Planning Agent

- This establishes the primary navigation pattern for the app
- Consider using SwiftUI's NavigationStack or NavigationSplitView
- Wallet selection should persist across app launches
- Think about how selected wallet context will be passed to child features
- The deletion confirmation should be very clear about consequences
