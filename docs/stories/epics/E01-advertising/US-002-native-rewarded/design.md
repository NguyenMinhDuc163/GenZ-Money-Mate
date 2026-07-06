# Design

## Domain Model

Native placement cadence is eight visible transactions. Rewarded content is a read-only insight
derived from the already loaded `UserRanking`; it does not alter financial or ranking state.

## Application Flow

Each native widget owns and disposes one `NativeAd` using Google's small template. `AdService`
preloads one ranking `RewardedAd`, publishes readiness, and calls the reward closure only from
`onUserEarnedReward`. Dismiss/failure disposes and preloads a replacement.

## Interface Contract

- `TransactionList(showNativeAds: true)` enables cadence only in `AllViewTransaction`.
- `AdService.showRankingRewarded(onRewardEarned: ...)` is called only by the Ranking CTA.
- No reward is delivered from dismissal, impression, or click callbacks.

## Data Model

No persistent or server-side reward is created. Existing `UserRanking` data supplies the insight.

## UI / Platform Impact

The native template has explicit 90–200 px constraints for iOS and Android. Failed loads collapse
without an empty slot. Rewarded UI remains disabled while an ad is unavailable.

## Observability

Debug logs cover native/rewarded load, failure, show, dismissal, and reward callbacks.

## Alternatives Considered

1. Custom native factories were rejected because the official small template meets this in-feed
   layout without duplicating Android/iOS native view code.
2. Granting rank points was rejected because a client-only callback must not mutate core finances.
