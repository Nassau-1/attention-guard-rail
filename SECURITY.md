# Security

This repository contains native iOS source code and documentation for a personal focus app.

Do not commit:

- Apple Developer certificates or provisioning profiles
- private keys
- local `.xcconfig` files containing team-specific signing data
- exported health data
- app usage logs from a real device
- screenshots that expose private notifications or health metrics

Use local signing settings in Xcode or untracked `.xcconfig` files for machine-specific values.

If sensitive material is committed, rotate the affected credential immediately, remove it from Git history, and document the remediation in the changelog without exposing the secret.

