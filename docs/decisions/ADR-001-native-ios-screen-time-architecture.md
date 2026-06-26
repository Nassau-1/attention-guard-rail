# ADR-001: Use Native iOS Screen Time Architecture

Date: 2026-06-26

## Status

Accepted

## Context

The app needs home-screen widgets, a textual launcher, schedules, app blocking, and stronger friction before opening distracting apps.

iOS does not expose private APIs for replacing SpringBoard or controlling arbitrary apps. Apple provides public Screen Time APIs for user-approved app selection, managed shields, and device activity monitoring.

## Decision

Use:

- SwiftUI for the app
- WidgetKit for the two home-screen widgets
- FamilyControls for app/category selection
- ManagedSettings for shielding
- ManagedSettingsUI for custom shield UI
- DeviceActivity for schedules and usage windows
- App Group storage for shared app/widget configuration

Use XcodeGen for project generation because the initial repo is created from Windows.

## Rejected Options

Direct SpringBoard replacement: rejected because iOS does not allow third-party launcher replacement.

Private app data integration with Bevel: rejected because iOS app sandboxing prevents direct access. Use HealthKit if Bevel writes the target metrics to Apple Health.

Backend-first architecture: rejected because the app should be free, personal, and local-first.

## Consequences

The project depends on Apple entitlements and real-device testing. Some behavior cannot be fully verified on Windows or in simulator-only workflows.

