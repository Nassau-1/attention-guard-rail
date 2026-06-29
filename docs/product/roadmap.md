# Product Roadmap

This project is a personal, local-first iPhone app for making the phone feel minimal, intentional, and boring.

## Current Direction

Paused as of 2026-06-29.

The intended native implementation depends on Apple's Screen Time capability path. That path is the correct technical architecture for real app selection, shielding, and usage windows, but it requires Apple Developer provisioning that is not economically justified for this personal open-source utility on its own.

## Product Principles

- Keep the first screen useful, not stimulating.
- Prefer text over icons where possible.
- Add friction before distracting apps, not friction everywhere.
- Keep app usage controls local to the device.
- Use native iOS permissions and Screen Time APIs only.
- Avoid cloud accounts, subscriptions, social features, or analytics.

## MVP

The MVP below describes the original target, not active work.

- Top widget with time and day.
- Text launcher widget for selected apps.
- App setup screen for widget instructions and launcher defaults.
- Intentional opening flow with visual delay.
- Session length choice before opening distracting apps.
- Screen Time permission request.
- Schedule model for recurring blocked windows.

## V1 Priorities

These priorities are deferred until paid Apple Developer provisioning is justified by another need, or until the app is rescoped away from real Screen Time controls.

- Persist launcher configuration in App Group storage.
- Add editable launcher rows with title, SF Symbol, URL scheme, fallback URL, and friction level.
- Add native app/category selection with `FamilyActivityPicker`.
- Store blocked app selections per focus rule.
- Apply shields with `ManagedSettingsStore`.
- Add temporary unshield windows after a completed delay.
- Reapply shielding after the selected session duration.
- Add an increasing-delay option for repeated opens.
- Add an intention prompt before high-friction apps.
- Add short usage-window modes, such as five minutes now then reshield.

## Later Ideas

- Reduced local demo mode without app shielding, for testing the launcher, delay, session, and settings UX under free provisioning.
- Optional HealthKit card for sleep, recovery, or readiness values available in Apple Health.
- Optional weather card after explicit location/weather permission design.
- Optional iOS Focus Mode and Shortcuts integration.
- Optional strict mode that prevents editing rules during active focus windows.
- Optional setup checklist for grayscale, hidden badges, reduced notifications, and widget placement.

## Public Boundary

The public repo should contain code, neutral product docs, and implementation notes only. Competitive research, app screenshots, store notes, and source-specific feature analysis belong in local ignored files under `private/`.
