# Week 1 — Foundation task briefs

> ## ⚠ EPHEMERAL — DELETE THIS FILE WHEN WEEK 1 IS DONE
>
> This is a working checklist, not a reference document. Once every item below is
> ticked, **delete `.agents/week-1-task-briefs.md`**. Anything in here worth
> keeping should have been promoted into `.agents/references/` or the roadmap by
> then. A stale checklist that outlives its week is worse than no checklist —
> agents read it as current intent.
>
> Written 2026-07-30. If you are reading this after week 1 shipped, delete it.

---

## How to use this

Items are in dependency order. Two kinds:

- **[MANUAL]** — console work, vendor dashboards, credentials. You do these. An
  agent cannot, and should not be given the credentials to try.
- **[PIPELINE]** — feed the requirement text to `/orchestrate` as a run. One item
  is one run.

**Some items are neither.** SQL migrations and Deno Edge Functions are outside the
pipeline's competence — its Tech Lead skill loads `flutter-arch.md` and enforces
Dart conventions, build_runner and Flutter test layout. Those are marked
**[MANUAL-CODE]**: write them with an agent in a normal session, not through
`/orchestrate`.

---

## Stage 0 — Credentials and consoles [MANUAL]

Nothing below can start until these exist. Budget half a day; most of it is waiting
on vendor dashboards.

- [x] **0.1a — Supabase `questloggd-dev`.** ✅ Done 2026-07-30. URL + publishable
      key recorded. (`publishable` is Supabase's current name for the old `anon`
      key — safe in the app, protected by RLS. The one never to ship is now called
      `secret`, formerly `service_role`.)
- ⏸ **0.1b — Supabase `questloggd-prod` — DEFERRED.** Free-plan project cap
      reached. Tracked in `roadmap-deferred.md`. Nothing in weeks 1–3 needs it; the
      `prod` flavour runs on placeholder env values until it exists.
- ⏸ **0.2 — Apple Developer — SKIPPED.** v1 is Android-only; no Mac, no iPhone, so
      iOS cannot be built or verified. Saves the $99/yr enrolment and what would have
      been the slowest item in this stage. Returns with iOS.
- [x] **0.3 — Discord developer app.** ✅ Done 2026-08-05. Created and wired
      into Supabase dev (see 0.6). Discord sign-in verified end-to-end on device
      during item 8's manual checks.
- [x] **0.4 — Google Cloud OAuth client.** ✅ Done 2026-08-05. Quota issue
      resolved and the client created; credentials pasted into Supabase dev
      (see 0.6). No code change was needed, exactly as predicted.
- [x] **0.5 — Twitch developer app — IGDB credential only.** ✅ Already done and
      working; IGDB APICalypse calls succeed today. Client ID and Secret live in
      `secret.env`. Item 9 moves them server-side.
- [x] **0.6 — Configure both providers (Discord, Google) in Supabase Auth
      settings.** ✅ Done 2026-08-05, **dev only**. Both providers are live on
      the `questloggd-dev` project and sign-in was verified on device during
      item 8's manual checks. **Prod is not configured** — it has no Supabase
      project at all (0.1b, still deferred), so this must be repeated there
      before any prod build can sign anyone in.
