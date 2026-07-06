# Validation

## Proof Strategy

Prove cap/cooldown rules deterministically, statically analyze all Dart integration points, and
compile both platform shells. Physical-device serving and production-ID verification remain manual.

## Test Plan

| Layer | Cases |
| --- | --- |
| Unit | Counter threshold, cooldown, reset only after shown |
| Integration | DI registration and post-pop service call via analysis/build |
| E2E | Manual transaction save sequence on device |
| Platform | Android debug APK and unsigned iOS simulator build |
| Performance | Banner failure collapses; no automatic load retry loop |
| Logs/Audit | Debug lifecycle messages only |

## Fixtures

- In-memory SharedPreferences state.
- Google-provided debug test IDs.
- Injectable clock for deterministic cooldown checks.

## Commands

```text
fvm flutter test test/core/ads
fvm flutter analyze
fvm flutter build apk --debug
fvm flutter build ios --simulator --no-codesign
```

## Acceptance Evidence

- `fvm flutter test test/core/ads`: passed, 3 tests.
- Scoped `fvm flutter analyze`: passed with no issues for the AdMob service, widget, DI, state view, transaction view, and tests.
- Full-repo analysis remains non-zero because of 159 pre-existing info/warning findings.
- `fvm flutter build apk --debug`: passed; artifact at `build/app/outputs/flutter-apk/app-debug.apk`.
- `fvm flutter build ios --simulator --no-codesign`: passed; artifact at `build/ios/iphonesimulator/Runner.app`.
- Full `fvm flutter test` remains non-zero because the pre-existing fully commented `test/widget_test.dart` has no `main()`.
- All production App/Ad Unit IDs are configured and format-validated.
- Physical-device serving, iOS Marketing URL, and `app-ads.txt` verification remain manual release gates.
