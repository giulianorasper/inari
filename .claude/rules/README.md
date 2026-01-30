# Claude Rules Directory

This directory contains detailed implementation rules and patterns for the Inari project. These files are automatically read by Claude when working on the project.

## Purpose

- Document implementation patterns and conventions
- Capture decisions and their rationale
- Provide detailed guidance that doesn't fit in CLAUDE.md
- Enable consistent implementation across sessions

## Files

Files are added during task implementation:

| File | Created By | Purpose |
|------|------------|---------|
| `architecture.md` | Task 01 | Architecture pattern and structure |
| `conventions.md` | Task 01 | Naming and code style conventions |
| `data-models.md` | Task 02 | Model definitions and relationships |
| `cloudkit.md` | Task 03 | CloudKit persistence patterns |
| `ui-patterns.md` | Task 04+ | UI component patterns |
| `feature-structure.md` | Task 04+ | How features are organized |
| `transactions.md` | Task 06+ | Transaction handling patterns |
| `daily-budget.md` | Task 10 | Budget calculation logic |
| `sharing.md` | Task 11 | CloudKit sharing patterns |
| `security.md` | Task 12 | Authentication patterns |

## Guidelines for Updating

When adding or updating rules:

1. **Be specific** - Include actual code patterns, not vague guidelines
2. **Show examples** - Code snippets are more valuable than descriptions
3. **Document why** - Explain rationale for non-obvious decisions
4. **Keep current** - Update rules when patterns change
5. **Stay concise** - Rules should be scannable, not novels

## Format Template

```markdown
# [Topic]

## Overview
Brief description of what this covers.

## Patterns

### [Pattern Name]
Description and when to use.

```swift
// Example code
```

## Anti-patterns
What NOT to do and why.

## Related
Links to related rules or documentation.
```
