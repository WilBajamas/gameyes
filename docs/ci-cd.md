# CI/CD

## CI on `develop`

`.github/workflows/ci.yml` runs for pull requests into `develop` and pushes to
`develop`.

The shared verification job runs:

1. Generated-code check.
2. Dart formatting check.
3. Flutter analysis.
4. Unit and widget tests through `flutter test`.

After verification passes, Android and iOS compile independently:

- Android compiles a dev debug APK and a prod release APK.
- iOS compiles the current `Runner` scheme without signing.
- Golden tests and golden artifact uploads are not included.

Protect `develop` and require all three jobs before merging:

- `Verify Flutter code`
- `Android compile (dev)` and `Android compile (prod)`
- `iOS compile`

## Android Fastlane releases

`.github/workflows/release.yml` is manually run from `main`. It selects a
GitHub Environment, creates the required files on the temporary GitHub runner,
and passes their paths and release values to Fastlane. Fastlane is responsible
only for building and uploading the artifact.

The lanes are:

- `android dev`: release APK to Firebase App Distribution.
- `android prod`: release AAB to Google Play internal testing.

Create GitHub Environments named `dev` and `prod`. Add these secrets to both:

- `ANDROID_UPLOAD_KEYSTORE_BASE64`
- `ANDROID_STORE_PASSWORD`
- `ANDROID_KEY_PASSWORD`
- `ANDROID_KEY_ALIAS`
- `API_KEY`
- `SENTRY_DSN`
- `SUPABASE_URL`
- `SUPABASE_ANON_KEY`

For `dev`, also add:

- Secret `FIREBASE_SERVICE_ACCOUNT_JSON_BASE64`
- Variable `FIREBASE_APP_ID`
- Variable `FIREBASE_TESTER_GROUPS`

For `prod`, also add:

- Secret `PLAY_SERVICE_ACCOUNT_JSON_BASE64`

Encode a file for a GitHub secret in PowerShell with:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes('C:\path\to\file')) | Set-Clipboard
```

If no build number is entered when dispatching the workflow, the GitHub Actions
run number is used.

## Remaining iOS release setup

The repository currently has only the default `Runner` scheme, the placeholder
bundle identifier `com.example.gamingLibraryAssessmentFlutter`, and no committed
Apple signing configuration. A signed IPA/TestFlight production lane should be
added after the real bundle IDs, dev/prod schemes, Apple team, certificates,
profiles, and App Store Connect API key are configured.

## Existing quality baseline

The pipeline intentionally does not hide existing failures. At setup time, the
repository had 116 Dart files needing formatting, 2 analyzer warnings (32 total
diagnostics), and 8 failing tests. CI will remain red until those are fixed.
