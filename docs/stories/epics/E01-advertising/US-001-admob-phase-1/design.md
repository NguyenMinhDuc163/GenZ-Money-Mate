# Design

## Domain Model

`AdPlacement` names stable product placements. The success counter and last-shown timestamp are
local device state, not financial-domain data.

## Application Flow

`AdService` initializes the SDK, preloads one interstitial, records successful saves, applies the
four-save/three-minute cap, and replenishes a consumed ad. A failed load is retried only on a later
save or after a consumed ad, avoiding request loops.

## Interface Contract

UI uses `AdBannerWidget(placement: ...)` and `AdService.onTransactionSavedSuccessfully()` only.
It does not load Google ad objects directly.

## Data Model

SharedPreferences keys:

- `ad_interstitial_success_transaction_count`
- `ad_last_interstitial_shown_at`

## UI / Platform Impact

Android/iOS native metadata receives its platform app ID. Banner failure collapses to zero space.
Web and other platforms do not initialize or render AdMob.

## Observability

Debug-only logs cover initialization, load, show, failure, and frequency-cap skip reasons.

## Alternatives Considered

1. Loading ads directly in views was rejected because lifecycle and policy rules would be duplicated.
2. Resetting the cap before display was rejected because failed display would consume user progress.