- [x] **0.7 — Sentry project.** ✅ Done 2026-07-30. DSN recorded. **One project**,
      environment-tagged, not two — see item 10.
      Crashlytics was weighed and rejected: genuinely cheaper (free, unlimited vs
      Sentry's ~5k events/month) but it needs a `google-services.json` per
      `applicationId`, which means a second config file inside the flavour structure
      and another Firebase project at a moment when Google Cloud quota is already
      exhausted. It also misses handled exceptions unless each is logged explicitly,
      and handled exceptions are most of what goes wrong in a new backend
      integration. Revisit if the free tier is ever exceeded.
- [x] **0.8 — Provider marks.** ✅ Done 2026-07-31.
      `assets/icons/discord-logo.svg` and `assets/icons/google-logo.svg`.
      Note two follow-ons, both authorised inside item 7: `assets/icons/` is not yet
      registered under `flutter: assets:` in `pubspec.yaml`, and there is no
      `flutter_svg` dependency, so nothing can render them today.

---

## Stage 1 — Build foundations

### 1 — Flavours [PIPELINE]

> Add two build flavours, `dev` and `prod`, to the Flutter app. **Android is the only
> shipping target** — configure iOS bundle identifiers and schemes only insofar as it
> is free to do so, and never claim iOS is verified, because it cannot be built on
> this machine. Each flavour must have its own application identifier, so both can be
> installed side by side on one device, and its own app icon and display name so they
> are distinguishable on a home screen. Each flavour must resolve its own
> Supabase project URL and anon key at build time through the existing `envied`
> setup, with no credential committed to the repository in plaintext. Provide a
> documented way to run and build each flavour, and update `.vscode/tasks.json` to
> match. Existing behaviour under the default entrypoint must not change.

Note for the run: `.vscode/tasks.json` uses `fvm`; the pipeline skills use bare
`flutter`. Harmless while the SDK versions match, but this is the run most likely to
surface it.

- [x] Done. Checkbox was simply never ticked — `lib/config/flavor/` (`flavor.dart`,
      `flavor_config.dart`), `dev`/`prod` product flavours with separate
      `applicationIdSuffix` in `android/app/build.gradle`, and `.vscode/tasks.json`
      already reflect this. Confirmed 2026-08-05 while resuming for item 3/9.

#### 1a — `app_title` rename [MANUAL — IDE ONLY]

Fallout from the QuestLoggd rename, and **no agent can do this one.**

`app_title` is `"Gaming Library Assessment"` in `lib/l10n/intl_en.arb` and
`intl_zh.arb`, and `main.dart` feeds it to `onGenerateTitle`, which Android shows
in the **task switcher**. After item 1 the home screen reads `QuestLoggd` while the
task switcher still reads `Gaming Library Assessment`.

Editing the `.arb` alone does nothing — the string is baked into
`lib/generated/intl/messages_en.dart` and `messages_zh.dart`, which come from the
Flutter Intl IDE plugin and have no CLI. Change both `.arb` files, then let the IDE
plugin regenerate. Do **not** hand-edit the generated files; that is the exact
mistake recorded in `.agents/handover.md` gotcha #2.

- [x] Both `.arb` files updated and regenerated in the IDE. Confirmed
      2026-08-05: `app_title` is `"QuestLoggd"` in both `.arb` files and in
      both generated `messages_en.dart`/`messages_zh.dart`. Checkbox was
      simply never ticked.

### 2 — Supabase client and DI [PIPELINE]

> Add the Supabase Flutter SDK and register a single initialised client through the
> existing `get_it` / `injectable` dependency injection setup, following the same
> `@preResolve` module pattern already used for `SharedPreferences` in
> `lib/core/di/storage_module.dart`. The client must read its URL and anon key from
> the flavour configuration rather than from hardcoded constants. No feature code may
> construct its own client or reach for the SDK's global singleton — the client is
> injected like every other dependency. Include a lightweight connectivity check that
> can be called at startup to confirm the client resolves against the configured
> project.

- [x] Done. **2026-08-01.** Full pipeline run, merged to `develop` via PR #16.
      `SupabaseModule` (`@preResolve`) + `SupabasePing` (concrete, no interface —
      dropped `ISupabaseHealthProbe` as over-engineered) + `SupabaseConnectionChecker`,
      called unawaited from `bootstrap()`. Manually verified on device: dev
      reachable, prod unreachable (expected — no prod project yet), first frame
      reached either way. Run folder `supabase-client-di-20260731` (since
      removed — run complete, evidence retired).

### 3 — Database schema and RLS [MANUAL-CODE]

Not a pipeline run — SQL, and the highest-stakes item in the week.

Write as migration files checked into the repo, not as clicks in the dashboard, so
dev and prod stay identical and the schema has a history.

**Tables:** `profiles` (extends `auth.users`), `library_entries`, and enough of a
`lists` stub to prove the shape. **Do not build the full lists feature** — custom
lists are a deferred Pro feature.

Four decisions that are cheap now and expensive later, all agreed already:

1. **IGDB snapshot.** `library_entries` stores the IGDB ID as the join key **plus a
   denormalised copy** of title, cover URL and release date. Without this, every
   Library scroll and every Stats query becomes an IGDB round-trip you cannot sort
   or filter server-side.
2. **Entitlement column.** Nullable `tier` on `profiles`. Never read in v1. Avoids a
   migration on a live user table when Pro ships.
3. **Account deletion cascade.** Every user-owned row cascades from `auth.users`.
   Both stores mandate in-app account deletion; retrofitting the cascade later is
   painful.
4. **Six status values** matching the design system exactly: Playing, Backlog,
   Completed, Dropped, Wishlist, On hold.

**RLS is the whole security surface of this app.** Enable it on every table. Write
an explicit policy per operation — a table with RLS enabled and no policy is
readable by nobody, and a table without RLS enabled is readable by everybody.

Verify by trying to read another user's row with a real second account, not by
reading the policy and agreeing with yourself. This is worth an hour on its own.

- [x] Schema migrations written and applied to dev. **2026-08-05.**
      `supabase/migrations/`: `profiles` (+ auto-create trigger on
      `auth.users` insert), `library_entries` (IGDB snapshot, six-value
      status check, one row per user+game), `lists` (stub). Applied to the
      real `questloggd-dev` project via the SQL editor, confirmed by the
      human.
- [x] RLS enabled on every table, policy per operation. Every table has
      select; `library_entries`/`lists` also have insert/update/delete
      scoped to `auth.uid() = user_id`; `profiles` deliberately has no
      insert/delete policy (insert is trigger-only, delete is cascade-only).
- [ ] Cross-account read/write denial verified with two real accounts.
      Logic was proven against a local disposable Postgres standing in for
      Supabase (two fake users, RLS enforced, cross-read/write/delete all
      correctly blocked, cascade-delete and constraints all fired) — that is
      NOT the same as verifying on the real dev project with the real app,
      which still needs to happen.
- [ ] Applied to prod. Blocked — no prod Supabase project exists yet (0.1b,
      still deferred).

### 4 — Design token layer [PIPELINE]

Pulled into week 1 because the auth and welcome screens need it. The component
library itself stays in week 2.

> Implement the QuestLoggd design tokens as a Flutter `ThemeExtension` on the
> existing dark theme, replacing ad-hoc colour and text style constants in the app's
> theme configuration. Cover the colour tokens, the type scale, the radius scale and
> the motion durations defined in `.agents/references/system-foundation-specs.md`. The app
> canvas is onyx `#23272a`. Status hues are locked: On hold violet `#7d4ee0`,
> Wishlist link cyan `#00b0f4`. Include the locally-defined error ramp. Structure the
> extension so a light theme can be added later as a second instance without
> restructuring — but do not implement light theme now. No widget may reference a raw
> hex value once this lands.

- [x] Done. **2026-07-31.** Full pipeline run, QA pass-pending-manual. Run
      folder `design-token-layer-20260731` (since removed — run complete,
      evidence retired). Retroactively brought in line with the plain-English
      comment/naming rules added during item 2 (see `handover.md`). Merged to
      `develop` via PR #17 on 2026-08-02.

---

## Stage 2 — Authentication

### 5 — Auth domain and data layer [PIPELINE]

> Implement the authentication domain and data layers for social sign-in via
> Supabase, with no UI. Support two providers: Discord and Google. Design the provider
> abstraction so further providers can be added later without reshaping the repository
> interface — Twitch and Apple are both deferred, not ruled out. Follow the project's
> Clean Architecture layering — a repository interface in the
> domain layer, a Supabase-backed implementation in the data layer, and use cases for
> sign-in, sign-out, and observing the current authentication state. Session
> persistence across app restarts must rely on the Supabase SDK's own secure storage;
> do not hand-roll token storage or place tokens in `SharedPreferences`. The
> authentication state must be exposed as a stream so the UI can react to sign-out
> and token expiry without polling. Target Android only — add no iOS-specific auth
> handling and no platform conditionals.

- [x] Done. **2026-08-02.** Full pipeline run plus direct human review at the
      Phase 4B gate (mapper extraction, comment/format decisions), QA pass with
      no manual checks outstanding — Android debug build verified directly.
      Run folder `auth-domain-data-layer-20260802`. Merged to `develop` via
      **PR #19**.

### 6 — Welcome screens [PIPELINE]

> Build the two onboarding welcome screens exactly as specified in
> `.agents/references/onboarding-welcome-design-spec.md`. Screen 1 offers Next and
> Skip; screen 2 ends the flow with Get started and no skip. Use the design tokens
> from the theme extension — no raw hex values. Cover art, key art, and other visual
> showcases must load the developer-provided image assets from `assets/`; do not
> recreate that artwork with widget-drawn shapes or custom painting. The flow must
> record that onboarding has been seen, so it does not reappear on subsequent launches.

- [x] Done. **2026-08-03.** Implemented and reviewed in run folder
      `welcome-screens-20260802`; merged to `develop` via **PR #20**. The final
      analyzer/test-harness correction was accepted under a human-authorized QA
      retry waiver after Flutter tooling timed out without diagnostics. Manual
      visual verification of both welcome screens remains recommended.
      **Superseded twice since,** both riding on the same branch and merged to
      `develop` together via **PR #23** on 2026-08-05 (neither had a separate
      PR — item 6.1 sat committed-but-unmerged until 6.2 caught up to it):
      item 6.1 (2026-08-04) replaced both heroes' composed-widget content with
      flat PNG art. Item 6.2 (2026-08-05) padded the hero art, reduced hero
      height to ~1/3 screen, added `SafeArea` plus a new app-wide system-bar
      convention, and made the two screens swipeable via `PageView`. All
      manual checks (6.1 hero art, 6.2 nav bar colour) PASSED on-device
      2026-08-05. Run folder retired, evidence kept in `handover.md`.

