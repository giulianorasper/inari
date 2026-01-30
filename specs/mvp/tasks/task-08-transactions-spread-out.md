# Task 08: Spread Out Transactions

## Overview

Implement spread out transactions that distribute a large expense over a time period, impacting daily budget proportionally.

## Dependencies

- Task 06: One-Time Transactions (completed)

## Objectives

1. **Spread Out Transaction Creation**
   - Extend transaction creation with spread out option
   - Total amount input
   - Spread period definition:
     - Number of days
     - Number of weeks
     - Number of months
     - Custom date range (start to end)
   - Start date selection
   - Automatic end date calculation (or vice versa)

2. **Daily Amount Calculation**
   - Calculate daily amount: total ÷ number of days
   - Handle decimal precision appropriately
   - Show daily amount preview during creation

3. **Spread Out Transaction Display**
   - Visual indicator for spread out transactions
   - Show: total amount, daily amount, spread period, progress
   - Progress indicator: how much of the spread period has elapsed
   - Remaining amount and days

4. **Transaction List Integration**
   - Option 1: Show as single entry with spread details
   - Option 2: Show daily portions in transaction list
   - Make behavior configurable or choose most intuitive approach

5. **Budget Impact**
   - Spread out transactions contribute daily amounts to budget
   - Example: $120 annual subscription spread over 365 days = $0.33/day budget impact
   - Budget view shows accumulated spread impact

6. **Editing & Deletion**
   - Edit total amount (recalculates daily)
   - Edit spread period (recalculates daily)
   - Delete removes entire spread transaction

## Acceptance Criteria

- [ ] User can create a spread out transaction
- [ ] Daily amount is calculated and displayed correctly
- [ ] Spread progress is visualized
- [ ] Daily budget is impacted proportionally
- [ ] User can edit and delete spread out transactions
- [ ] Spread out transactions integrate with transaction list

## Knowledge Sharing Requirements

After completing this task, update the project documentation:

1. **Update `CLAUDE.md`** with:
   - Spread out transaction concept and calculation
   - How it impacts daily budget

2. **Update `.claude/rules/`** with:
   - Update `transactions.md` with spread out transaction patterns

## Notes for Planning Agent

- Common use cases: annual subscriptions, insurance premiums, large one-time purchases
- Consider whether spread can be retroactive (started in the past)
- Think about how spread transactions appear in historical views
- Daily amount might be a very small number - handle display appropriately
- Consider rounding strategy to avoid accumulated rounding errors
