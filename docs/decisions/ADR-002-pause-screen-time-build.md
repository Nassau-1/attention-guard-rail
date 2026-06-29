# ADR-002: Pause Native Screen Time Build

Date: 2026-06-29

## Status

Accepted

## Context

Attention Guard Rail was intended as a personal open-source iPhone utility for making phone use more intentional. The goal was to avoid depending on a commercial focus app by building a small local-first alternative.

The correct Apple-native implementation for real app blocking depends on Screen Time capabilities:

- `FamilyControls` for user-approved app and category selection
- `ManagedSettings` for shielding selected apps
- `ManagedSettingsUI` for shield presentation
- `DeviceActivity` for schedules and usage windows
- App Groups for shared app and widget state

Physical-device testing showed that a free Apple Personal Team is not enough for this capability path. The remaining work requires Apple Developer provisioning that is not currently justified by the project's economics.

## Decision

Pause active development of the native Screen Time build.

Keep the repository public as a documented architecture and product scaffold. Do not pay for Apple Developer Program membership solely to build this app while the project remains a personal utility with no commercial plan.

## Rejected Options

Pay Apple Developer Program membership only for this project: rejected because the annual fee is higher than the avoided cost of the kind of commercial app this project was meant to replace.

Use private APIs or unsupported iOS workarounds: rejected because the project should stay public, maintainable, and aligned with Apple's supported platform model.

Build a backend or paid product to justify the cost: rejected because the project intent is personal, local-first, and open source.

## Consequences

The repo remains useful as a reference for the intended product direction and Apple-native architecture.

The real Screen Time flow is not expected to be testable until paid Apple Developer provisioning is available for another reason.

A future reduced demo mode could test the SwiftUI, widget, delay, session, and settings experience without real app shielding, but that would not replace the original native Screen Time goal.
