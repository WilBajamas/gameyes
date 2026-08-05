# QuestLoggd — Deferred Roadmap

Everything consciously put aside, and why. This is the counterpart to the build
plan: if something was discussed and is *not* being built now, it is recorded here
rather than lost.

Written 2026-07-30. Update when an item ships, or when a TBD resolves.

**Status legend**

| Marker | Meaning |
|---|---|
| **PLANNED** | Committed. Will be built. Timing stated. |
| **TBD** | Genuinely undecided. Needs a decision before it can be planned. |
| **RULED OUT** | Decided against, with reasoning. Reopen only if the premise changes. |

---

## 1. Features

### Stats / Insights — PLANNED, post-beta (week 5–6)
Owns the fourth tab. Deliberately *not* in the launch build: the product brief
states "Stats with no data are meaningless", and every launch-day user has zero
games. It earns the tab; it does not earn the launch. Ships once beta users have
generated data worth aggregating.

### Year in Review — PLANNED, timing TBD
The anchor feature of the Pro tier and the highest-shareability asset in the
product. Seasonal by nature, so its ship date is driven by the calendar rather
than the roadmap. Design it as a standalone shareable artefact, not a page.

### Feed / Community — TBD
Explicitly undecided. The case against shipping it early: a social feed with no
follows is dead, and on launch day there is no follow graph to populate it. It is
also the most expensive surface on the list — follow graph, fan-out reads,
moderation tooling, report and block flows, content takedown. Revisit when there
is a reason for users to follow each other.

**Blocks:** moderation and reporting (§4), Profile-as-a-tab (below).

### Profile as a navigation tab — PLANNED, gated on Feed
Without Feed there is no one to view a profile, so Profile collapses to Settings
plus a Stats summary — not a tab's worth of value. The product brief independently
warns it "overlaps heavily with Library and Stats". Returns if and when Feed does.

Launch navigation is **Home · Library · Search**, with Stats added as the fourth
tab post-beta. Five tabs is a ceiling, not a target.

### Custom lists — PLANNED, Pro feature
Free tier gets 3; Pro gets unlimited. Out of v1 because it is Pro-adjacent and
Library is already the largest screen in the build.

### Bulk edit — PLANNED, Pro feature
Power feature. The brief notes it must be discoverable without cluttering the
default view — a design problem worth solving properly rather than quickly.

### Steam / PSN library import — TBD
The brief calls it "transformative for cold start" but "a large technical scope",
and both are true. Design the entry point now assuming it exists later; build
nothing. Reopen once there is evidence cold start is the retention problem.

### Notification centre — PLANNED, low priority
Release reminders, social activity, weekly digest, read-state management. The
brief says standard patterns are acceptable here — do not over-invest.

Note the *permission prompt* is a separate product decision and is not deferred:
never prompt at launch, prompt the first time a user wishlists an unreleased game.

### Settings, full build — PLANNED, low priority
Currently a 59-line stub. Needs account, privacy, notification preferences,
appearance, defaults, connected accounts, data export, regional, about, support.
Account deletion is **not** deferred — see §4.

### Supabase `prod` project — PLANNED, blocked on account limits
Deferred 2026-07-30. Only `questloggd-dev` exists; the free plan's project cap was
already reached.

Not urgent — nothing publishes until beta, and every week 1–3 item runs against dev.
The `prod` flavour ships with placeholder env values until the project exists, which
is exactly the shape the flavours run was built for.

**When creating it, do not skip:** its own redirect URL
(`com.questloggd.app://login-callback`, and **only** that one — never the dev
scheme), its own provider credentials, and the full schema + RLS migration applied
from the same migration files as dev, so the two cannot drift.

Possible workaround worth checking before paying: the free project cap is applied
per organisation, so a second Supabase organisation may allow another free project.
Verify against current Supabase terms rather than assuming.

### Google Cloud OAuth client — ✅ RESOLVED 2026-08-05
Was deferred 2026-07-30 on Google Cloud project quota. The quota issue was
resolved, the OAuth client created, and the credentials pasted into Supabase
dev — no code change required, as the note below predicted. Discord was set up
in the same pass. Both providers are live on `questloggd-dev` and were verified
on device during week 1 item 8's manual checks. **Dev only** — prod has no
Supabase project yet (see 0.1b, still deferred).

