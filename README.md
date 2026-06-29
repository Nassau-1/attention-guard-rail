# Attention Guard Rail

Attention Guard Rail is a paused open-source iPhone concept for making a phone feel quieter, more intentional, and less stimulating.

The project explored a native iOS approach to a "minimal phone" workflow:

- a calm top widget for time, day, and future context cards
- a text-first launcher widget for a small set of intentional app links
- a companion app for focus rules, app selection, schedules, and deliberate delay before opening distracting apps
- Screen Time integration for real app shielding, if Apple provisioning allows it

## Status

Paused as of 2026-06-29.

The architecture is intentionally Apple-native and technically plausible, but the key Screen Time capabilities require Apple Developer provisioning beyond a free Personal Team. Paying for Apple Developer Program membership only to replace a relatively low-cost personal focus app does not make economic sense for this project right now.

The repository is kept public as a clean product and architecture scaffold. It may be resumed if Apple Developer provisioning becomes justified by another project, or if the scope changes to a reduced mode without real app shielding.

## What This Repo Contains

- SwiftUI app shell for setup, launcher configuration, focus rules, and intentional-delay flows
- WidgetKit extension skeletons for the time/date widget and text launcher widget
- Screen Time extension skeletons for shield UI, shield actions, and device activity monitoring
- Public product roadmap, architecture notes, and decision records
- A documented public/private boundary so research notes and private inspiration do not enter the public repo

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

This repo is currently a documented scaffold. The full Screen Time flow is not expected to run end-to-end on a physical iPhone without paid Apple Developer provisioning for the required capability path.

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
5. Run on a physical iPhone.

## Environment Variables

None.

## Platform Boundaries

iOS does not allow a third-party app to arbitrarily replace SpringBoard, enumerate all installed apps, or block any app without Screen Time APIs and entitlements. This repo therefore uses the native Apple path:

- `FamilyControls` for user-approved app selection
- `ManagedSettings` for shielding selected apps
- `DeviceActivity` for schedules and usage thresholds
- Widget URL links for the launcher flow

This project was intended as a personal open-source alternative, not a paid product. The annual Apple Developer Program cost is not justified by this single use case, so development is paused until there is another reason to maintain an Apple Developer account or until the project changes scope.

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
