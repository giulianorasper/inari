# Task 11: Two-User Wallets

## Overview

Implement shared wallet functionality allowing two users to collaborate on a budget, including iCloud sharing, burden ratio management, and shared expense handling.

## Dependencies

- Task 10: Daily Budget (completed)

## Objectives

1. **Two-User Wallet Creation**
   - Create wallet with "two-user" type selected
   - Set initial burden ratio (default 50/50)
   - Creator becomes wallet owner

2. **Invitation Flow**
   - Owner initiates sharing via CloudKit sharing (CKShare)
   - Generate share link or use system share sheet
   - Invitee accepts share and wallet appears in their app
   - Limit to exactly one invitee (two users total)

3. **Burden Ratio Management**
   - Wallet-level default burden ratio
   - Edit burden ratio from wallet settings
   - Display as percentage split (e.g., "60% / 40%")
   - Both users can view; only owner can edit (or allow both?)

4. **Shared vs Individual Expenses**
   - Transactions marked as "shared" or "individual"
   - Shared: split according to burden ratio
   - Individual: 100% attributed to the user who created it
   - Visual distinction in transaction list

5. **Per-Transaction Burden Override**
   - Option to override wallet default for specific transactions
   - Use cases: "I'll cover this one", "Split this differently"
   - Override shown clearly on transaction detail

6. **Shared Categories**
   - Categories can be "shared" or "individual"
   - Shared categories: budget split by burden ratio
   - Individual categories: each user has their own budget
   - Shared category expenses impact both users' daily budgets

7. **Daily Budget with Sharing**
   - Each user sees their own daily budget
   - Incorporates their share of shared expenses
   - Formula: `Individual Expenses + (Shared Expenses × User's Burden Ratio)`

8. **Wallet Deletion for Two-User Wallets**
   - Only owner can delete shared wallet
   - Both users see deletion warning
   - Deletion removes wallet for both users

9. **Data Visibility**
   - Both users see all transactions (shared and individual)
   - Transparency is the design principle
   - No "private" transactions within shared wallet

## Acceptance Criteria

- [ ] User can create a two-user wallet
- [ ] Owner can invite exactly one other user
- [ ] Invitee can accept and access the shared wallet
- [ ] Burden ratio can be configured at wallet level
- [ ] Transactions can be marked shared or individual
- [ ] Burden ratio can be overridden per transaction
- [ ] Categories can be shared or individual
- [ ] Each user's daily budget reflects their burden share
- [ ] Both users see real-time updates from the other
- [ ] Only owner can delete shared wallet

## Knowledge Sharing Requirements

After completing this task, update the project documentation:

1. **Update `CLAUDE.md`** with:
   - Two-user wallet system overview
   - Sharing mechanism and limitations
   - Burden ratio behavior

2. **Update `.claude/rules/`** with:
   - `sharing.md` - Document CloudKit sharing patterns, CKShare usage, shared database access

## Notes for Planning Agent

- CloudKit sharing uses CKShare records and the shared database zone
- UICloudSharingController provides standard iOS sharing UI
- Consider edge cases: what if invitee doesn't have iCloud? What if invitation expires?
- Conflict resolution: what if both users edit same transaction simultaneously?
- "No kickout" rule means no removing a user - only full deletion
- Test thoroughly with two actual iCloud accounts
- Consider what happens if one user's device is offline