### 7 — Auth screen [PIPELINE]

> Build the sign-in screen exactly as specified in
> `.agents/references/onboarding-auth-design-spec.md`, wired to the auth use cases
> from item 5. Two provider rows, Discord then Google. Section 5a of that spec covers
> the Apple row and is explicitly parked — **do not implement it.**
>
> The official provider marks are already supplied at `assets/icons/discord-logo.svg`
> and `assets/icons/google-logo.svg`, so render those rather than the dashed
> placeholder slots. Two prerequisites are **explicitly authorised for this task, and
> must not be escalated**: add the `flutter_svg` package to `pubspec.yaml`, and
> register `assets/icons/` under the existing `flutter: assets:` list. Change no other
> dependency and no other asset path. Render each mark inside its specified 20×20 box;
> do not recolour, redraw, or crop either mark — Google's guidelines forbid
> recolouring outright.
>
> The 88px app mark has no asset yet and stays a dashed placeholder through beta. Failed sign-in uses the error conventions from the
> component brief, per section, never a full-page error.

- [x] Done. Merged to `develop` via **PR #21** ("implement auth screen and
      auth services"), predates this checklist file's last true edit — this
      box was simply never ticked until now. `auth_screen.dart`,
      `sign_in_cubit.dart`/`sign_in_state.dart`, `legal_footer.dart`,
      `provider_action_button.dart` all shipped. One deviation from spec:
      provider marks shipped as `assets/icons/discord-logo.png` /
      `google-logo.png` rather than the SVGs this brief describes, so
      `flutter_svg` was never added — `Image.asset` renders them instead. Not
      re-litigated here; if it matters, confirm with whoever approved PR #21.

