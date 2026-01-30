# Task 10: Daily Budget

## Overview

Implement the daily budget calculation and display, which aggregates all transaction types and provides users with their available daily spending amount.

## Dependencies

- Task 07: Recurring Transactions (completed)
- Task 08: Spread Out Transactions (completed)
- Task 09: Expectation Transactions (completed)

## Objectives

1. **Daily Budget Calculation Engine**
   - Calculate available daily budget based on:
     - Monthly income (total income transactions)
     - Fixed expenses (one-time and recurring)
     - Spread out transaction daily portions
     - Pending expectation transactions
     - Category budget allocations
   - Formula foundation: `(Monthly Income - Fixed Expenses - Committed Spending) ÷ Remaining Days`

2. **Burden Ratio Integration (Two-User Prep)**
   - For shared expenses: apply user's burden ratio
   - Formula: `User's Daily = Individual Expenses + (Shared Expenses × Burden Ratio)`
   - Single-user wallets: burden ratio is effectively 100%

3. **Daily Budget Display**
   - Prominent display of today's available budget
   - Clear, glanceable format
   - Color indication: healthy (green), tight (yellow), over (red)
   - Show how it's calculated (expandable breakdown)

4. **Budget Breakdown View**
   - Income this month
   - Fixed expenses
   - Variable spending to date
   - Remaining budget
   - Days remaining in month
   - Daily budget calculation

5. **Real-Time Updates**
   - Daily budget recalculates as transactions are added
   - Immediate visual feedback when new transaction impacts budget

6. **Historical Daily Budget**
   - Track daily budget over time
   - Show how daily budget changed throughout the month
   - Useful for understanding spending patterns

## Acceptance Criteria

- [ ] Daily budget is calculated correctly from all transaction types
- [ ] Daily budget updates in real-time with new transactions
- [ ] Breakdown shows how daily budget is derived
- [ ] Burden ratio is applied for shared expenses (preparation for Task 11)
- [ ] Visual indication of budget health
- [ ] Daily budget prominently displayed on main screen

## Knowledge Sharing Requirements

After completing this task, update the project documentation:

1. **Update `CLAUDE.md`** with:
   - Daily budget calculation algorithm
   - All factors that influence daily budget

2. **Update `.claude/rules/`** with:
   - `daily-budget.md` - Document calculation logic, edge cases, update triggers

## Notes for Planning Agent

- This is arguably the core feature of the app - make it prominent
- Consider widget potential (show daily budget on home screen)
- Think about edge cases: no income set, month just started, month almost over
- "Remaining days" calculation should consider user's pay cycle preference (future)
- Balance precision (accurate calculation) with clarity (understandable to user)
- Consider caching calculation results for performance (recalc on transaction changes)
