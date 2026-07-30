# gaming_library_assessment_flutter

Flutter assessment - Gaming library with RAWG

## Getting Started

### 1. Create the environment files

Copy each committed template in the project root and fill in real values. All
three files are matched by the `*.env` rule in `.gitignore` and must never be
committed.

| Copy from | Create | Supplies |
| --- | --- | --- |
| `secret.env.example` | `secret.env` | `API_KEY` (RAWG), `TWITCH_CLIENT_ID`, `TWITCH_CLIENT_SECRET` (IGDB) |
| `dev.env.example` | `dev.env` | `SUPABASE_URL`, `SUPABASE_ANON_KEY` for the dev Supabase project |
| `prod.env.example` | `prod.env` | `SUPABASE_URL`, `SUPABASE_ANON_KEY` for the prod Supabase project |

```
cp secret.env.example secret.env
cp dev.env.example dev.env
cp prod.env.example prod.env
```

Every value is resolved by `envied` at code-generation time, so a missing or
changed value only takes effect after the next generator run. A file left with
its placeholder values still generates — the build succeeds and the affected
API calls fail at runtime.

### 2. Generate code

```
dart run build_runner build --delete-conflicting-outputs
```

This produces `config_envied.g.dart` (git-ignored) along with the freezed, json,
retrofit, injectable, isar and route outputs.

### 3. Build flavours

The app ships two Android product flavours under the `env` dimension:

| Flavour | Application ID | Home-screen label | Dart entrypoint |
| --- | --- | --- | --- |
| `dev` | `com.questloggd.app.dev` | QuestLoggd Dev | `lib/main.dart` |
| `prod` | `com.questloggd.app` | QuestLoggd | `lib/main_prod.dart` |

The identifiers differ, so both flavours can be installed side by side, and the
dev flavour carries its own launcher icon from `android/app/src/dev/res/`.

Run:

```
flutter run --flavor dev -t lib/main.dart
flutter run --flavor prod -t lib/main_prod.dart
```

Build:

```
flutter build apk --debug --flavor dev -t lib/main.dart
flutter build apk --release --flavor prod -t lib/main_prod.dart
```

The same commands are available as VS Code tasks (`run: dev`, `run: prod`,
`build: dev (debug apk)`, `build: prod (release apk)`).

> **Always pass `-t lib/main_prod.dart` with `--flavor prod`.** The Gradle
> flavour selects the Android configuration only — it does not select the Dart
> entrypoint. Without `-t`, Flutter uses the default entrypoint `lib/main.dart`,
> which resolves the **dev** Supabase configuration, producing a production-signed
> app pointed at the dev project.
