# SPEC: MIGRATE GENZ-MONEY-MATE TO FASTLANE MATCH + PRE-RELEASE VALIDATION

Repository:
NguyenMinhDuc163/GenZ-Money-Mate

Signing repository:
NguyenMinhDuc163/apple-signing

Bundle ID:
com.nguyenduc.genzMoneyMate

Team ID:
Q236Z72BGN

==================================================
1. GOAL
==================================================

Replace old manual iOS signing:

IOS_DISTRIBUTION_CERTIFICATE_P12_BASE64
IOS_DISTRIBUTION_CERTIFICATE_PASSWORD
IOS_APPSTORE_PROVISIONING_PROFILE_BASE64

with:

Fastlane Match readonly
→ NguyenMinhDuc163/apple-signing

Also add pre-release validation BEFORE version bump.

Do not redesign existing release architecture.

==================================================
2. SIGNING ASSETS ALREADY EXIST
==================================================

Use existing Match assets:

certs/distribution/
  Certificates.cer
  Certificates.p12

profiles/appstore/
  AppStore_com.nguyenduc.genzMoneyMate.mobileprovision

Do NOT:
- create certificate
- regenerate profile
- revoke anything
- modify apple-signing
- match nuke
- readonly:false

==================================================
3. FILES
==================================================

Add:

ios/fastlane/Matchfile
.github/workflows/reusable-validate-project.yml

Modify:

ios/fastlane/Fastfile
ios/fastlane/Appfile
.github/workflows/reusable-ios-testflight.yml
.github/workflows/mobile-store-release.yml

Update stale signing docs if present.

Do not modify Android release logic.

==================================================
4. MATCHFILE
==================================================

Create:

git_url(ENV.fetch("MATCH_GIT_URL"))
storage_mode("git")
git_branch("main")

app_identifier([
  "com.nguyenduc.genzMoneyMate"
])

type("appstore")

team_id(ENV["IOS_TEAM_ID"]) unless ENV["IOS_TEAM_ID"].to_s.strip.empty?

==================================================
5. FASTFILE
==================================================

Keep existing build logic.

In lane :beta:

setup_ci

api_key = app_store_connect_api_key(...)

match(
  type: "appstore",
  platform: "ios",
  app_identifier: APP_IDENTIFIER,
  readonly: true,
  api_key: api_key
)

Read:

Actions.lane_context[
  SharedValues::MATCH_PROVISIONING_PROFILE_MAPPING
]

Require mapping for:

com.nguyenduc.genzMoneyMate

Set:

ENV["IOS_PROVISIONING_PROFILE_NAME"] = matched_profile_name

Then reuse existing:

configure_ci_code_signing
build_export_options
build
upload_to_testflight

==================================================
6. REMOVE MANUAL SIGNING
==================================================

From reusable-ios-testflight.yml remove:

IOS_DISTRIBUTION_CERTIFICATE_P12_BASE64
IOS_DISTRIBUTION_CERTIFICATE_PASSWORD
IOS_APPSTORE_PROVISIONING_PROFILE_BASE64

Delete manual:

- base64 decode P12
- base64 decode provisioning profile
- security create-keychain
- security import
- manual profile installation
- manual IOS_PROVISIONING_PROFILE_NAME extraction

Use setup_ci + Match only.

==================================================
7. NEW MATCH SECRETS
==================================================

Add:

IOS_TEAM_ID
MATCH_GIT_URL
MATCH_PASSWORD
MATCH_GIT_BASIC_AUTHORIZATION

Keep:

APP_STORE_CONNECT_KEY_ID
APP_STORE_CONNECT_ISSUER_ID
APP_STORE_CONNECT_API_KEY_P8

Expected:

IOS_TEAM_ID =
Q236Z72BGN

MATCH_GIT_URL =
https://github.com/NguyenMinhDuc163/apple-signing.git

MATCH values should be the same already proven by the working NRO,
Edtech and Fire Guard pipelines.

==================================================
8. APPFILE
==================================================

Remove personal Apple ID:

apple_id("ngminhduc1603@icloud.com")

Keep:

app_identifier("com.nguyenduc.genzMoneyMate")
team_id("Q236Z72BGN")

==================================================
9. VERSIONING - DO NOT BREAK IT
==================================================

This project already uses Flutter build version correctly.

Main Runner must remain:

MARKETING_VERSION = "$(FLUTTER_BUILD_NAME)"
CURRENT_PROJECT_VERSION = "$(FLUTTER_BUILD_NUMBER)"

Do not replace these with hardcoded values.

Do not blindly modify RunnerTests.