The original note is kept below for the reasoning it records.

**Blocks Google as a login provider only.** Discord is unaffected, so auth work can
proceed with one provider and Google can be enabled later by pasting credentials
into the Supabase dashboard — no code change, because the provider abstraction in
week 1 item 5 is specified to take additional providers without reshaping.

Outstanding when unblocked: OAuth consent screen (External; scopes `email` and
`profile` only), then a **Web application** client — not Android, because v1 uses
the browser OAuth flow — with both Supabase callback URLs as authorised redirects.

### iOS as a platform — PLANNED, blocked on hardware
Deferred 2026-07-30. **v1 ships Android only.**

Not a product decision — a resourcing one. Flutter's iOS toolchain requires Xcode,
which is macOS-only, and there is no Mac and no iPhone on this project. iOS builds
cannot be produced, run, or verified.

**Unblocking options, cheapest first:**

| Option | Cost | Trade-off |
|---|---|---|
| Cloud CI (Codemagic, GitHub Actions macOS runners) | Free tier ≈500 min/mo | Works, but every iOS issue becomes a push-wait-download cycle. No local simulator. |
| Rented Mac (MacinCloud, MacStadium) | ~$20–30/mo | Full Xcode over remote desktop; unpleasant for sustained work |
| Mac mini M4 | ~$599 one-off | The real answer if iOS matters. Best bought once the product is proven. |

Note **cloud CI alone is not sufficient here**, because there is no iPhone to test
TestFlight builds on. Shipping iOS needs a build path *and* a test device.

Android-first is also the cheaper launch on its own merits: Play review takes hours
against Apple's days, and $25 once against $99/year.

**What returns with iOS:** Sign in with Apple (§5a of the auth spec is written and
parked), an iOS client ID for Google OAuth, Apple Developer enrolment, App Store
compliance review, and the platform-parity acceptance criteria that
`project-conventions.md` currently forbids agents from writing.

### Sign in with Apple — PLANNED, gated on iOS
Required by App Store Review Guideline 4.8 wherever third-party social login is the
primary account mechanism. No Play Store equivalent, so it is not needed while the
app is Android-only.

Fully specified and parked at `onboarding-auth-design-spec.md` §5a, including the
consequence that matters: Apple's HIG requires its button be **at least as prominent
as** any other sign-in option, so Discord loses its status as the sole filled button
when Apple returns. The auth repository interface is specified to take further
providers without reshaping, so the reversal is cheap.

### Twitch as a login provider — TBD
Deferred 2026-07-30. v1 ships Apple, Discord and Google.

Briefly retained on the belief that IGDB required it. It does not. **IGDB
authenticates through Twitch's *developer* OAuth using a server-to-server Client ID
and Secret, which has nothing to do with end-user Twitch login** — and that
credential moves entirely server-side once the IGDB Edge Function proxy lands. The
Twitch developer app is still required for the API credential; the login row is not.

If it returns it takes Google's quiet row treatment, and the Android screen goes to
three rows. The auth repository interface is specified so a fourth provider slots in
without reshaping it, so the cost of reversing this is small.

Worth reopening if Twitch-specific features ever ship — "what you're streaming",
clip embeds — where the login would carry value beyond identity.

### Onboarding welcome carousel — PLANNED, v1-adjacent
Two to three slides maximum. Auth itself is week 1 and not deferred; the carousel
around it can land later. Genre and platform preferences happen inside the app
after entry, never before.

### Offline mode — TBD
Out of scope per the product brief's own constraints. Design assumes connectivity
with inline per-section error states. Note this decision is what makes Postgres
the right backend — Firestore's offline sync was its main advantage and we have
declined it.

### Tablet layouts — TBD
Mobile-first, no tablet-specific layouts this phase, per the brief.

---

## 2. Design system

### Canvas token conflict — **RESOLVED 2026-07-30: onyx `#23272a`**
`system-foundation-specs.md` won; the indigo `#0a0d3a` canvas is a marketing surface.
Both screen docs were updated, and derived values recomputed rather than
find-and-replaced:

