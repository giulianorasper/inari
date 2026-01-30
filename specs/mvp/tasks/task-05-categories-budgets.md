# Task 05: Categories & Budgets

## Overview

Implement category management and budget allocation within a wallet context. Categories organize transactions; budgets set spending limits per category.

## Dependencies

- Task 04: Wallet Management (completed)

## Objectives

1. **Category List View**
   - Display all categories within the selected wallet
   - Show category name, icon, color, and budget status (if set)
   - Support reordering categories (drag and drop or manual sort)
   - Distinguish between individual and shared categories (visual indicator)

2. **Category Creation**
   - Form to create a new category
   - Required: name
   - Optional: SF Symbol icon selection, color picker
   - For two-user wallets: individual vs shared toggle (shared categories placeholder for Task 11)

3. **Category Editing**
   - Edit name, icon, color
   - Cannot change individual/shared designation after creation
   - Delete category (with warning if transactions exist)

4. **Budget Assignment**
   - Set monthly budget limit for a category
   - Budget is per category per month
   - Option to copy budget from previous month

5. **Budget Overview**
   - Visual representation of budget vs spent
   - Progress bar or similar indicator
   - Show: budgeted, spent, remaining
   - Color coding: green (under), yellow (approaching), red (over)

6. **Default Categories**
   - Provide sensible default categories on first wallet creation
   - User can delete/modify defaults
   - Examples: Groceries, Transportation, Entertainment, Utilities, etc.

## Acceptance Criteria

- [ ] User can create, edit, and delete categories
- [ ] User can assign SF Symbol icons and colors to categories
- [ ] User can set monthly budgets per category
- [ ] Budget progress is visually displayed
- [ ] Categories can be reordered
- [ ] Default categories are created for new wallets
- [ ] Changes sync across devices

## Knowledge Sharing Requirements

After completing this task, update the project documentation:

1. **Update `CLAUDE.md`** with:
   - Category and budget system overview
   - Default categories list

2. **Update `.claude/rules/`** with:
   - Update `ui-patterns.md` with icon picker, color picker, budget progress patterns

## Notes for Planning Agent

- SF Symbols provides a vast icon library - curate a subset relevant to budgeting
- Consider a limited color palette for consistency
- Budget calculations will become more complex with transactions (Task 06+)
- Think about how category budgets aggregate to overall spending
- Shared categories are only relevant for two-user wallets (full implementation in Task 11)
