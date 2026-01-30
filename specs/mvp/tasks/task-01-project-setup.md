# Task 01: Project Setup

## Overview

Initialize the Xcode project with proper architecture patterns, folder structure, and development conventions that will be used throughout the application.

## Dependencies

- None (this is the first task)

## Objectives

1. **Project Structure**
   - Set up SwiftUI-based Xcode project targeting iOS, iPadOS, and macOS
   - Define folder structure that supports clean separation of concerns
   - Configure build settings for all target platforms

2. **Architecture Pattern**
   - Establish the architectural pattern to be used (e.g., MVVM, TCA, or similar)
   - Create base protocols/classes that features will conform to
   - Document the chosen pattern and reasoning

3. **Development Conventions**
   - Define naming conventions for files, types, and variables
   - Set up SwiftLint or similar for code style enforcement
   - Configure code formatting rules

4. **Dependency Management**
   - Set up Swift Package Manager for any required dependencies
   - Evaluate and document any third-party dependencies (minimize these)

## Acceptance Criteria

- [ ] Xcode project compiles and runs on iOS simulator
- [ ] Folder structure is created and documented
- [ ] Architecture pattern is chosen and base components are in place
- [ ] Basic "Hello World" screen appears on launch
- [ ] Project runs on iOS, iPadOS, and macOS targets

## Knowledge Sharing Requirements

After completing this task, update the project documentation:

1. **Update `CLAUDE.md`** (create if doesn't exist) with:
   - Project structure overview
   - Build and run commands
   - Architecture pattern explanation
   - Naming conventions

2. **Update `.claude/rules/` directory** (create if doesn't exist) with:
   - `architecture.md` - Document the chosen architecture pattern and how to add new features
   - `conventions.md` - Code style and naming conventions

## Notes for Planning Agent

- Prefer native Apple frameworks over third-party dependencies
- The app will use CloudKit for data persistence (set up in Task 03)
- Consider testability when choosing architecture pattern
- Keep the initial setup minimal - don't over-engineer