==================================================
10. USE ONE ARCHIVE PATH
==================================================

Avoid the previous Edu-Tech path bug.

Do not construct separate archive paths for build and validation.

Define one absolute path using GITHUB_WORKSPACE or repo root:

IOS_ARCHIVE_PATH =
<repo>/build/ios/archive/Runner.xcarchive

Use the SAME path for:

build_app
archive validation

Never hardcode:

/Users/runner/work/<repo>/<repo>

Repository rename must not break CI.

==================================================
11. VALIDATE BUILT ARCHIVE
==================================================

After build_app and BEFORE TestFlight upload:

Read:

Runner.xcarchive/
Products/Applications/Runner.app/Info.plist

Validate:

CFBundleShortVersionString
==
pubspec version

CFBundleVersion
==
pubspec build number

Fail before upload if mismatch.

Do not trust IPA filename alone.

==================================================
12. PRE-RELEASE VALIDATION WORKFLOW
==================================================

Create:

.github/workflows/reusable-validate-project.yml

Prefer same proven structure used in Fire Guard.

Run before bump_version.

Validate:

APP_STORE_CONNECT_KEY_ID
APP_STORE_CONNECT_ISSUER_ID
APP_STORE_CONNECT_API_KEY_P8

IOS_TEAM_ID
MATCH_GIT_URL
MATCH_PASSWORD
MATCH_GIT_BASIC_AUTHORIZATION

Checks:

- all secrets present
- IOS_TEAM_ID == Q236Z72BGN
- MATCH_GIT_URL points to apple-signing
- P8 has BEGIN/END PRIVATE KEY
- Match Git auth is valid
- apple-signing can be read
- MATCH_PASSWORD can decrypt signing repo
- App Store profile exists for com.nguyenduc.genzMoneyMate
- profile Team ID == Q236Z72BGN
- App Store Connect authentication succeeds

Validation is read-only.

Do not upload anything.

Do not create signing assets.

Do not print secret values.

IMPORTANT:
Do NOT invent ENV_FILE_CONTENTS for this project unless repository
inspection proves the application actually requires it.

==================================================
13. RELEASE ORDER
==================================================

Modify mobile-store-release.yml:

validate_project
      ↓
bump_version
      ↓
build_testflight / build_google_play

bump_version must depend on validation success.

If validation fails:

- no version bump
- no macOS runner
- no TestFlight build

Keep existing Android behavior after validation succeeds.

==================================================
14. APP STORE CONNECT P8
==================================================

Keep temporary:

$RUNNER_TEMP/AuthKey.p8

Write with:

printf '%s' "$APP_STORE_CONNECT_API_KEY_P8"

Never log P8 contents.

Cleanup with if: always().

==================================================
15. IMPORTANT LESSONS FROM PREVIOUS MIGRATIONS
==================================================

Do NOT:

- create custom Match keychain paths
- manually use ~/Library/Keychains/fastlane_tmp_keychain
- hardcode GitHub runner repo paths
- regenerate Match password
- use raw PAT as MATCH_GIT_BASIC_AUTHORIZATION
- assume repository GITHUB_TOKEN can read private apple-signing
- update Fastlane/Gemfile.lock unnecessarily
- trust IPA filename as actual CFBundleVersion

MATCH_GIT_BASIC_AUTHORIZATION must be Base64 of:

NguyenMinhDuc163:PAT

with read access to apple-signing.

==================================================
16. OLD SECRETS
==================================================

Agent must NOT delete GitHub secrets.

After one real TestFlight build succeeds, user can delete:

IOS_DISTRIBUTION_CERTIFICATE_P12_BASE64
IOS_DISTRIBUTION_CERTIFICATE_PASSWORD
IOS_APPSTORE_PROVISIONING_PROFILE_BASE64

==================================================
17. ACCEPTANCE
==================================================

Complete when:

[ ] Matchfile added
[ ] setup_ci runs before Match
[ ] Match uses appstore + readonly:true
[ ] correct profile mapping is obtained
[ ] manual P12/profile install removed
[ ] no custom signing keychain
[ ] personal Apple ID removed
[ ] Flutter version propagation remains intact
[ ] archive path is shared and absolute
[ ] archive version/build validated
[ ] validation runs before bump_version
[ ] Match repo/decryption/profile validated
[ ] ASC authentication validated
[ ] Android logic unchanged
[ ] apple-signing unchanged
[ ] no secrets printed

Final report only:
- changed files
- validation result
- Match configuration
- old secrets no longer referenced
- confirm apple-signing not modified
- confirm no certificate/profile created
- confirm no TestFlight run unless explicitly requested