# Exec Plan

## Goal

Complete the declared Native and Rewarded placements with policy-safe behavior on both platforms.

## Scope

In scope:

- Native template widget/cadence, rewarded lifecycle/readiness, Ranking CTA and localized insight.

Out of scope:

- SSV and durable rewards, because the reward is read-only and has no monetary or account value.

## Risk Classification

Risk flags:

- External systems.
- Cross-platform.
- Existing behavior.
- Public user-visible workflow.

Hard gates:

- External provider behavior.

## Work Phases

1. Confirm provider APIs and current list/ranking layouts.
2. Record contract and reward semantics.
3. Add testable placement/insight rules.
4. Implement provider lifecycle and UI.
5. Run FVM tests, analysis, and Android/iOS builds.
6. Update Harness proof and friction.

## Stop Conditions

Pause if the reward gains monetary/account value or requires server-side verification.
