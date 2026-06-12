# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project overview

GenZ Money Mate is a Flutter personal finance app for tracking daily income/expenses, balances, category statistics, and rankings. It supports Vietnamese, English, and Chinese via `easy_localization` assets in `assets/translations/`.

The app targets Flutter 3.29.2 (see `.fvmrc`) and Dart SDK `^3.7.0`. README also notes Java 17 for Android builds.

## Common commands

Prefer FVM when available because the repository pins Flutter 3.29.2:

```bash
fvm flutter pub get
fvm flutter analyze
fvm flutter test
fvm flutter test test/widget_test.dart
fvm flutter run
```

Equivalent non-FVM commands are `flutter pub get`, `flutter analyze`, `flutter test`, and `flutter run`.

Code generation is required for Freezed/JSON/Hive generated files:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Builds:

```bash
fvm flutter build apk --release
fvm flutter build web --release --base-href="/GenZ-Money-Mate/" -t lib/main_preview.dart --dart-define=ENABLE_DEVICE_PREVIEW=true
```

Run a package-level command from a local package directory when changing one of the packages under `packages/`, for example:

```bash
cd packages/db_hive_client && flutter test
cd packages/auth_user && flutter analyze
```

## Architecture

- `lib/main.dart` is the normal app entrypoint. It initializes Flutter bindings, `EasyLocalization`, dependency injection, the BLoC observer, and runs `DailyTrackerApp`.
- `lib/main_preview.dart` is the web/preview entrypoint used by CI. It wraps the app in `DevicePreview` and can enable it in release with `--dart-define=ENABLE_DEVICE_PREVIEW=true`.
- `lib/app/daily_tracker_app.dart` wires all app-wide cubits with `MultiBlocProvider`, connects language changes to `MainCubit`, sets theme mode from `ThemesCubit`, and configures `MaterialApp` routing/localization.
- `lib/core/app_injections.dart` is the central dependency registration point using `get_it`. Add new repositories/services/cubits here when they need app-wide injection.
- `lib/core/router/app_route.dart` contains named routes and maps them to the main feature views.
- `lib/core/models/` contains domain models and generated serialization/Hive adapters. Many models use Freezed/JSON serialization; regenerate after editing source models.
- `lib/features/` is organized by UI features and state management. Cubits live under `lib/features/blocs/` or feature-local `bloc/` directories, views under each feature's `view/`, and repositories under each feature's `data/` directory.
- `packages/` contains local reusable packages used by the app:
  - `auth_user`: Firebase Auth / Google Sign-In abstraction.
  - `user_service`: user profile service backed by Firebase APIs.
  - `db_firestore_client`: Firestore wrapper methods for document, collection, query, and stream access.
  - `db_hive_client`: Hive wrapper methods for local persistence.

## Data flow and persistence

Repositories generally depend on `DbFirestoreClientBase`, `DbHiveClientBase`, and/or `AuthUserBase` rather than concrete implementations. The app supports guest/offline local storage with Hive and authenticated cloud storage with Firestore:

- Guest transactions/categories are stored in Hive boxes initialized in `initAppConfig()` (`transactions`, `category_groups`, `custom_categories`).
- When a user is logged in, repositories write/read Firestore documents scoped by the current user's UID.
- Some repositories migrate pending Hive data to Firestore after login, then clear local Hive boxes.

## Localization, assets, and styling

- Translation files are `assets/translations/en.json`, `vi.json`, and `zh.json`; keep keys aligned across all locales.
- Fonts and assets are declared in `pubspec.yaml`; the app uses the Inter font family.
- Shared widgets/styles are under `lib/core/shared/` and `lib/core/styles/`.

## Firebase and CI

Firebase initialization uses `lib/core/firebase_options.dart` and Android uses `android/app/google-services.json`. The GitHub Actions workflow builds/deploys web from `lib/main_preview.dart`, runs `flutter pub get`, generates code with build_runner, and deploys `build/web` to `gh-pages` with base href `/GenZ-Money-Mate/`.
