# Overview

## Current Behavior

The app has no advertising service, platform AdMob metadata, banners, or post-save frequency cap.

## Target Behavior

Home and Statistics render non-blocking adaptive banners. After a successful transaction save,
the app returns to the previous screen before considering a frequency-capped interstitial.

## Affected Users

- Android and iOS app users.

## Affected Product Docs

- `docs/product/advertising.md`

## Non-Goals

- Native, rewarded, app-open, and transaction-form advertising.
- App Store Connect and external `app-ads.txt` mutations.
