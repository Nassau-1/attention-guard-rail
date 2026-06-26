# Operations

## Local Development

Supported development machine:

- macOS with Xcode for compilation and device testing
- Windows for repo editing, documentation, and source preparation only

Generate the Xcode project:

```bash
brew install xcodegen
xcodegen generate
open FocusHome.xcodeproj
```

## Signing

Each target needs a real bundle identifier and Apple Developer Team:

- `FocusHome`
- `FocusHomeWidgets`
- `FocusShieldActionExtension`
- `FocusShieldConfigurationExtension`
- `FocusDeviceActivityMonitorExtension`

The App Group should be consistent across app and extensions:

```text
group.com.enzoterrier.focushome
```

Family Controls / Screen Time entitlements may require Apple approval before distribution.

## Manual QA

Run on a physical iPhone:

1. Launch the app.
2. Request Screen Time permission.
3. Add both widgets to a home screen.
4. Tap launcher widget rows and confirm app deep links arrive in Focus Home.
5. Confirm the 15-second delay completes before opening a target app.
6. Select apps through `FamilyActivityPicker` after it is implemented.
7. Confirm shields apply and clear on schedule boundaries.

## Release Boundary

Do not publish until:

- entitlement behavior is verified on a real device
- App Store privacy labels are drafted
- HealthKit and WeatherKit usage strings are only added if those features are active
- screenshots do not expose private health, usage, or notification data