- Home canvas → `#23272a`
- Home tab-bar chrome → `#2e3236` (was `#23272a`, which would now be identical to
  the canvas and destroy the stated separation mechanism)
- Home now-playing cover veil lower stop → `rgba(35,39,42,.6)`
- Game Detail canvas → `#23272a`

`#0a0d3a` survives correctly as the proposed **light-theme ink** colour in both
docs. Those references are not errors.

**One derived item still open:** the Game Detail hero's three-stop legibility ramp.
Its rationale — "indigo-tinted rather than black, so the art is pushed toward the
canvas hue instead of being greyed out" — self-contradicts under an onyx canvas,
because onyx is near-neutral grey. Options and a recommendation are flagged inline
in `game-detail-design-conventions.md` §2. Needs a design call before the hero is
built; does not block token work.

### Light theme — PLANNED, deferred past v1
No tokens exist in the design system. The standing proposal is canvas `#f2f2f8`,
white cards, ink `#0a0d3a` with `#333` secondary, accents unchanged — not locked.
Dark is the default and the priority per the brief. **Structure the Flutter theme
layer so adding light later is not a rewrite**, but ship dark only.

### Icons — PLANNED, cheap
Currently the design system's flagged Lucide substitution, inlined. Replacing them
with a real set touches one file.

### Status chip hues — **RESOLVED 2026-07-30**
On hold is violet `#7d4ee0`; Wishlist is link cyan `#00b0f4`. The 55%-ink fallback
for Wishlist is withdrawn. Violet remains status-only and is never a surface.
Remaining work is promotion into the design system's own tokens, alongside the
error ramp.

### Error ramp promotion — PLANNED
The error ramp is defined locally in the component brief rather than in the design
system. As that doc admits, a second product on the same system would invent a
different red. Promote the tokens upstream.

### Platform marks — DECIDED, no work
Render as text abbreviations (PS5, XSX, PC, NSW) rather than reproducing
third-party trademarks.

---

## 3. Monetization

### Pro subscription (freemium) — PLANNED, month 2–3
Not in the product brief; designed 2026-07-30.

**Governing rule: never gate the core loop.** Free users get unlimited library,
all six statuses, search, and game detail. Gate depth, never capacity. Capping
library size makes the product worse at its only job and caps the data that makes
Stats worth paying for.

| Free | Pro |
|---|---|
| Unlimited library, all statuses | Full Stats suite, historical trends |
| Basic stats (totals, completion rate) | **Year in Review** export |
| 3 custom lists | Unlimited custom lists |
| Standard profile | Profile themes, pinned-favourite layouts |
| Search, Game Detail, add-to-library | Bulk edit, data export, advanced filters |

Indicative pricing: $2–3/month, $15–20/year, plus a ~$25 lifetime option. Lifetime
converts well for indie utility apps — it is a trust purchase as much as a value
one, hedging the "will a solo dev still be here in two years" objection.

**Deliberately not in the launch window.** IAP means StoreKit and Play Billing,
receipt validation, entitlement sync, restore-purchases, subscription lifecycle
edge cases, and heavier store review — a week minimum, spent monetizing a product
with no users.

### RevenueCat — PLANNED, ships with the Pro tier
Abstracts both stores, handles receipt validation and restore. Free below roughly
$2.5k/month revenue. Raw StoreKit is a well-documented multi-week tar pit.

### Lifetime tier — TBD
Priced above, but whether to offer it at launch of Pro or hold it as a later
conversion lever is undecided.

### Entitlement column — **NOT DEFERRED, do in week 1**
A nullable tier column on the user row costs nothing now and avoids a migration on
a live user table later. Listed here only so the dependency is visible.

### Advertising — RULED OUT
Contradicts the product's own first principle, "Personal beats popular" — an
interstitial between a user and their own collection is hostile to the entire
premise. The economics also do not work: the target user "checks in a few times a
week", so inventory is small and the revenue would not cover the damage.

---

## 4. Security, infrastructure, compliance