### 8 — Route guard and session [PIPELINE]

> Add an authentication guard to the `auto_route` configuration so unauthenticated
> users are routed to the onboarding flow and authenticated users go straight to the
> main tab shell. The guard must react to the auth state stream from item 5, so a
> sign-out or an expired session returns the user to sign-in without an app restart.
> A user who has completed onboarding but signed out should land on the auth screen,
> not on welcome screen 1. Preserve the existing tab structure and deep links.

- [x] Done. **2026-08-05.** Full pipeline run, QA PASS, 0 QA cycles. Run folder
      `route-guard-session-20260805`. Merged to `develop` at `129443c`.
      Guard scope was widened at the human's call: `/` plus the four content
      routes, with `/onboarding`, `/auth` and `/legal` carved out, and the
      blocked route resumed after sign-in. `OnboardingGuard` was deleted and its
      decision folded into `AuthGuard`. 13 of 13 attempted device checks passed;
      the URL deep-link entry checks are deferred — Android has no `VIEW` intent
      filter for app routes yet. An unplanned follow-up run
      (`debug-sign-out-20260805`) added the Settings sign-out control, without
      which four of those checks had no trigger; its **visual design is
      provisional, not signed off**.

---

## Stage 3 — Infrastructure

### 9 — IGDB Edge Function proxy [MANUAL-CODE]

