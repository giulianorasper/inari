# Task 12: Local Authentication

## Overview

Implement local device authentication using Face ID, Touch ID, or device passcode to protect access to the budgeting app.

## Dependencies

- Task 04: Wallet Management (completed)
- Note: This task can be executed in parallel with Tasks 05-11

## Objectives

1. **Authentication Gate**
   - Require authentication on app launch
   - Block access to app content until authenticated
   - Show blurred/hidden content behind auth prompt

2. **Biometric Support**
   - Face ID on supported devices
   - Touch ID on supported devices
   - Automatic detection of available biometric type

3. **Passcode Fallback**
   - If biometrics fail or unavailable, fall back to device passcode
   - Handle devices without biometrics (passcode only)

4. **Settings Integration**
   - Toggle to enable/disable authentication requirement
   - Setting stored locally (not in iCloud - device-specific)
   - Default: enabled for new installs

5. **Authentication Timing**
   - Require auth on fresh app launch
   - Require auth when returning from background (configurable timeout)
   - Timeout options: immediately, after 1 minute, after 5 minutes

6. **Error Handling**
   - Handle biometric unavailable (enrolled, but hardware issue)
   - Handle biometric not enrolled (guide user to settings)
   - Handle repeated failures gracefully
   - Handle user cancellation

7. **Privacy Screen**
   - Show privacy screen when app enters background (app switcher)
   - Prevents content visibility in app switcher
   - Remove privacy screen after successful authentication

## Acceptance Criteria

- [ ] App requires authentication on launch (when enabled)
- [ ] Face ID works on supported devices
- [ ] Touch ID works on supported devices
- [ ] Device passcode works as fallback
- [ ] User can enable/disable auth requirement in settings
- [ ] Auth timeout is configurable
- [ ] Privacy screen appears in app switcher
- [ ] Error cases are handled gracefully

## Knowledge Sharing Requirements

After completing this task, update the project documentation:

1. **Update `CLAUDE.md`** with:
   - Local authentication behavior
   - How to test on simulator (limited biometric simulation)

2. **Update `.claude/rules/`** with:
   - `security.md` - Document LocalAuthentication framework usage, best practices for auth flows

## Notes for Planning Agent

- Use LocalAuthentication framework (LAContext)
- Use `canEvaluatePolicy` to check biometric availability
- Handle all LAError cases appropriately
- Test on physical device for true biometric testing
- Simulator has limited biometric support (can simulate success/failure)
- Consider accessibility: ensure VoiceOver announces auth prompts appropriately
- Store auth preference in UserDefaults (device-local, not iCloud)
- Privacy screen can be a simple view with app icon/name or blur effect