### Moderation and reporting — PLANNED, gated on user-generated content
The moment users can write reviews or set a profile bio, both Apple and Google
require report, block, and content-takedown mechanisms. **This is a store
rejection, not a nice-to-have.** It is also the strongest practical argument for
holding Feed: no UGC, no moderation obligation.

### Account deletion — **NOT DEFERRED, week 1 schema work**
Both stores mandate in-app account deletion for any app with accounts. Cheap if
the schema cascades from day one, painful retrofitted. Listed here only so the
dependency is visible.

### Biometric auth — TBD, probably never
Gate the decision on: what does an attacker with an unlocked phone actually get?
Today, someone's backlog. Revisit only if DMs or payment data ever ship.

### Jailbreak / root detection — RULED OUT
Not merely overkill — net negative. Trivially bypassed by anyone motivated, while
producing false positives that lock out legitimate users on modified-but-benign
devices. Adds a support burden to deter an attacker who gains nothing.

### Certificate pinning — RULED OUT
Certificate rotation silently bricks every installed build. No threat model here
justifies that operational risk. Plain TLS is free and automatic on both Supabase
and IGDB.

### Code obfuscation — NOT DEFERRED, do at launch
`--obfuscate --split-debug-info`. Two flags, free, no downside. Understand it as
deterrence rather than security — anything the client holds is extractable.

### OTA updates / Shorebird — RULED OUT
Costs money and solves a problem this app does not have: content changes arrive
from the API, not from a new binary.

### Staging environment — RULED OUT for now
Two flavours only, `dev` and `prod`, each with its own Supabase project, bundle ID
suffix and app icon. A third environment is a third thing to keep in sync for no
benefit at solo scale.

### Fastlane — TBD
Manual store uploads are fine well past launch. Revisit when release frequency
makes the setup cost worth it.

### Data-at-rest encryption — mostly RULED OUT
The Isar cache holds public game metadata and needs nothing. The one real item is
the session token, which the Supabase SDK should store in Keychain/Keystore —
verify it does, and that is the whole task.

---

## 5. Pipeline improvements

Findings from the first end-to-end `/orchestrate` run (2026-07-29/30) that were
recorded but not acted on. Fixed items are not listed.

### BA CRITICAL downgrade rule — TBD
The BA agent downgraded a spec-designated CRITICAL ambiguity (persistence scope:
per-user / per-device / per-account) to an assumption on its own initiative. Its
reasoning was correct — the codebase has no auth concept — but an agent relaxing
its own blocking gate should do so under a stated rule rather than judgment.

**Note this specific case expires the moment accounts ship.** Once there are user
accounts, per-user vs per-device stops being a non-question.

### BA testability awareness — TBD
The BA wrote 3 of 13 criteria that no permitted test could verify (force-quit,
iOS/Android parity, cold restart), because project conventions forbid integration
tests. Not wrong — they became the manual checklist — but the BA has no notion of
which criteria are falsifiable and which are not.

### fvm vs bare commands — PLANNED
The project pins Flutter 3.41.4 via `.fvmrc` and `.vscode/tasks.json` uses `fvm`,
but all five skills say bare `dart` / `flutter`. Harmless only while the system SDK
matches. Complication: `fvm` is on the PATH in PowerShell but not Git Bash, so
prefixing pins agents to one shell.

### Untested pipeline paths — PLANNED, next run
Never exercised end to end: the **escalation path** (write, route, clear), the **QA
FAIL route**, the **two-cycle retry cap**, and the **Phase 4B code review gate**,
which was added after the run. Feature B in the handover ("clear all filters",
needs a new string) forces the l10n escalation and is the natural way to test the
first three.

### Skills and references are git-ignored — TBD
`.agents/` and `.claude/` are both in `.gitignore`, so a fresh clone gets neither
the pipeline nor the reference docs — **including this file and the product
brief**. Fine for solo work; blocking the moment anyone else touches the repo.

---

## 6. Repo debt

### 11 pre-existing test failures — PLANNED
Fail on a clean checkout of `develop` and always have: `test/api/games/`,
`test/api/game_detail/`, `test/cubit/games/`, `test/cubit/game_detail/`,
`test/repository/tracker/`, and the stock `test/widget_test.dart`. Baseline is
`+29 -11`. The pipeline now records this baseline so it cannot mislead an agent,
but the failures are still real and worth fixing.

