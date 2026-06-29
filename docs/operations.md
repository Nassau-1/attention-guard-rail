# Operations

## Local Development

Active device development is paused as of 2026-06-29. The native Screen Time capability path needs Apple Developer provisioning that is not currently justified for this personal open-source utility.

Supported development machine:

- macOS with Xcode for compilation and device testing
- Windows for repo editing, documentation, and source preparation only

Generate the Xcode project:

```bash
brew install xcodegen
xcodegen generate
open AttentionGuardRail.xcodeproj
```

## Signing

This section documents what would be required if the project resumes.

Each target needs a real bundle identifier and Apple Developer Team:

- `AttentionGuardRail`
- `AttentionGuardRailWidgets`
- `FocusShieldActionExtension`
- `FocusShieldConfigurationExtension`
- `FocusDeviceActivityMonitorExtension`

The App Group should be consistent across app and extensions:

```text
group.com.enzoterrier.attentionguardrail
```

Family Controls / Screen Time entitlements require provisioning support beyond a free Apple Personal Team.

## Manual QA

Deferred until the signing and entitlement path is justified.

Run on a physical iPhone:

1. Launch the app.
2. Request Screen Time permission.
3. Add both widgets to a home screen.
4. Tap launcher widget rows and confirm app deep links arrive in Attention Guard Rail.
5. Confirm the 15-second delay completes before opening a target app.
6. Select apps through `FamilyActivityPicker` after it is implemented.
7. Confirm shields apply and clear on schedule boundaries.

## Release Boundary

Do not publish until:

- entitlement behavior is verified on a real device
- App Store privacy labels are drafted
- HealthKit and WeatherKit usage strings are only added if those features are active
- screenshots do not expose private health, usage, or notification data
