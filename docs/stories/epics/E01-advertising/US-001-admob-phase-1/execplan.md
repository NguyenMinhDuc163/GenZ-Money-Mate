# Exec Plan

## Goal

Deliver phase-1 AdMob banners and a safe post-save interstitial path for Android and iOS.

## Scope

In scope:

- Centralized IDs/placements, SDK service, DI registration, two banners, transaction-success hook.
- Native Android/iOS metadata and automated Dart validation.

Out of scope:

- Phase-2 formats and external AdMob/App Store administration.

## Risk Classification

Risk flags:

- External systems.
- Cross-platform.
- Existing behavior.
- Weak proof until physical-device ad validation is completed.

Hard gates:

- External provider behavior.

## Work Phases

1. Inspect the current navigation, DI, layout, package, and platform shells.
2. Record product and architecture contracts.
3. Add deterministic cap tests and platform/build checks.
4. Implement the smallest phase-1 slice.
5. Run FVM formatting, tests, analysis, and platform builds.
6. Update story proof and Harness trace.

## Stop Conditions

Pause for human confirmation if production IDs are required to claim release readiness or if a
consent-management requirement appears.
