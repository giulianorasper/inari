# MVP Task Specifications

This directory contains self-contained task specifications for building the Inari budgeting app MVP.

## How to Execute a Task

To start working on a task, tell Claude:

```
Start the execution of the task in task-[name].md
```

For example:
- "Start the execution of the task in task-01-project-setup.md"
- "Start the execution of the task in task-06-transactions-one-time.md"

## Task Execution Flow

1. **Planning Phase**: Claude reads the task spec and plans the implementation
2. **Implementation Phase**: Claude implements according to the plan
3. **Knowledge Sharing Phase**: Claude updates `CLAUDE.md` and `.claude/rules/` with learnings

## Task List

| # | Task | Dependencies | Description |
|---|------|--------------|-------------|
| 01 | project-setup | - | Project structure and architecture |
| 02 | data-models | 01 | Domain model definitions |
| 03 | cloudkit-integration | 02 | iCloud persistence layer |
| 04 | wallet-management | 03 | Wallet CRUD and navigation |
| 05 | categories-budgets | 04 | Category and budget system |
| 06 | transactions-one-time | 05 | Core transaction management |
| 07 | transactions-recurring | 06 | Recurring transaction logic |
| 08 | transactions-spread-out | 06 | Spread out transactions |
| 09 | transactions-expectation | 06 | Expectation and reconciliation |
| 10 | daily-budget | 07, 08, 09 | Budget calculation engine |
| 11 | two-user-wallets | 10 | iCloud sharing and burden ratio |
| 12 | local-auth | 04 | Face ID / Touch ID (parallelizable) |

## Parallel Execution Opportunities

- Tasks 07, 08, 09 can be done in parallel (after 06)
- Task 12 can be done in parallel with 05-11 (after 04)

## Dependencies Visualization

See `../DEPENDENCY_GRAPH.md` for the full dependency diagram.

## Important Notes

- Each task should update documentation as specified in "Knowledge Sharing Requirements"
- Tasks build on foundations laid by previous tasks
- Do not skip dependencies - each task assumes prior work is complete
- Tasks are high-level; the planning agent determines specific implementation
