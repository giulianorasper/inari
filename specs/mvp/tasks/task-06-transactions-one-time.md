# Task 06: One-Time Transactions

## Overview

Implement the core transaction management feature for one-time (single occurrence) transactions. This establishes the transaction infrastructure that other transaction types will extend.

## Dependencies

- Task 05: Categories & Budgets (completed)

## Objectives

1. **Transaction List View**
   - Display transactions for the selected wallet
   - Group by date (today, yesterday, this week, this month, older)
   - Show: amount, category, description, date
   - Filter by category, date range
   - Search transactions by description

2. **Transaction Creation**
   - Quick-add transaction flow (minimal friction)
   - Required: amount, category, date
   - Optional: description/notes
   - Amount input with currency formatting
   - Date picker (defaults to today)
   - Category selector

3. **Transaction Detail/Edit**
   - View full transaction details
   - Edit any field
   - Delete transaction with confirmation

4. **Income vs Expense**
   - Support both income and expense transactions
   - Clear visual distinction (green for income, red for expense)
   - Positive amounts for income, negative for expense (or toggle)

5. **Budget Integration**
   - Transactions update category budget spent amount in real-time
   - Visual feedback when transaction would exceed budget

6. **Transaction for Two-User Wallets (Foundation)**
   - Individual vs shared expense toggle (preparation for Task 11)
   - Burden ratio override field (hidden for single-user wallets)

## Acceptance Criteria

- [ ] User can add a one-time transaction (income or expense)
- [ ] User can view list of transactions with grouping
- [ ] User can edit and delete transactions
- [ ] Transactions are categorized
- [ ] Category budget spent amounts update with transactions
- [ ] Transaction list supports filtering and search
- [ ] Changes sync across devices

## Knowledge Sharing Requirements

After completing this task, update the project documentation:

1. **Update `CLAUDE.md`** with:
   - Transaction system overview
   - How budget calculations work

2. **Update `.claude/rules/`** with:
   - `transactions.md` - Document transaction creation patterns, amount handling, date handling, category assignment

## Notes for Planning Agent

- Transaction creation should be fast and frictionless (primary user action)
- Consider supporting quick entry from wallet overview
- Amount entry should feel natural (handle decimal separator, currency symbols)
- This task creates the transaction infrastructure; recurring/spread-out/expectation extend it
- Consider accessibility for amount input (VoiceOver support)
- Use Decimal type for amounts to avoid floating-point precision issues
