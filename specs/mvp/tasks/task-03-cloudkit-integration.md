# Task 03: CloudKit Integration

## Overview

Set up CloudKit container, define the schema, and implement the data persistence layer that all features will use for CRUD operations and real-time sync.

## Dependencies

- Task 01: Project Setup (completed)
- Task 02: Data Models (completed)

## Objectives

1. **CloudKit Container Setup**
   - Create and configure CloudKit container in Apple Developer portal
   - Configure entitlements in Xcode project
   - Set up development and production environments

2. **Schema Definition**
   - Define record types matching the data models
   - Configure indexes for queryable fields
   - Set up relationships between record types

3. **Persistence Layer**
   - Create a generic repository/service pattern for CloudKit operations
   - Implement CRUD operations for all record types
   - Handle CKRecord to Model conversion (and vice versa)

4. **Sync & Caching**
   - Implement real-time sync using CKSubscription or CKDatabaseSubscription
   - Set up local caching strategy for offline access
   - Handle sync conflicts gracefully

5. **Error Handling**
   - Define CloudKit-specific error types
   - Implement retry logic for transient failures
   - Handle quota and rate limiting errors

## Acceptance Criteria

- [ ] CloudKit container is created and accessible
- [ ] All record types are defined in CloudKit schema
- [ ] Basic CRUD operations work for all models
- [ ] Changes sync in real-time across devices
- [ ] App handles being offline gracefully
- [ ] Error handling covers common CloudKit failure scenarios

## Knowledge Sharing Requirements

After completing this task, update the project documentation:

1. **Update `CLAUDE.md`** with:
   - CloudKit container identifier
   - How to access CloudKit Dashboard
   - Local development/testing instructions

2. **Update `.claude/rules/`** with:
   - `cloudkit.md` - Document the persistence layer API, how to add new record types, sync patterns, error handling conventions

## Notes for Planning Agent

- Use CKContainer.default() or a custom container based on app identifier
- Consider using NSPersistentCloudKitContainer if Core Data integration is desired
- Private database for user-owned data
- Shared database will be used later for two-user wallets (Task 11)
- Design the persistence layer to be mockable for testing
- Consider using Swift's async/await for CloudKit operations
