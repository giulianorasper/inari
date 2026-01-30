# Task 09: Expectation Transactions

## Overview

Implement expectation transactions for estimated expenses (like utility bills) that can be reconciled with actual amounts later.

## Dependencies

- Task 06: One-Time Transactions (completed)

## Objectives

1. **Expectation Transaction Creation**
   - Extend transaction creation with expectation option
   - Expected amount input
   - Expected date (when bill is due/expected)
   - Category assignment
   - Optional: base estimate on historical average

2. **Expectation Status States**
   - **Pending**: Expected transaction, not yet reconciled
   - **Reconciled**: Actual amount entered, expectation resolved
   - Clear visual distinction between states

3. **Reconciliation Flow**
   - User receives actual bill/statement
   - Enter actual amount
   - System calculates variance (actual - expected)
   - Mark as reconciled
   - Option to adjust future expectations based on variance

4. **Variance Tracking**
   - Display variance after reconciliation
   - Positive variance: spent more than expected
   - Negative variance: spent less than expected
   - Historical variance tracking per category (future consideration)

5. **Budget Integration**
   - Pending expectations count toward budget (as estimates)
   - Upon reconciliation, budget adjusts to actual amount
   - Clear indication of "pending" vs "confirmed" budget usage

6. **Expectation List View**
   - Show upcoming expected transactions
   - Filter: pending vs reconciled
   - Quick action to reconcile from list
   - Sort by expected date

## Acceptance Criteria

- [ ] User can create an expectation transaction
- [ ] Expectation shows as pending until reconciled
- [ ] User can reconcile with actual amount
- [ ] Variance is calculated and displayed
- [ ] Budget reflects pending expectations appropriately
- [ ] User can view and filter expectation transactions

## Knowledge Sharing Requirements

After completing this task, update the project documentation:

1. **Update `CLAUDE.md`** with:
   - Expectation transaction concept
   - Reconciliation workflow

2. **Update `.claude/rules/`** with:
   - Update `transactions.md` with expectation transaction patterns

## Notes for Planning Agent

- Common use cases: utility bills, insurance, any variable recurring expense
- Consider combining with recurring (recurring expectation)
- Reconciliation should be quick and easy (primary action for this type)
- Think about notification potential (remind to reconcile overdue expectations)
- Variance data could power "learn from history" feature in future
- Pending expectations should be visually distinct from confirmed transactions
