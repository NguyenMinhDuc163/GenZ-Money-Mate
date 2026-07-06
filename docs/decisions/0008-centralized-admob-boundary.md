# 0008 Centralized AdMob Boundary

Date: 2026-07-06

## Status

Accepted

## Context

AdMob is a platform-specific external provider whose object lifecycle, test identifiers, and
placement rules must not leak across product views.

## Decision

Centralize SDK lifecycle and interstitial policy in `AdService`, centralize placement IDs in
`AdIds`, and expose banners through one reusable widget. Keep native app IDs platform-specific.
Use Google test IDs in debug and require real platform IDs before production release.

Native in-feed ads use Google's small cross-platform template. Ranking Rewarded remains explicitly
opt-in and grants only a read-only savings insight from `onUserEarnedReward`; it never changes rank,
balances, transactions, or other durable state.

## Alternatives Considered

1. Per-screen SDK calls were rejected because they duplicate lifecycle and failure behavior.
2. One shared ID across platforms was rejected because AdMob identifiers are platform-specific.

## Consequences

Positive:

- Product views remain small and future formats have an explicit extension boundary.
- Provider failures degrade without blocking core transaction behavior.

Tradeoffs:

- Production releases require coordinated native and Dart identifier replacement.
- Provider behavior still requires physical-device validation.
- Android support now starts at API 23 because `google_mobile_ads` 6.x does not support API 21.
- The Android build uses Kotlin Gradle plugin 2.1.0 to consume Google Ads 24.1 metadata.

## Follow-Up

- Add production IDs, validate consent requirements for target regions, and complete device checks.
