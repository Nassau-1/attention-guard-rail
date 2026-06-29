# Project Backlog

## Status

Paused as of 2026-06-29.

The remaining MVP work requires physical-device provisioning for Apple's Screen Time capability path. A paid Apple Developer Program membership is not economically justified for a personal open-source utility whose goal was to replace a relatively low-cost commercial app.

## Resume Criteria

- Resume only if Apple Developer provisioning becomes available for another reason, or if the app is rescoped to avoid Screen Time entitlements.
- If resumed with a paid Apple Developer account, configure real bundle identifiers, App Group, Family Controls, Managed Settings, Device Activity, and physical-device profiles.
- If resumed without paid provisioning, create a reduced "demo mode" that keeps the UI, launcher, delay, and session logic but removes real app shielding.

## Deferred Product Work

- Add configurable launcher items.
- Add a 15-second visual unlock delay before opening a selected app.
- Add per-app session duration selection and automatic reshielding.
- Add intention prompts for high-friction apps.
- Add repeated-open friction that increases during the same day.
- Add a setup checklist for grayscale, badges, notifications, dock cleanup, and widget placement.
- Add HealthKit read integration for sleep / readiness / recovery metrics if available.
- Add weather integration after location and privacy UX are designed.

## Release Hygiene

- Keep public docs neutral and clear that the project is paused for economic/provisioning reasons.
- Do not add signing material, provisioning profiles, or private account details to the repo.
