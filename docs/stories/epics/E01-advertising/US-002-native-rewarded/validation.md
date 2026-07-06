# Validation

## Proof Strategy

Unit-test native cadence and insight selection, analyze all changed boundaries, then compile Android
and iOS. Real production serving remains a physical-device release gate.

## Test Plan

| Layer | Cases |
| --- | --- |
| Unit | Native insertion cadence; insight selection from ranking data |
| Integration | Reward callback is the sole path to the insight |
| E2E | Manual opt-in, early dismissal, earned reward, native scroll |
| Platform | Android debug APK and unsigned iOS simulator build |
| Performance | No native request below threshold; ads disposed with widgets |
| Logs/Audit | Debug-only provider lifecycle logs |

## Fixtures

- Google Native and Rewarded test IDs.
- Deterministic `UserRanking` fixtures.

## Commands

```text
fvm flutter test test/core/ads
fvm flutter analyze <changed paths>
fvm flutter build apk --debug
fvm flutter build ios --simulator --no-codesign
```

## Acceptance Evidence

- `fvm flutter test test/core/ads`: passed, 8 tests.
- Scoped analysis of ads, rewarded insight/widget, and tests: passed with no issues.
- Translation JSON validation: passed for Vietnamese, English, and Chinese.
- `fvm flutter build apk --debug`: passed.
- `fvm flutter build ios --simulator --no-codesign`: passed.
- Code review confirms the reward closure is invoked only from `onUserEarnedReward`.
- All production Native/Rewarded IDs are configured and format-validated.
- Physical-device serving and early-dismiss behavior remain manual release gates.
