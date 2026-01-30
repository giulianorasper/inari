# Task 02: Data Models

## Overview

Define all core data models that represent the domain entities of the budgeting application. These models will be the foundation for CloudKit persistence and all business logic.

## Dependencies

- Task 01: Project Setup (completed)

## Objectives

1. **Wallet Model**
   - Unique identifier
   - Name
   - Currency (immutable after creation, use ISO 4217 codes)
   - Wallet type: single-user or two-user (immutable after creation)
   - Burden ratio (for two-user wallets, default 50/50)
   - Archived status
   - Owner reference
   - Creation date

2. **Transaction Model**
   - Unique identifier
   - Wallet reference
   - Amount
   - Transaction type enum: one-time, recurring, spread-out, expectation
   - Category reference
   - Date (or start date for recurring/spread-out)
   - Description/notes
   - Is shared expense (for two-user wallets)
   - Custom burden ratio override (optional)
   - Type-specific properties (handled via associated values or separate models)

3. **Recurring Transaction Properties**
   - Frequency: daily, weekly, bi-weekly, monthly, yearly, custom
   - End date (optional)
   - Custom frequency interval (for custom frequency)

4. **Spread Out Transaction Properties**
   - Total amount
   - Spread duration (days/weeks/months)
   - Start and end date

5. **Expectation Transaction Properties**
   - Expected amount
   - Actual amount (nil until reconciled)
   - Reconciled status
   - Variance (computed)

6. **Category Model**
   - Unique identifier
   - Wallet reference
   - Name
   - Icon identifier (SF Symbol name)
   - Color
   - Is shared category (for two-user wallets)
   - Sort order

7. **Budget Model**
   - Unique identifier
   - Category reference
   - Monthly limit amount
   - Month/Year (budget period)

## Acceptance Criteria

- [ ] All models are defined with proper Swift types
- [ ] Models conform to necessary protocols (Identifiable, Codable, etc.)
- [ ] Relationships between models are clearly defined
- [ ] Currency is represented using ISO 4217 standard
- [ ] Models are prepared for CloudKit compatibility (CKRecord convertible)
- [ ] Unit tests validate model creation and relationships

## Knowledge Sharing Requirements

After completing this task, update the project documentation:

1. **Update `CLAUDE.md`** with:
   - Data model overview and relationships
   - Location of model files

2. **Update `.claude/rules/`** with:
   - `data-models.md` - Document model conventions, how to add new models, CloudKit compatibility requirements

## Notes for Planning Agent

- Models should be designed to be easily convertible to/from CKRecord
- Consider using value types (structs) where appropriate
- Think about how models will be queried and indexed in CloudKit
- The burden ratio should support decimal values (e.g., 0.6 for 60%)
- Currency amounts should use Decimal to avoid floating-point precision issues
