# Advertising

## Advertising contract

- Home and Statistics show platform-specific adaptive banners after their main content.
- Transaction entry and selection flows never contain ads.
- A transaction-success interstitial is considered only after the transaction screen has popped.
- The interstitial requires four successful saves and a three-minute cooldown.
- Failed initialization, loading, or display must not interrupt the product flow.
- Debug builds use Google's Android/iOS test ad units. Release builds use the corresponding production units.
- The full transaction list inserts a small, clearly identified native template after every eight
  displayed transactions. Lists shorter than eight do not request native ads.
- Ranking offers a user-initiated rewarded ad. The savings insight is revealed only after the SDK
  invokes the earned-reward callback; dismissing early grants nothing.

## Platform configuration

Android and iOS have separate AdMob app IDs and ad-unit IDs. Native app IDs are configured in
`AndroidManifest.xml` and `Info.plist`; ad-unit IDs are centralized in `lib/core/ads/ad_ids.dart`.
All Android/iOS App IDs and phase-complete Ad Unit IDs are configured. Production release still
requires physical-device serving checks before submission.
The Android app requires API 23 or newer after adopting `google_mobile_ads` 6.x.

## Out of scope

App-open ads, rewarded interstitials, consent-management UI, and App Store Connect/app-ads.txt
administration are not implemented here.