### `test/features/featured/` violates the layout convention — PLANNED
Tests group by layer, never mirrored from `lib/`. This folder came from the
original featured_revamp build and was moved rather than restructured. Do not copy
the shape; restructure it when the featured/Home work happens.

### Line-ending churn — PLANNED, scheduled into week 1 item 11
`core.autocrlf=true`, so git expects CRLF in the working tree while `build_runner`
writes LF. Every generator run leaves ~17 tracked generated files marked modified
with an empty content diff.

Confirmed a real cost, not cosmetic: it confused both pipeline runs, and the two
Dev Agents resolved it two different ways because no skill says which is right.

Fix specified in `week-1-task-briefs.md` item 11 — a `.gitattributes` pinning only
the generated Dart patterns (`*.g.dart`, `*.freezed.dart`, `*.gr.dart`,
`*.config.dart`, `*.mocks.dart`) to `eol=lf`, plus a one-time
`git add --renormalize .`. Deliberately **not** a blanket `* text=auto`, which
would renormalise every hand-written file in the repo.

### `coverage/lcov.info` is tracked — PLANNED, trivial
QA's `--coverage` run dirties it every time. The QA skill now reports it rather
than tripping on it; gitignoring the folder is the real fix.

### Dead `featured_revamp` l10n getter — PLANNED, self-resolving
`lib/generated/l10n.dart` and `messages_*.dart` still carry it. Harmless; it
disappears on the next IDE regeneration.

### Incorrect `envied` TODO — PLANNED, delete it
`pubspec.yaml` reads `envied: ^1.3.4 # TODO: To deprecate this package and use
flutter_secure_storage`. These are not substitutes. `envied` obfuscates build-time
constants (the IGDB client secret); `flutter_secure_storage` holds runtime secrets
on device (the user's session token). Both are wanted, for different jobs.

**Better still:** proxy IGDB through a Supabase Edge Function so the client never
holds the credential at all. That deletes the key-extraction problem, centralises
caching, and stops per-user rate limiting. Roughly a day of work — and it is
week-1 scope, not deferred.

---

### Email + password sign-in, and switching accounts — RAISED 2026-08-05, not scheduled
Found by the Product Owner while testing week 1 item 8's sign-out.

**There is no way to sign in as a different account.** Discord and Google both
sign you straight back into whichever account the provider has active, without
ever asking for credentials, so a sign-out followed by a sign-in returns the
same user. Nothing in the app can force the provider to prompt.

Two consequences worth knowing now:

- **Multi-account testing is not possible** with the current providers alone.
  Anything needing two real accounts — the cross-account RLS denial check in
  week 1 item 3, for one — cannot be verified without a second device, a second
  browser profile, or signing out of the provider itself at OS level.
- **Email + password auth is likely needed**, and sooner than "some day". It is
  the only sign-in method the app can fully control, and the natural fix for
  both account switching and test-account creation.

Not scheduled and not costed. Deliberately not folded into week 1 — it is a new
provider with its own screens, validation, password reset and email
verification, none of which the current auth work covers. Note that
`sign_in_provider.dart` and the repository were built to take extra providers
without reshaping, so the data/domain side should absorb it cheaply; the
presentation side is the real work.

An interim option if only provider prompting is wanted: Supabase's OAuth calls
accept query parameters that ask the provider to re-prompt for an account
(`prompt=select_account` for Google, `prompt=consent` for Discord). Cheaper than
a new provider and worth testing before committing to email/password.

### Sign-out UI/UX — PROVISIONAL, needs a real design pass
Shipped 2026-08-05 in run `debug-sign-out-20260805` so that four of week 1 item
8's manual checks could be run at all. **The component is deliberately kept, the
visual design is not signed off.** It reuses the sign-in provider row's anatomy
(52px, `surfaceRaised`, `radius.sm`, centred label) because that was the only
precedent available, and Settings has no design spec of its own. Placement,
wording, whether a confirmation step is wanted, and whether sign-out belongs in
a grouped account section are all open. Revisit when Settings gets a real spec.
