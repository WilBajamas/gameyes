# QA Report
Source: W1-8 — `tech-ac.md` (BA Agent 1.0), as amended by `decisions.md`
DECISION-1 and DECISION-2
Date: 2026-08-05
Verified commit: 036015f0dd5bc980dd4e97277ea11d1d9f84a4ff (base
9115e36d3c4d0cf6f7c94c78c95cf9d8764a4eae, branch
claude/questloggd-week1-item8-sosqs6)

Overall result: PASS — pending manual checks

## Manual verification required

Nothing below indicates a defect. Each is behaviour that only a running app,
a real Supabase session or a device gesture can confirm; the code for each is
in place and cited under `## Acceptance criteria`.

Preparation for all checks: run the dev flavour on a device/emulator. "Clear
the seen flag" means uninstall/reinstall or clear app storage (the run never
writes `first_use`, so it can only be set by finishing onboarding).

1. [W1-8-AC01] Guard covers the five tab children.
   Signed out, seen flag `true`. Open the app, then from the sign-in screen
   attempt to reach each tab (`/featured`, `/games`, `/tracker`, `/browse`,
   `/settings`) by deep link (`adb shell am start -a android.intent.action.VIEW
   -d "questloggd://featured"` or the project's configured scheme).
   Expect: every one lands on the sign-in screen, none renders a tab.
   Why manual: the guard is declared only on the parent `/`; that it also runs
   for a child target is auto_route's parent-guard behaviour and is not
   asserted by any unit test.

2. [W1-8-AC01, W1-8-AC08] Guard covers in-app navigation, not just deep links.
   Signed in, open a game detail screen. Force a sign-out from another device
   or by expiring the session server-side.
   Expect: the screen is replaced by sign-in with no restart, and after signing
   back in you return to that same game detail screen with the same game.

3. [W1-8-AC02] `/legal` reachable while signed out.
   Signed out, on the sign-in screen, tap the terms link and then the privacy
   link.
   Expect: the legal web view opens both times; no redirect back to sign-in or
   to onboarding.

4. [W1-8-AC03] Signed-in deep link keeps its arguments.
   Signed in. Deep link to `/game-detail` for a specific game, and to
   `/tracker-detail` for a saved game.
   Expect: the correct game/tracker item is shown — title, artwork and content
   all populated, no empty or placeholder detail screen.

5. [W1-8-AC05, W1-8-AC12] Pending route survives the onboarding hop.
   Clear app storage so the seen flag is absent. Deep link to a specific
   `/game-detail`.
   Expect: welcome screen 1 appears. Complete onboarding through to the sign-in
   screen and sign in.
   Expect: you land on that same `/game-detail`, not on the tab shell.
   Why manual: the unit test for this case is a duplicate of the AC10 test and
   does not simulate the onboarding hop (see `## Coverage gaps`).

6. [W1-8-AC06] Signed-in user is not trapped in onboarding.
   Clear app storage (seen flag absent), then sign in. Kill and reopen the app
   while the session is still valid.
   Expect: the tab shell, never welcome screen 1.

7. [W1-8-AC07] Cold-start race — the one the Phase 3 gate deferred here.
   With a valid stored session, force-stop the app and cold start it several
   times (at least 5, ideally once on a cold boot and once on a slow network).
   Expect ideally: the tab shell with no visible sign-in screen.
   What to watch for: `AuthStatusListener` starts fail-closed (`false`) while
   Supabase replays the session asynchronously, so the router can resolve the
   initial route before the first emission arrives. The result would be a brief
   flash of the sign-in (or welcome) screen before `SessionNavigator` corrects
   it to the tab shell. Record whether it happens, how often, and how long it
   is visible. Correcting itself is the designed behaviour; the open question
   is whether the flash is acceptable to ship.

8. [W1-8-AC11, W1-8-AC20] Default tab after a plain sign-in.
   Signed out with no pending route (open the app normally, do not deep link).
   Sign in.
   Expect: the tab shell on the same tab it opens on today — no tab index
   change from current behaviour.

9. [W1-8-AC14] Live sign-out with no restart.
   Signed in, sitting on the tracker tab. Invalidate the session externally.
   Expect: the app moves itself to sign-in within a second or so, without being
   backgrounded or restarted. Repeat with the seen flag cleared and expect
   welcome screen 1 instead.

10. [W1-8-AC15] Back gesture after a forced return to sign-in.
    Immediately after check 9, press the system back gesture/button repeatedly.
    Expect: the app exits (or stays on sign-in); it must never re-enter the tab
    shell or the detail screen you were on.

11. [W1-8-AC16, W1-8-AC17] Launch replay does not disturb the sign-in flow.
    Signed out, sit on the sign-in screen for ~60 seconds without acting, then
    start an OAuth sign-in and let it complete.
    Expect: no flicker, no route change and no duplicated screens while
    waiting; a single clean transition on success and no redirect loop.

12. [W1-8-AC10, ASSUMPTION 10] OAuth return path — activity kill vs. resume.
    Deep link to a specific `/game-detail` while signed out, get sent to
    sign-in, then complete the OAuth round trip through the browser.
    Expect (in-place resume): the app comes back to the foreground and lands on
    that `/game-detail`.
    Expect (process killed and restarted): the pending route is in memory only,
    so it is legitimately lost and you land on the tab shell instead.
    Why manual: `android:launchMode="singleTop"`
    (`android/app/src/main/AndroidManifest.xml:10`) means Android may or may not
    kill the activity during the browser hop, and which of the two happens is
    device/memory dependent. Both outcomes are within the design (ASSUMPTION
    10), but the human should see which one users will actually get, and decide
    whether losing the deep link on the killed-activity path is acceptable.

13. [W1-8-AC19] Silent redirect.
    During checks 9 and 10, watch for any snackbar, dialog or banner.
    Expect: none — the return to sign-in is silent.

## Static analysis

Status: PASS
Errors: NONE

`dart run build_runner build --delete-conflicting-outputs` completed
successfully and left the working tree clean (`git status --short` empty), so
the committed `service_locator.config.dart`, `auto_route_config.gr.dart` and
the two `*.mocks.dart` files are current for the committed sources.

`flutter analyze`: 38 issues — 0 errors, 2 warnings, 36 info. Identical to the
`orchestrator-state.md` baseline (`0 errors, 2 warnings, 36 info (38 issues)`).
None of the 38 is in a file this run created or modified; the 2 warnings are
the pre-existing `unused_element` pair in
`lib/features/tracker/presentation/screens/task_detail_screen.dart`.

## Test results

Testing mode: `coverage`.

Status: PASS
Allowlisted test files (run with `--coverage`): 28 tests run | Passed: 28 |
Failed: 0.
Full suite: 189 tests | Passed: 176 | Failed: 13.

Failing tests: 13 failures across `test/api/games/games_test.dart`,
`test/api/game_detail/game_detail_test.dart`,
`test/cubit/games/games_bloc_test.dart`,
`test/cubit/game_detail/game_detail_cubit_test.dart`,
`test/repository/tracker/tracker_repository_test.dart` and
`test/widget_test.dart` — identical in count and file to the recorded
pre-existing set. No regression. Baseline was +148 -13 (161); the delta is
exactly the 28 new tests, all passing.

`coverage/lcov.info` was rewritten by this QA run's `--coverage` invocation.
That is QA-induced and not a scope change; the file is untracked/ignored and
`git status --short` is empty.

## Coverage gaps (coverage mode only)

- W1-8-AC12: no distinct test. `session_navigator_test.dart:82` ("should
  resume the pending route when the signed-in status arrives after the
  onboarding hop") is byte-for-byte the same scenario as the AC10 test at
  line 60 — same `/auth` default path, no onboarding step simulated. It proves
  nothing AC10 did not already prove. The underlying behaviour is structurally
  sound (`PendingRouteStore` is a `@singleton` with no route-lifecycle
  coupling, `pending_route_store.dart:7`), so this is a test-quality gap rather
  than a behaviour gap — covered by manual check 5.
- W1-8-AC01, W1-8-AC02, W1-8-AC20: no automated assertion over the route table
  itself (guard presence/absence per route, child order, `initial: true`).
  Verified by reading `auto_route_config.dart` and by diffing against the base
  commit; the runtime half is covered by manual checks 1 and 3.
- W1-8-AC13 (second half), W1-8-AC14: the `reevaluateListenable` wiring in
  `main.dart:34-36` has no test — a widget test would need the full DI graph.
  Covered by manual check 9. The listener half (one subscription, every
  emission handled, error path) is tested.
- Failure/error cases are otherwise well covered: signed-out and error
  emissions (`auth_status_listener_test.dart:43,104`), both seen-flag branches
  and pending-route overwrite (`auth_guard_test.dart:125,142,180`), and the
  three no-op branches of `SessionNavigator`
  (`session_navigator_test.dart:94,100,109`).

## Acceptance criteria

W1-8-AC01: MANUAL — `auto_route_config.dart:23` puts `_authGuard` on `/` and
lines 35, 40, 45, 50 put it on `/game-detail`, `/image-view`,
`/tracker-detail`, `/task-detail`. The four content routes are directly
guarded and covered by `auth_guard_test.dart` (which builds its match from the
real `/game-detail` config). Coverage of the five tab children rests on
auto_route evaluating the parent's guards — see manual check 1.

W1-8-AC02: PASS — `auto_route_config.dart:16-18`: `/onboarding`, `/auth` and
`/legal` are declared with no `guards:` argument; the diff against
`9115e36` shows none was added. `AuthGuard` therefore never runs for them.
Runtime confirmation in manual check 3.

W1-8-AC03: PASS — `auth_guard.dart:19-22` calls bare `resolver.next()` with no
`overrideNext`, so the resolved route and its args are untouched. Test: "should
resolve the navigation when the status is signed in"
(`auth_guard_test.dart:70`), which asserts `continueNavigation` is true and
`replaceAll` is never called.

W1-8-AC04: PASS — `auth_guard.dart:29-33`. Test: "should replace the stack with
the auth route when signed out and the seen flag is true"
(`auth_guard_test.dart:106`).

W1-8-AC05: PASS — same lines, `else const OnboardingRoute()`. Tests: "…seen
flag is absent" (`auth_guard_test.dart:125`) and "…seen flag is false"
(`auth_guard_test.dart:142`) — the `?? false` at `auth_guard.dart:30` makes
absent and false identical.

W1-8-AC06: PASS — the signed-in early return at `auth_guard.dart:19` is reached
before the flag is ever read, and `OnboardingGuard` is gone from `/`
(`auto_route_config.dart:23`; `grep` finds no remaining reference to
`OnboardingGuard` in `lib/` or `test/`). Test: `auth_guard_test.dart:70` runs
with `SharedPreferences.setMockInitialValues({})` from the shared `setUp` at
line 58 — that is exactly the signed-in + flag-absent combination.

W1-8-AC07: MANUAL — `auth_status_listener.dart:19` defaults `_signedIn` to
`false` and `isSignedIn` (line 21) is a synchronous getter, so the guard never
awaits. Test: "should report signed out when no status has been emitted yet"
(`auth_status_listener_test.dart:30`). The code is correct as written; the
cold-start race the Phase 3 gate deferred to QA needs a device — manual
check 7.

W1-8-AC08: PASS — `auth_guard.dart:26` records
`resolver.route.toPageRouteInfo()` before the redirect, which carries args,
path params and query params. Tests: "should record the requested route with
its arguments when the navigation is blocked" (`auth_guard_test.dart:161`,
asserting equality against a match built with real `GameDetailRouteArgs`) and
"should replace an earlier pending route when a second navigation is blocked"
(`auth_guard_test.dart:180`).

W1-8-AC09: PASS — two mechanisms. Allowed navigations return at
`auth_guard.dart:20-22` without touching the store — test "should not record a
pending route when the navigation is allowed" (`auth_guard_test.dart:87`). The
three open routes carry no guard at all (`auto_route_config.dart:16-18`), so
navigating to them cannot reach `remember`.

W1-8-AC10: PASS — `session_navigator.dart:26`
`_router.replaceAll([_pendingRoutesStore.take() ?? const HomeRoute()])`, and
`take()` clears in the same call (`pending_route_store.dart:12-16`). Test:
"should navigate to the pending route when a signed-in status arrives on the
auth path" (`session_navigator_test.dart:60`), which also asserts the store is
empty afterwards.

W1-8-AC11: PASS — same line, `const HomeRoute()` with no children, so
`AutoTabsRouter` keeps its own default tab. Test: "should navigate to the tab
shell when a signed-in status arrives with no pending route"
(`session_navigator_test.dart:73`). Visual confirmation of the tab index in
manual check 8.

W1-8-AC12: MANUAL — the store is an app-lifetime `@singleton`
(`pending_route_store.dart:6`) holding a plain field, with nothing that clears
it on route replacement, so it survives the onboarding hop by construction.
Its nominal test (`session_navigator_test.dart:82`) duplicates the AC10
scenario and does not exercise the hop — see `## Coverage gaps` and manual
check 5.

W1-8-AC13: PASS — `auth_status_listener.dart:23-29`: `start()` returns early if
`_subscription != null`, and the subscription is never cancelled outside
`dispose()`, which nothing calls on the singleton. Tests: "should subscribe
once when start is called twice" (`auth_status_listener_test.dart:57`) and
"should react to a later emission when several arrive" (line 64).

W1-8-AC14: MANUAL — `main.dart:34-36` passes
`reevaluateListenable: getIt<AuthStatusListener>()`, which is what makes
auto_route re-run `AuthGuard` over the live stack on each notification; the
guard's redirect branch (AC04/AC05) is the same code path and is tested. The
end-to-end "no restart" behaviour has no automated coverage — manual check 9.

W1-8-AC15: PASS — both redirect paths use `replaceAll`, never `push`:
`auth_guard.dart:31` and `session_navigator.dart:26`. Tests:
`auth_guard_test.dart:106/125/142` verify `replaceAll`, and "should replace the
stack rather than push when it navigates" (`session_navigator_test.dart:121`)
asserts `pushCalls` is empty. Physical back gesture in manual check 10.

W1-8-AC16: PASS — the three open routes carry no guard
(`auto_route_config.dart:16-18`), so a guard re-evaluation over a stack of open
routes has nothing to run; and `SessionNavigator` ignores anything that is not
signed-in (`session_navigator.dart:21`). Test: "should do nothing when a
signed-out status arrives" (`session_navigator_test.dart:94`).

W1-8-AC17: PASS — two layers. `auth_status_listener.dart:36-40` notifies only
when the value actually changes, so a replayed status produces no guard
re-evaluation at all; and `session_navigator.dart:24` returns unless the
current path is one of the three open paths, so a signed-in user already inside
the app is never moved. Tests: "should not notify listeners when the same
status is emitted again" (`auth_status_listener_test.dart:88`), "should do
nothing on a repeated signed-in status" (`session_navigator_test.dart:109`) and
"should do nothing when a signed-in status arrives on a guarded path" (line
100).

W1-8-AC18: PASS — `auth_status_listener.dart:31-35` maps only `AuthSignedIn` /
`AuthSignedOut` through an exhaustive `switch` with no `default:`, and
`onError` (line 27) is handled as signed out. The only auth dependency in the
new files is `ObserveAuthStatusUseCase`
(`auth_status_listener.dart:5`, `:14`) — no import of Supabase, session or
token types anywhere in the four new production files. Test: "should report
signed out when the stream emits an error" (`auth_status_listener_test.dart:104`).

W1-8-AC19: PASS — no snackbar, dialog or banner exists in any of the four new
files or the redirect paths, and the commit touches no `.arb` file, no
`lib/generated/`, and no UI file at all (`git show --name-status 036015f`).

W1-8-AC20: PASS — `git diff 9115e36..036015f -- lib/config/route/auto_route_config.dart`
shows only guard-related lines changing: every `path:` string is byte-identical,
the five children keep their order (`featured`, `games`, `tracker`, `browse`,
`settings`), and `initial: true` on `/` is untouched. `auto_route_config.gr.dart`
is unchanged and build_runner reproduces it identically, confirming the route
table and its generated output are consistent.

## Architectural compliance

Status: PASS
FAILs: NONE

Checked against `tdd.md`: class names (`AuthStatusListener`,
`PendingRouteStore`, `SessionNavigator`, `AuthGuard`) and file paths all match,
including the two approved renames in `code-plan.md ## Approved feedback delta`
— `AuthStatusListener` (round 1) and `_pendingRoutesStore` on **both**
`SessionNavigator` (`session_navigator.dart:15`) and `AuthGuard`
(`auth_guard.dart:15`) (round 2). All four are `@singleton`, which `tdd.md`
justifies per-criterion. Constructor injection throughout — `getIt` appears
only in `bootstrap.dart:31-32` and `main.dart:34-35`, exactly as specified, and
never inside the four classes. No new package: every import resolves to
`auto_route`, `injectable`, `shared_preferences`, `flutter/foundation` or
project code. `StorageConstants.firstUseKey` is read only
(`auth_guard.dart:30`); the sole writer in the repo remains the pre-existing
`welcome_cubit.dart:22`. Constants went into the existing `RouteConstants`
(`const.dart:70-74`), not a new class. DI graph is acyclic and wired as
designed (`service_locator.config.dart:163,300,335,342,345`). No golden test.
`onboarding_guard.dart` is deleted with no dangling reference.

WARNINGs:
- `test/cubit/auth/session_navigator_test.dart` uses a hand-written
  `_FakeAppRouter` (line 129) instead of `@GenerateMocks([AppRouter])`. This is
  the deviation recorded and **approved by the human** in
  `orchestrator-state.md ## Deviation approvals`; it is listed here only for
  completeness and is not held against the run. The fake overrides exactly
  `currentPath`, `replaceAll` and `push`, and no production code is affected.
- `diff-summary.md` does not list the two generated
  `test/cubit/auth/*_test.mocks.dart` files that the commit contains. They are
  build_runner output from allowlisted annotated sources, so they are in scope;
  the omission is a reporting nit, not a scope violation.
- Scope check against git is clean: `git show --name-status 036015f` contains
  only allowlisted files, their generated outputs, and this run's
  `diff-summary.md`. `git status --short` is empty both before and after the QA
  run. Commits `4449a5b` and `e1fd04a` on the branch touch only
  `.agents/runs/` pipeline docs, no code.

## Escalation required

NONE

---

## Manual check results — recorded 2026-08-05 by the Product Owner

9 of 13 passed on device (dev flavour, Android). **Zero failures.** The
remaining four are blocked on tooling, not on any suspected defect.

**PASSED:** 1 (partial — signed-out shell block; the per-tab deep-link half is
deferred), 3, 6, 7, 8, 11 (partial — the idle half; the completing-sign-in half
folded into 12), 12 (partial — OAuth return via activity restart).

**Check 7 passed structurally, not by luck.** `auth_repository_impl.dart:53`
yields `_statusFromSession(currentSession)` as the stream's first emission, and
`AuthStatusListener.start()` runs in `bootstrap()` before `runApp`, so the
fail-closed default is overwritten before the router evaluates any route. No
sign-in flash was observed across repeated cold starts. `[W1-8-AC07]`

**BLOCKED — no sign-out trigger exists:** checks 2, 9, 10, 13.
`SignOutUseCase` is built and unit-tested but no UI calls it. The Product Owner
revoked the user server-side and the app still opened on the tab shell — this
is **correct behaviour, not a defect**: Supabase restores `currentSession` from
local storage and trusts that JWT until its own expiry, so a server-side
revocation is only noticed at the next failed token refresh (up to an hour on
the default expiry). No `signedOut` was ever emitted, so the guard was never
exercised. A follow-up run adds a debug sign-out button; these four checks
complete against that.

**DEFERRED by the Product Owner:** the deep-link-dependent checks — 1 (per-tab
half), 4, 5, 12 (pending-route half). Android has no `VIEW` intent filter for
app routes and no `flutter_deeplinking_enabled` meta-data, so URL deep links
cannot be delivered at all today. Not an item 8 defect — the route tree
supports them, Android entry is simply not wired up. Revisit when shared links
become a real feature. Note this leaves `[W1-8-AC12]` verified by neither a
real unit test (see `## Coverage gaps`) nor a manual check.

### Defect found during check 12 — out of scope, logged not fixed

No loading indicator is shown while an OAuth sign-in is in flight.
`sign_in_cubit.dart:21-24` emits idle on `Success`, but `signInWithOAuth`
returns as soon as the **browser opens**, not when sign-in completes — so the
spinner clears on leaving the app and the user returns to a blank sign-in
screen until `SessionNavigator` moves them. Pre-existing gap in item 7's auth
screen, not a regression from this run and not covered by any W1-8 criterion.
Worth its own run.
