# TODO

## MVP

- Generate the Xcode project on macOS with `xcodegen generate`.
- Configure real bundle identifiers and Apple Developer Team IDs.
- Enable App Group for the app and all extensions.
- Request / verify Screen Time entitlement availability for personal use.
- Compile the app and fix any API drift from the generated skeleton.
- Test `FamilyActivityPicker` on a physical iPhone.
- Test shielding selected apps with `ManagedSettingsStore`.
- Test schedule start / end behavior with `DeviceActivityCenter`.
- Test widget deep links into the app and curated app URL schemes.

## Product

- Add configurable launcher items.
- Add a 15-second visual unlock delay before opening a selected app.
- Add per-app session duration selection and automatic reshielding.
- Add intention prompts for high-friction apps.
- Add repeated-open friction that increases during the same day.
- Add a setup checklist for grayscale, badges, notifications, dock cleanup, and widget placement.
- Add HealthKit read integration for sleep / readiness / recovery metrics if available.
- Add weather integration after location and privacy UX are designed.

## Release Hygiene

- Add app icon and widget preview assets.
- Add privacy manifest if Xcode requires it for the selected APIs.
- Add screenshots and manual QA checklist.
