# iOS Fastlane/TestFlight

Run from `ios/`:

```sh
bundle install
bundle exec fastlane ios build
bundle exec fastlane ios beta
```

Bundle identifier:

```text
com.nguyenduc.genzMoneyMate
```

Version comes from `pubspec.yaml`:

```yaml
version: 1.0.0+18
```

Use `APP_STORE_CONNECT_API_KEY_KEY_FILEPATH` for a raw `.p8` file. Do not use `APP_STORE_CONNECT_API_KEY_PATH` for `.p8`.

Local `.env` shape:

```env
APP_STORE_CONNECT_KEY_ID=
APP_STORE_CONNECT_ISSUER_ID=
APP_STORE_CONNECT_API_KEY_KEY_FILEPATH=
```

GitHub Actions secrets:

```text
APP_STORE_CONNECT_KEY_ID
APP_STORE_CONNECT_ISSUER_ID
APP_STORE_CONNECT_API_KEY_P8
IOS_TEAM_ID
MATCH_GIT_URL
MATCH_PASSWORD
MATCH_GIT_BASIC_AUTHORIZATION
```

GitHub Actions uses Fastlane Match in read-only mode. The Match repository must
contain an App Store provisioning profile matching:

```text
com.nguyenduc.genzMoneyMate
```