TypeScript on Deno, not Flutter — write it in a normal session.

Move IGDB access behind a Supabase Edge Function so the client never holds IGDB
credentials. The function holds the Twitch server-to-server Client ID and Secret
from item 0.5, handles token refresh, and forwards queries to IGDB.

Three wins beyond the security one: a single place to cache popular queries, IGDB
rate limiting applied per-app rather than per-user, and the ability to change IGDB
query shapes without shipping a new build.

Then update the Flutter side to call the function instead of IGDB directly. That
part **is** a pipeline run — split it.

- [x] Edge Function written and deployed to dev. **2026-08-05.**
      `supabase/functions/igdb-proxy/index.ts` — matches the two real
      endpoints exactly (`games`, `release_dates`, both used by
      `igdb_api_service.dart` and `game_detail_service.dart`), mirrors the
      client's existing token-fetch-and-retry-once-on-401 behaviour
      (`twitch_auth_interceptor.dart`), and takes zero external imports.
      Verified with Deno's test runner against a mocked Twitch/IGDB
      (5/5 passing) — fmt, lint and type-check all clean. Deployed to
      `questloggd-dev` through the dashboard (no CLI), secrets set, and
      smoke-tested from the real signed-in app via a temporary
      `supabase.functions.invoke('igdb-proxy', ...)` button on Settings —
      returned real game data. That button has been removed again
      (`settings_screen.dart` is back to byte-identical with before it
      was added).
- [x] Flutter client repointed [PIPELINE]. **2026-08-06.** Full pipeline
      run, `igdb-client-repoint-20260805`, **merged to `develop` at `9b5e303`**
      (fast-forward from `feature/igdb-client-repoint`). Games list, game
      detail and
      all three Featured reads now call the `igdb-proxy` function through
      `SupabaseIgdbClient` plus one API service per feature
      (`GamesApiService`, `GameDetailApiService`, `FeaturedApiService`),
      replacing the direct-to-IGDB Retrofit stack. QA PASS after one cycle —
      the only failure was a deliberate human decision (see next line), not a
      defect. Human also tested on-device: games list, search, pagination,
      game detail, all three Featured sections, offline/retry, fresh install.
