# MVP Task Dependency Graph

## Overview

This document describes the execution order and dependencies between MVP tasks.

## Dependency Diagram

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         FOUNDATION LAYER                                 │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                          │
│  ┌──────────────────┐                                                   │
│  │  01-project-     │                                                   │
│  │  setup           │                                                   │
│  └────────┬─────────┘                                                   │
│           │                                                              │
│           ▼                                                              │
│  ┌──────────────────┐                                                   │
│  │  02-data-models  │                                                   │
│  └────────┬─────────┘                                                   │
│           │                                                              │
│           ▼                                                              │
│  ┌──────────────────┐                                                   │
│  │  03-cloudkit-    │                                                   │
│  │  integration     │                                                   │
│  └────────┬─────────┘                                                   │
│           │                                                              │
└───────────┼──────────────────────────────────────────────────────────────┘
            │
┌───────────┼──────────────────────────────────────────────────────────────┐
│           │              CORE FEATURES                                   │
├───────────┼──────────────────────────────────────────────────────────────┤
│           ▼                                                              │
│  ┌──────────────────┐                                                   │
│  │  04-wallet-      │                                                   │
│  │  management      │                                                   │
│  └────────┬─────────┘                                                   │
│           │                                                              │
│           ▼                                                              │
│  ┌──────────────────┐                                                   │
│  │  05-categories-  │                                                   │
│  │  budgets         │                                                   │
│  └────────┬─────────┘                                                   │
│           │                                                              │
│           ▼                                                              │
│  ┌──────────────────┐                                                   │
│  │  06-transactions-│                                                   │
│  │  one-time        │                                                   │
│  └────────┬─────────┘                                                   │
│           │                                                              │
└───────────┼──────────────────────────────────────────────────────────────┘
            │
┌───────────┼──────────────────────────────────────────────────────────────┐
│           │           ADVANCED TRANSACTIONS                              │
├───────────┼──────────────────────────────────────────────────────────────┤
│           │                                                              │
│           ├────────────────┬────────────────┐                           │
│           ▼                ▼                ▼                           │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────┐                    │
│  │ 07-recurring │ │ 08-spread-   │ │ 09-expecta-  │                    │
│  │              │ │ out          │ │ tion         │                    │
│  └──────┬───────┘ └──────┬───────┘ └──────┬───────┘                    │
│         │                │                │                             │
│         └────────────────┼────────────────┘                             │
│                          │                                              │
└──────────────────────────┼──────────────────────────────────────────────┘
                           │
┌──────────────────────────┼──────────────────────────────────────────────┐
│                          │    AGGREGATION & SHARING                      │
├──────────────────────────┼──────────────────────────────────────────────┤
│                          ▼                                              │
│                 ┌──────────────────┐                                    │
│                 │  10-daily-budget │                                    │
│                 └────────┬─────────┘                                    │
│                          │                                              │
│                          ▼                                              │
│                 ┌──────────────────┐                                    │
│                 │  11-two-user-    │                                    │
│                 │  wallets         │                                    │
│                 └────────┬─────────┘                                    │
│                          │                                              │
└──────────────────────────┼──────────────────────────────────────────────┘
                           │
┌──────────────────────────┼──────────────────────────────────────────────┐
│                          │          SECURITY                             │
├──────────────────────────┼──────────────────────────────────────────────┤
│                          ▼                                              │
│                 ┌──────────────────┐                                    │
│                 │  12-local-auth   │                                    │
│                 └──────────────────┘                                    │
│                                                                          │
└──────────────────────────────────────────────────────────────────────────┘
```

## Task Execution Order

### Sequential Dependencies

| Task | Depends On | Can Run After |
|------|------------|---------------|
| 01-project-setup | - | Immediately |
| 02-data-models | 01 | 01 complete |
| 03-cloudkit-integration | 02 | 02 complete |
| 04-wallet-management | 03 | 03 complete |
| 05-categories-budgets | 04 | 04 complete |
| 06-transactions-one-time | 05 | 05 complete |
| 07-recurring | 06 | 06 complete |
| 08-spread-out | 06 | 06 complete |
| 09-expectation | 06 | 06 complete |
| 10-daily-budget | 07, 08, 09 | All transaction types complete |
| 11-two-user-wallets | 10 | 10 complete |
| 12-local-auth | 04 | 04 complete (can be parallelized) |

### Parallel Opportunities

- Tasks 07, 08, 09 can be executed in parallel after 06
- Task 12 can be executed in parallel with tasks 05-11 (after 04)

## Task Files

All task specifications are in `specs/mvp/tasks/`:

- `task-01-project-setup.md`
- `task-02-data-models.md`
- `task-03-cloudkit-integration.md`
- `task-04-wallet-management.md`
- `task-05-categories-budgets.md`
- `task-06-transactions-one-time.md`
- `task-07-transactions-recurring.md`
- `task-08-transactions-spread-out.md`
- `task-09-transactions-expectation.md`
- `task-10-daily-budget.md`
- `task-11-two-user-wallets.md`
- `task-12-local-auth.md`
