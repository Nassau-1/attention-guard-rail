# Architecture

## Summary

Focus Home is a native iOS app built around widgets and Screen Time APIs. The app owns configuration and intentional-access UX. WidgetKit owns home-screen surfaces. Screen Time frameworks own app selection, shielding, and scheduled blocking.

## Components

### App Target: `FocusHome`

Responsibilities:

- show the current launcher setup
- manage curated launcher items
- request Screen Time authorization
- show focus schedules
- route widget deep links through `focushome://`
- show the intentional delay flow before opening distracting apps

The app uses SwiftUI with `@Observable` state on iOS 17+.

### Widget Extension: `FocusHomeWidgets`

Widgets:

- `FocusTimeWidget`: large or medium top widget for time and day
- `FocusLauncherWidget`: text-only app launcher routed through the app

The launcher widget uses links back into the app. iOS widgets should not be treated as a direct arbitrary app launcher; the app receives the deep link and opens the target through known URL schemes or fallback URLs.

### Screen Time Extensions

`FocusShieldConfigurationExtension` customizes the blocked-app screen.

`FocusShieldActionExtension` handles shield button actions. The intended production flow is:

1. user taps a blocked app
2. Screen Time shield appears
3. primary action sends the user to Focus Home
4. Focus Home runs the delay/session flow
5. app temporarily unblocks the selected app
6. after the chosen session window, shielding returns

`FocusDeviceActivityMonitorExtension` receives Device Activity schedule/threshold callbacks and should apply or clear shields.

## Apple APIs

- `WidgetKit`: home-screen widgets and widget links
- `FamilyControls`: user-approved app and category selection
- `ManagedSettings`: shields selected apps and categories
- `ManagedSettingsUI`: custom shield UI
- `DeviceActivity`: schedules and usage monitoring
- `HealthKit`: optional future source for readiness/sleep/recovery data if Bevel writes those metrics to Apple Health
- `WeatherKit` or another weather source: optional future weather widget integration

## Data Model

Current scaffold:

- `LauncherItem`: curated textual launcher entry
- `FocusRule`: recurring schedule
- `ScreenTimeService`: authorization, shielding, and schedule integration point

Planned persistence:

- App Group user defaults for widget-safe lightweight configuration
- Codable selection/rule storage
- no remote backend

## iOS Constraints

iOS does not allow:

- a third-party app to replace the system launcher
- arbitrary enumeration of all installed apps
- arbitrary app blocking outside Screen Time APIs
- direct reads from another app's private data container

Therefore this app should be implemented as:

- a home-screen widget setup, not a SpringBoard replacement
- a curated launcher, not a full installed-app index
- a Screen Time app, not a private API workaround
- a HealthKit consumer for health metrics, not a direct Bevel scraper

## Build Flow

This repo uses XcodeGen because it was created on Windows, where Xcode is unavailable. On macOS:

```bash
xcodegen generate
open FocusHome.xcodeproj
```

The first build pass should focus on entitlement/signing correctness before adding more product features.