- [x] IGDB credentials removed from the client build entirely. Both Twitch
      `envied` fields and constants are gone; the two Retrofit services and
      the Dio/interceptor stack are deleted from active use. One recorded
      exception, approved by the human at the QA gate:
      `TwitchAuthInterceptor` and `NetworkModule` were restored as
      `@Deprecated`, DI-unregistered, credential-free reference code (real
      values swapped for the placeholder `'REMOVED_BY_ITEM_9'`) because the
      human wants the old shape available to consult. `tech-ac.md`'s
      criteria were amended with an explicit carve-out for this; see
      A second approval from the same run, recorded nowhere else:
      `IgdbProxyConstants` was renamed `SupabaseIgdbProxyConstants` and
      `ErrorType.functionError` renamed `ErrorType.supabaseIgdbError` by
      direct human commits `8f9f9bf` and `5cd8a4f` after the Dev commit,
      with the explicit instruction that the run's `task-brief.md` and
      `code-plan.md` were not to be updated for it. Run folder
      `igdb-client-repoint-20260805` retired 2026-08-07 — run complete,
      evidence retired.
- [ ] Deployed to prod. Blocked — no prod Supabase project exists yet (0.1b,
      still deferred).

### 10 — Sentry [PIPELINE]

> Add Sentry crash reporting, initialised at app startup before `runApp`. There is a
> **single Sentry project and a single DSN** — do not read a different DSN per
> flavour. Separate dev from prod by setting Sentry's `environment` option from the
> active flavour instead, so both report into one project and can be filtered apart. Capture
> unhandled Dart errors and Flutter framework errors. Tag events with the flavour and
> the app version. Do not capture the user's email or any personally identifying
> field — the Supabase user ID alone is sufficient to correlate reports. Verify by
> triggering a deliberate test crash in dev.

