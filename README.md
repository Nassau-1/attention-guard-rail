# Attention Guard Rail

Personal iPhone app for making the phone more minimal, more intentional, and deliberately less stimulating.

## Current Status

2026-06-26: initial repo scaffold. The repository contains the native iOS architecture, SwiftUI screens, WidgetKit widgets, Screen Time extension skeletons, and a public product roadmap. It still needs to be opened on macOS with Xcode, generated with XcodeGen, signed, and tested on a real iPhone.

## Purpose

Attention Guard Rail is intended to make an iPhone feel closer to a minimal dumb phone by replacing the primary home screen with two widgets:

- a top information widget with time, day, and future weather / health slots
- a text launcher widget with minimal app links such as LinkedIn, Instagram, YouTube, and Mail

The companion app manages focus rules, app selection, schedules, and intentional-access friction before selected apps can be opened.

## Architecture

- `AttentionGuardRail`: SwiftUI app shell for setup, launcher configuration, focus rules, and override timers.
- `AttentionGuardRailWidgets`: WidgetKit extension containing the time/date widget and text launcher widget.
- `FocusShieldConfigurationExtension`: custom Screen Time shield copy and appearance.
- `FocusShieldActionExtension`: handles shield button actions and routes the user back into Attention Guard Rail.
- `FocusDeviceActivityMonitorExtension`: schedule / threshold hook for app usage monitoring.
- Shared persistence is planned through an App Group user defaults container.

See [docs/architecture.md](docs/architecture.md).

## Repo Structure

```text
Sources/
  AttentionGuardRailApp/
  AttentionGuardRailWidgets/
  FocusShieldActionExtension/
  FocusShieldConfigurationExtension/
  FocusDeviceActivityMonitorExtension/
docs/
  architecture.md
  decisions/
project.yml
```

## How To Run Locally

On macOS with Xcode installed:

```bash
brew install xcodegen
xcodegen generate
open AttentionGuardRail.xcodeproj
```

Then in Xcode:

1. Set a real Apple Developer Team for every target.
2. Replace bundle identifiers if needed.
3. Add the App Group capability to the app and extensions.
4. Add Screen Time / Family Controls entitlements where Apple allows them.
5. Run on a physical iPhone. Screen Time APIs are not meaningfully testable on this Windows machine.

## Environment Variables

None.

## Platform Boundaries

iOS does not allow a third-party app to arbitrarily replace SpringBoard, enumerate all installed apps, or block any app without Screen Time APIs and entitlements. This repo therefore uses the native Apple path:

- `FamilyControls` for user-approved app selection
- `ManagedSettings` for shielding selected apps
- `DeviceActivity` for schedules and usage thresholds
- Widget URL links for the launcher flow

Bevel integration is not included in the MVP. The likely route is HealthKit if Bevel writes the desired metrics to Apple Health.

## Intentionally Excluded

- paid SaaS backend
- analytics SDKs
- cloud account system
- private health data export
- app-store-ready signing material
- competitive research or source-specific product notes

## Public / Private Boundary

This public repo contains only neutral implementation material. Private research and source-specific product notes stay in local ignored files under `private/`.
