# Product Roadmap

This project is a personal, local-first iPhone app for making the phone feel minimal, intentional, and boring.

## Product Principles

- Keep the first screen useful, not stimulating.
- Prefer text over icons where possible.
- Add friction before distracting apps, not friction everywhere.
- Keep app usage controls local to the device.
- Use native iOS permissions and Screen Time APIs only.
- Avoid cloud accounts, subscriptions, social features, or analytics.

## MVP

- Top widget with time and day.
- Text launcher widget for selected apps.
- App setup screen for widget instructions and launcher defaults.
- Intentional opening flow with visual delay.
- Session length choice before opening distracting apps.
- Screen Time permission request.
- Schedule model for recurring blocked windows.

## V1 Priorities

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

- Optional HealthKit card for sleep, recovery, or readiness values available in Apple Health.
- Optional weather card after explicit location/weather permission design.
- Optional iOS Focus Mode and Shortcuts integration.
- Optional strict mode that prevents editing rules during active focus windows.
- Optional setup checklist for grayscale, hidden badges, reduced notifications, and widget placement.

## Public Boundary

The public repo should contain code, neutral product docs, and implementation notes only. Competitive research, app screenshots, store notes, and source-specific feature analysis belong in local ignored files under `private/`.