- [x] Done. **2026-08-07.** Full pipeline run, `sentry-20260806` (retired
      2026-08-07 — run complete, evidence retired). QA PASS, 0 QA cycles. Dev
      commit `7adeb25`, on top of `e652d1f` / `a963c5f`; merged to `develop`
      (no PR — merged directly, no merge SHA recorded). Sentry initialises
      before `runApp` behind the single DSN, with `environment` set from the
      flavour, flavour and app-version tags, and no personally identifying
      field. Scope grew mid-run at the human's request: `talker`
      request/response/error logging around the IGDB client, and removal of the
      deprecated `PrettyDioLogger` — CRITICAL-1, resolved by the human choosing
      option A (strip it from `twitch_auth_interceptor.dart` too, then drop the
      package), with `flutter-arch.md`'s stale `network_module.dart` path fixed
      in the same pass. One approved deviation: the revised code plan covering
      that added scope. One code-review send-back before approval —
      `CrashReportingSettings` and `AppVersion` simplified from classes to
      top-level functions, the latter moved to `lib/core/utils/version_utils.dart`.
      Both manual checks confirmed on-device 2026-08-07: [10.12] Sentry delivery
      (needed `--flavor dev`, now `handover.md` gotcha #8) and [10.18] IGDB log
      lines. `TestCrash`, its `bootstrap.dart` call site and the three
      `SentryConstants.testCrash*` constants were removed afterwards, as agreed,
      once QA passed and [10.12] was confirmed.

### 10.1 — IGDB client transport: Dio + Retrofit [PIPELINE]

> Swap `SupabaseIgdbClient`'s transport from `supabase_flutter`'s `functions.invoke`
> to Dio + Retrofit, calling the `igdb-proxy` Edge Function's HTTPS URL directly.
> Motivation: Dio + Retrofit is the standard HTTP stack in the target job market,
> and this establishes the client-side pattern future external APIs (e.g. gaming
> news, OpenCritic) will reuse once they get their own Edge Functions. `dio`,
> `retrofit` and `retrofit_generator` are already direct dependencies — no new
> package.
>
> **Do not touch `supabase/functions/igdb-proxy/index.ts` or item 9's server-side
> architecture.** The Edge Function keeps hiding the Twitch client secret,
> verifying the caller's JWT (`verify_jwt`), and proxying to IGDB exactly as it
> does today — only the client's transport changes.
>
> Add a **new** Dio instance (or reuse one via DI) with `baseUrl` pointed at the
> `igdb-proxy` function URL, and a Retrofit interface for the one endpoint it
> calls. **Do not reuse `NetworkModule.getDioInstance`/`TwitchAuthInterceptor`
> as-is.** Both are `@Deprecated`, `getDioInstance`'s `baseUrl` points at IGDB
> directly (the wrong target — the client must keep going through the Edge
> Function, never IGDB), and `TwitchAuthInterceptor` is built around Twitch's
> client-credentials flow, the wrong auth mechanism for a Supabase-session-based
> interceptor. Item 10 fixed both files in place (removed `PrettyDioLogger`) on
> the understanding they'd otherwise stay untouched reference code — this item
> should not repurpose them further. **Do reuse** the timeout values —
> `ConfigConstants.connectTimeout`/`receiveTimeout`/`sendTimeout` — for the new
> Dio's `BaseOptions`; those are generic, not IGDB- or Twitch-specific.
>
> Add a Dio interceptor that reads the current Supabase session
> (`Supabase.instance.client.auth.currentSession`) and attaches
> `Authorization: Bearer <access token>` and `apikey: <anon key>` headers per
> request — the same two headers `functions.invoke` already sends for you today.
> On a 401, call `supabase.auth.refreshSession()` and retry once, mirroring the
> retry-once-on-401 pattern the Edge Function itself already uses for its Twitch
> token — GoTrue refreshes proactively in the background, so this path is a rare
> race, not the common case.
>
> `SupabaseIgdbClient`'s public signature, return type and error propagation stay
> unchanged, so its callers (`GamesApiService`, `GameDetailApiService`, the
> featured repository) need no changes and their existing tests keep passing.
>
> **`IgdbCallLog`'s fate is an open decision for this item, not pre-decided.**
> `talker_dio_logger`'s `TalkerDioLogger` Dio interceptor is a strong candidate
> to replace it once the transport is Dio — check whether it covers the 50-line
> response trim and full-stacktrace-on-error requirements out of the box before
> assuming a 1:1 drop-in. `IgdbCallLog` stays exactly as item 10 shipped it
> until this item's own BA/Tech Lead phase decides.

- [x] Done. **2026-08-07.** Full pipeline run, `igdb-transport-20260807`
      (retired 2026-08-07 — run complete, evidence retired). QA PASS, 0 QA
      cycles, no escalations. Dev commit `5385338` on base `cf3ddc6`, branch
      `claude/questloggd-item-10-1-igdb-ogvf5r`, merged to `develop`. The IGDB
      transport is now Dio + Retrofit calling the `igdb-proxy` Edge Function's
      URL directly, with a Supabase-session interceptor attaching `Authorization`
      and `apikey` per request and refreshing-and-retrying once on a 401. Four
      approved deviations: (1) `talker_dio_logger` added as a new direct
      dependency and `IgdbCallLog` deleted in favour of `TalkerDioLogger`,
      accepting the loss of the 50-line response trim and the caller stack trace;
      (2) `IgdbProxyService` renamed `SupabaseIgdbProxyService`; (3)
      `SupabaseIgdbClient` deleted outright, having become a one-line passthrough
      — `GamesApiService`, `GameDetailApiService` and `FeaturedApiService` now
      depend on `SupabaseIgdbProxyService` and their tests mock it, which
      overturns that run's own guarantee that callers and their tests needed no
      change; (4) `games_test.dart` / `game_detail_test.dart` error cases
      throw and assert `DioException` (new `mockDioException` fixture) instead of
      the now-impossible `FunctionException`. Four manual checks were never
      performed and are carried in `handover.md`, not here.

### 11 — Cleanup [PIPELINE]

> Three unrelated repository-hygiene fixes. Change no dependency version, and add
> no dependency, in this run.
>
> **1. Fix the line-ending churn on generated files.** The repository is
> `core.autocrlf=true`, so git expects CRLF in the working tree, but `build_runner`
> writes its output with LF. Every generator run therefore leaves roughly seventeen
> tracked generated files marked modified in `git status` with a completely empty
> content diff. This has already caused confusion in two pipeline runs, and the two
> Dev Agents handled it two different ways.
>
> Create a `.gitattributes` at the repository root pinning the generated Dart
> patterns to LF, so git checks them out the way `build_runner` writes them:
>
> ```
> *.g.dart        text eol=lf
> *.freezed.dart  text eol=lf
> *.gr.dart       text eol=lf
> *.config.dart   text eol=lf
> *.mocks.dart    text eol=lf
> ```
>
> Scope it to generated files only. Do **not** add a blanket `* text=auto` or
> `*.dart eol=lf` — that would renormalise every hand-written source file in the
> repository and produce an enormous, unreviewable diff.
>
> Then run `git add --renormalize .` so the index matches the new rules, and
> confirm with `git status` before and after a `dart run build_runner build
> --delete-conflicting-outputs` that the generated files no longer appear as
> modified. **The renormalisation itself is a legitimate one-time content change to
> those tracked files and belongs in this commit** — it is the fix landing, not
> churn. Say so explicitly in `diff-summary.md` so QA does not read it as scope
> creep, because it will touch files that are not otherwise part of this task.
>
> **2. Untrack the coverage report.** Add `coverage/` to `.gitignore` and untrack
> `coverage/lcov.info`, which the QA agent rewrites on every `--coverage` run.
>
> **3. Remove the incorrect `envied` TODO** in `pubspec.yaml`. `envied` obfuscates
> build-time constants while `flutter_secure_storage` holds runtime secrets on
> device — they are not substitutes and both have a role.

- [ ] `.gitattributes` created and index renormalised
- [ ] `coverage/` ignored and untracked
- [ ] `envied` TODO removed

---

## Assets needed from you

Both vendors publish brand guidelines that **expressly permit** the mark's use in a
sign-in button — that is what the assets are for. Using the official file inside the
stated rules is not infringement. Drawing an approximation is what creates risk,
which is why the spec uses dashed reserved slots rather than stand-in glyphs.

Please supply, as SVG, sized to a 20px box:

| Provider | Source | Note |
|---|---|---|
| **Discord** | Discord Brand Guidelines | The clyde mark; blurple or white |
| **Google** | Google Identity branding guidelines | Mandated clear space; may not be recoloured |
| ~~Twitch~~ | — | Login deferred (TBD). Not needed. |
| ~~Apple~~ | — | iOS deferred. When it returns, comes from the native button — never supplied, never traced. |

Not needed yet: the 88px app mark. It stays a dashed placeholder through beta, and
it is the one slot the spec permits shipping unfilled.

---

## What is NOT in week 1

Guarding against scope creep, since several of these feel adjacent:

- The component library — week 2. Only the token layer lands now.
- Library, Home, Search, Game Detail — weeks 3 and 4.
- Custom lists beyond the schema stub — deferred Pro feature.
- Light theme — deferred. Structure for it, do not build it.
- Subscriptions and RevenueCat — month 2–3. Only the nullable `tier` column now.
- Moderation and reporting — gated on user-generated content.
- The `tracker` → `library` migration — week 3, and it needs the Library design
  spec first.

---

## Open decisions that could block

- [ ] **Game Detail hero ramp hue** — flagged inline in
      `game-detail-design-conventions.md` §2. Blocks the Game Detail hero in week 3,
      not week 1.
- [ ] **Library design spec** — needed before week 3. The biggest screen, no spec,
      and the brief flags the hard part: it must work at 3 games and at 300.
- [ ] **Search design spec** — needed before week 4.
