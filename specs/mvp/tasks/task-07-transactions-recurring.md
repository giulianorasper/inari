# Task 07: Recurring Transactions

## Overview

Extend the transaction system to support recurring transactions that repeat on a defined schedule.

## Dependencies

- Task 06: One-Time Transactions (completed)

## Objectives

1. **Recurring Transaction Creation**
   - Extend transaction creation with recurring option
   - Frequency selection:
     - Daily
     - Weekly (select day of week)
     - Bi-weekly (select day of week)
     - Monthly (select day of month)
     - Yearly (select date)
     - Custom (every N days/weeks/months)
   - Start date (required)
   - End date (optional - runs indefinitely if not set)
   - Amount per occurrence

2. **Recurring Transaction Display**
   - Visual indicator for recurring transactions in list
   - Show next occurrence date
   - Show frequency description (e.g., "Every month on the 15th")

3. **Recurring Transaction Management**
   - Edit recurring transaction template
   - Option to edit: this occurrence only, this and future, all occurrences
   - Stop/pause recurring transaction
   - Delete recurring transaction (all occurrences or future only)

4. **Occurrence Generation**
   - Generate individual transaction records from recurring template
   - Occurrences should be pre-generated for upcoming period (e.g., next 3 months)
   - Background refresh to generate new occurrences as time passes

5. **Budget Impact**
   - Recurring transactions contribute to monthly budget calculations
   - Show projected spend including known recurring transactions

## Acceptance Criteria

- [ ] User can create a recurring transaction with various frequencies
- [ ] Recurring transactions display with clear visual indicator
- [ ] User can edit single occurrence or series
- [ ] User can stop or delete recurring transactions
- [ ] Occurrences are generated automatically
- [ ] Recurring transactions appear in transaction list at appropriate dates
- [ ] Budget projections include recurring transactions

## Knowledge Sharing Requirements

After completing this task, update the project documentation:

1. **Update `CLAUDE.md`** with:
   - Recurring transaction system overview
   - Occurrence generation strategy

2. **Update `.claude/rules/`** with:
   - Update `transactions.md` with recurring transaction patterns

## Notes for Planning Agent

- Consider how recurring transactions are stored (template + occurrences)
- Think about timezone handling for daily/weekly recurrences
- "This occurrence only" edits should create an exception record
- Consider calendar integration (not required for MVP, but design shouldn't prevent it)
- Bi-weekly is common for paychecks - ensure this works correctly
- Handle edge cases: 31st of month when month has 30 days, Feb 29th, etc.
