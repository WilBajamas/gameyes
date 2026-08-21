# Technical Design Document
Source: `.agents/week-2-task-briefs.md` Stage 2 item 2.3 — Countdown + Countdown tile
Date: 2026-08-21

## Feature summary

One countdown anatomy ships as a component-library module under `lib/widgets/countdown/`:
two public widgets (`CountdownCard`, `CountdownTile`) over one shared, module-internal
`CountdownDigitRow`, with a two-value form enum carrying the only axis that differs
(scale and surface). Every widget in the module is a `StatelessWidget` that renders a
snapshot of a `Duration?` handed in by the caller. Alongside it, one boolean —
"the countdown game's id is in the wishlisted set" — is threaded from
`FeaturedRepositoryImpl` (where the wishlisted ids are already read) through a new
domain entity, the existing use case and `CountdownReleasesState` to the card, so the
reason line stops asserting a wishlist entry that may not exist. `featured`'s countdown
section is rewired onto the new card in the same run and its four inline builders are
deleted. The cubit's 60-second tick and its `close()` cancellation are untouched.

## Layer map

C1, C2, C3, C4, C5, C6, C7: UI
C8, C9, C10, C11, C12, C13, C14: UI
C15, C16: UI (both new module and rewired section) + localisation
C17, C18: UI (featured presentation)
C19: domain + state (+ data, via C20)
C20: data (repository impl) + domain (repository interface, entity, use case)
C21: state (cubit + state class)
C22: UI (card) + state consumption in `featured_screen.dart`

## Data layer

### API contracts
None. No endpoint, query or field changes. `getCountdownGame` keeps both existing
`IGDBQueryBuilder` queries verbatim, and no datasource call is added — the wishlist
flag is derived from the `getWishlistedGames()` result already fetched at
`featured_repository_impl.dart:66` (C20).

### Models
None. No DTO changes.

### Repositories
`FeaturedRepository` (modify) — `lib/features/featured/domain/repositories/featured_repository.dart`
  - `Future<Result<GameEntity?>> getCountdownGame()` becomes
    `Future<Result<CountdownGameEntity>> getCountdownGame()`
  - every other signature unchanged; `getOutThisWeekGames` explicitly untouched (C19)
  - add `export '../entities/countdown_game_entity.dart';` beside the two existing entity exports

`FeaturedRepositoryImpl` (modify) — `lib/features/featured/data/repositories/featured_repository_impl.dart`
  - `getCountdownGame` only. `wishlistIds` changes from `List<int>` to `Set<int>`
    (`join(',')` for the query still works on a set); both the wishlist branch and the
    global-fallback branch return through **one private helper**
    `CountdownGameEntity _countdownFrom(GameEntity game, Set<int> wishlistIds)` that
    computes `wishlistIds.contains(game.id)`. One derivation site is what makes C20's
    "false on a fallback selection" structural rather than a rule two branches must
    each remember — a branch cannot hardcode a different answer without deleting the
    helper call. Per ASSUMPTION-12 the flag means set membership, not which query
    produced the game.
  - the no-selection return becomes `Success(const CountdownGameEntity(game: null, isWishlisted: false))`
  - the `catch` / `Failure(ErrorType.unknown())` branch keeps its current shape (C20)

## Domain layer

`CountdownGameEntity` (create) — `lib/features/featured/domain/entities/countdown_game_entity.dart`
  - `@freezed sealed class`, single const factory, fields `required GameEntity? game`
    and `required bool isWishlisted`. Both **required, not defaulted**: the repository
    cannot construct a selected game without stating its flag, so the flag can never be
    silently omitted at the one place it is derived.
  - This is the structural answer to "can't inherit a stale true": the game and its flag
    travel as one value from repository to cubit, so there is no intermediate signature
    through which a new game can arrive without its own flag.
  - Domain-only dependencies (`freezed` + `GameEntity`), no JSON.

`GetCountdownGameUseCase` (modify) — `lib/features/featured/domain/use_cases/get_countdown_game_use_case.dart`
  - return type becomes `Future<Result<CountdownGameEntity>>`; body still a single
    delegation to `_repository.getCountdownGame()`. Derives nothing (C20).

`GetOutThisWeekUseCase` — untouched (C19).

## State layer

`CountdownReleasesState` (modify) — `lib/features/featured/presentation/blocs/countdown_releases_state.dart`
  - one new field: `@Default(false) bool isWishlisted`. No other field changes; status
    enum unchanged.

`CountdownReleasesCubit` (modify) — `lib/features/featured/presentation/blocs/countdown_releases_cubit.dart`
  - scope unchanged (screen-level, provided in `FeaturedScreen`'s `MultiBlocProvider`).
  - `loadCountdownAndReleases`: the `Success` case now binds a `CountdownGameEntity`;
    the single success `emit` sets `countdownGame: countdown.game` and
    `isWishlisted: countdown.isWishlisted` **in the same `copyWith`**. Because there is
    exactly one success emit and it is reached by every load — including the reload
    `_updateCountdown()` triggers when the release date has passed — a reselected game
    always arrives with its own flag (C21).
  - `_updateCountdown()` and `_startTimer()` are not modified. The tick's `copyWith`
    calls name only `durationRemaining` and `isReleaseDay`, so the flag is untouched by
    construction, not by convention.
  - both `Failure` branches are not modified, so a failed load cannot raise the flag.
    A failure after a successful load keeps the previous game *and* its previous flag,
    which stays consistent because the two move together.
  - `close()` and the 60-second `Timer.periodic` are unchanged (C19).

### Snapshot vs. tick — where the boundary sits (C3, ASSUMPTION-4)

The cubit is the only clock in this feature. `CountdownReleasesCubit` computes
`durationRemaining` once per load and again every 60 seconds, and cancels its timer in
`close()`. The countdown widgets receive that `Duration?` as a plain constructor
argument and render it; a minute is the smallest unit displayed (C1), so the existing
cadence is sufficient and a second clock would only add a leak surface.

The rule that makes the component provably timer-free: **every class in
`lib/widgets/countdown/` is a `StatelessWidget`.** A `StatelessWidget` has no
lifecycle hook in which to start a `Timer`, `Ticker` or `AnimationController`, and
therefore nothing to leak past disposal. Two consequences the Dev Agent must honour:

- `ButtonPressScale` (`lib/widgets/button_press_scale.dart`) is deliberately **not**
  reused for the card tap or the Remind action — it is a `StatefulWidget` owning an
  `AnimatedScale`, which C3 reads against. Taps are handled by
  `GestureDetector(behavior: HitTestBehavior.opaque)`, which is animation-free and needs
  no `Material` ancestor. The absence of the §1.8 press-scale here is intentional, not
  an omission.
- C12's "a Remind tap does not also open the game" follows from nesting: the inner
  `GestureDetector` on the Remind action wins the gesture arena, so the card's outer
  detector does not fire.

## UI layer

### Where the two forms live, and how much they share

`lib/widgets/countdown/` — a module folder with an `enum/` subfolder, the shape items
2.1 (`game_card/`) and 2.2 (`completion_ring/`) landed on. Four files earn the folder;
`lib/widgets/` is right because §3.2 and §3.3 both name this as a library component and
the tile has no feature to belong to.

**Two sibling widgets over a shared primitive, not one widget with a variant enum.**
The precedent inside this repo is `stat_pill.dart`, which faces the identical §3.2-card
/ §3.3-glass split and answers it with `StatTile` + `StatPill` over a private
`_StatPair`. The reason it is right here too: C14 says the tile renders the digit row
and nothing else. With one widget and a variant flag, `title`, `isWishlisted`, `onTap`
and `onRemind` would all have to exist on the tile's constructor and be ignored at
runtime — C14 would then be a branch someone can regress. With two widgets, the tile
has no parameter through which a title could arrive, so C14 holds by construction. The
enum is reserved for the axis that genuinely is "sized rather than redrawn" (§3.3), the
same way `CompletionRingSize` and `GameCardSize` are used — scale and surface, nothing
behavioural.

Conversely, C6 (identical digits, labels, colon count, released and unknown behaviour
across both forms) is not left to two parallel implementations: both forms delegate to
the same `CountdownDigitRow`, which owns all three time states. Neither form can drift
because neither form contains that logic.

Public surface of the module is `CountdownCard` and `CountdownTile`. `CountdownDigitRow`
and `CountdownForm` are module-internal and are not imported from outside the folder —
the same convention `game_card/`'s footer classes follow.

### Widgets

`CountdownForm` (create) — `lib/widgets/countdown/enum/countdown_form.dart` — enum, values
`card` and `tile`, carrying `figureSize` (22 / 30, ASSUMPTION-3), `blockMinWidth`
(40 / 52) and the block's interior padding (§3.2's `5px 8px` rounded to `6px 8px` for the
card per the even-number convention; `8px 12px` for the tile per §3.3), plus
`isGlass`. Colours are not on the enum — they resolve from `context.tokens`.

`CountdownDigitRow` (create) — `lib/widgets/countdown/countdown_digit_row.dart` —
stateless — consumes `CountdownForm form`, `Duration? remaining`,
`String? releaseDateText` — no interactions. Owns all three states, chosen from the
input alone:
  - `remaining == null` → the caller's `releaseDateText` if given, otherwise the caps
    unknown-date label. No digits, no colons, no unit labels, no zero substitution (C5).
  - `remaining <= Duration.zero` → one caps released label, ink tokens only (C4).
    Released is **derived from the duration**, not passed in as a second flag, so the
    two forms cannot disagree and no caller can put the component into a state where
    digits and a released label both render.
  - otherwise → three unit blocks and two colons (C1, C2), wrapped in
    `Semantics(container: true, excludeSemantics: true, label: …)` announcing the
    remaining time as one string (C7), following `CompletionRing`'s precedent. The
    released and unknown states are a single `Text`, whose content *is* their semantics
    label — no redundant `Semantics` wrapper is added for them (C7 satisfied).
  - values are `inDays`, `inHours % 24`, `inMinutes % 60`, each `padLeft(2, '0')`, so a
    day count above 99 renders in full (C1). No seconds group exists anywhere in the module.

`_CountdownUnit` (create, private, same file) — the digit block: figure over its own
caps micro label. Card fill `ink08`, tile fill `glass32` behind `GlassSurface`
(reusing `lib/widgets/glass_surface_widget.dart` for the blur), both at `radius.xs`,
both with `blockMinWidth` as a *minimum* rather than a fixed width so long day counts grow.
Unit label is the `microLabel` token at `ink55` in both forms (C9 mandates `ink55` for the
card; matching it in the tile keeps C6's "differ only in surface treatment and type scale").

**The colon is a rendered glyph between blocks, never part of a block.** It is a sibling
`Text(':')` in the row, using the existing `countdownColon` type token — 22px in both
forms, differing only in colour (`ink12` on the card per C9, the token's own 40%
`countdownColon` colour on the tile per C13). Making it a block member would put it on
the block's own fill, which contradicts both specs, and would make "exactly two colons
for three blocks" a counting rule instead of a structural one. As a sibling, the row is
literally `[unit, colon, unit, colon, unit]`.

The row is `Row(crossAxisAlignment: CrossAxisAlignment.baseline,
textBaseline: TextBaseline.alphabetic, mainAxisSize: MainAxisSize.min)`. Baseline
alignment is how §3.2 / home §4.1's "colons sit on the digit baseline, not the caption"
is met without a magic offset: a `Column`'s baseline is its first child's, so each unit
reports its figure's baseline and the colon lands on it at either figure size.
`MainAxisSize.min` is the sanctioned hug-content case from the `flutter-widgets` skill —
the digit group sizes to its own content and is aligned by the card's column, so neither
`Expanded` nor `Flexible` applies here. Flagged rather than swapped.

**A missing segment is not a case.** In the counting state all three groups always
render, zero-padded — a zero day count shows `00 DAYS`, it is never dropped. The group
is all-or-nothing: released and unknown remove all three blocks, both colons and all
three labels together (C2, C4, C5). There is no partial row.

`CountdownCard` (create) — `lib/widgets/countdown/countdown_card.dart` — stateless —
consumes `String title`, `bool isWishlisted`, `Duration? remaining`,
`String? releaseDateText`, `VoidCallback onOpen`, `VoidCallback? onRemind` —
interactions: whole-card tap → `onOpen` (C12); Remind tap → `onRemind` (C11).
Anatomy top to bottom: reason line, title, `CountdownDigitRow(form: card)`, Remind.
  - Surface: flat `surfaceRaised` fill at `radius.lg` via `DecoratedBox`. No `Card`, no
    `elevation`, no gradient (C8, ASSUMPTION-1). Interior padding only; the widget adds
    no spacing around itself.
  - Reason line: **the copy is owned by the component and selected by `isWishlisted`
    alone** — wishlisted renders an outline bookmark glyph plus the cyan
    `accentLinkCyan` line; not-wishlisted renders one neutral `ink55` line, no glyph, no
    cyan (C10). Owning the two strings here is what makes C22's "cases (b) and (c) are
    byte-identical" structural: there is one non-wishlist string and no input by which a
    caller could vary it. The card takes no library-membership input at all, so C22's
    "never re-derives it from `localLibraryGameIds`" is unrepresentable rather than
    merely unwritten.
  - Title: `cardHeading` token, uppercased. §4.1 asks for 20px caps; 22 is the existing
    token step and even, and no caps token exists at this size — adding one would mean
    editing the shared `AppTypeTokens`, which is out of scope for this run.
  - Remind: renders only when `onRemind != null` (C11, ASSUMPTION-11), `ink12` fill at
    `radius.xs`, label paired with an outline bell glyph, minimum 44px hit target via a
    `BoxConstraints(minHeight: 44)`, never green.
  - No cover thumbnail and no `Icons.videogame_asset` fallback (ASSUMPTION-2 /
    DECISION-2). No right-aligned date-platform meta line — no criterion asks for one.

`CountdownTile` (create) — `lib/widgets/countdown/countdown_tile.dart` — stateless —
consumes `Duration? remaining`, `String? releaseDateText` — no interactions. Renders
`CountdownDigitRow(form: tile)` and nothing else (C14). Ships with no caller
(ASSUMPTION-10), exercised by its test only.

`CountdownReleasesWidget` (modify) — `lib/features/featured/presentation/widgets/countdown_releases.dart`
  - `_buildCountdownCard`, `_buildCelebrationState`, `_buildTimerBlocks`, `_buildTimeBox`
    and the `// TODO: Refactor this` at line 7 are deleted; the countdown slot renders
    `CountdownCard` (C17). No comments remain in the file (widget convention).
  - Constructor: gains `bool isWishlisted`; **loses `bool isReleaseDay`**, which the card
    no longer needs because released is derived from the duration. `localLibraryGameIds`
    stays, read only by `_buildReleasesList` for the rail's owned marker (C22).
  - Passes `title: game.name`, `remaining: durationRemaining`,
    `releaseDateText: game.releaseDates?.firstOrNull?.human` (null now means the
    unknown-date label, replacing today's `emptyStringPlaceholder`),
    `onOpen: () => onGameClick(...)`, and no `onRemind` — so no Remind renders this run.
  - The rail, its heading, the "no releases" box and the section's collapse condition are
    not touched (C18).

### Screens

`FeaturedScreen` (modify) — `lib/features/featured/presentation/screens/featured_screen.dart` —
stateless shell over `FeaturedView`; only `_RightNowSection`'s two
`CountdownReleasesWidget` call sites change: pass `isWishlisted: state.isWishlisted`
(real path) and `isWishlisted: false` (`Skeletonizer` path), drop `isReleaseDay`. The
reactive boundary stays exactly where it is — the existing nested `BlocBuilder`s on
`LibraryStatsCubit` and `CountdownReleasesCubit` inside `_RightNowSection`. Loading,
failure and empty-collapse paths are untouched (C18).

## Reuse decisions

- `GlassSurface` (`lib/widgets/glass_surface_widget.dart`) — the tile's fill + blur;
  same use as `ContextChip` and `StatPill`. No second blur implementation (C13).
- `AppColorTokens` / `AppTypeTokens` / `AppRadiusTokens` via `context.tokens` — every
  colour, size and radius. `countdownFigure` and `countdownColon` already exist and
  match the tile form (ASSUMPTION-3); the card's steps come from `copyWith` on the same
  tokens. **No new colour or type token is added** — that would edit shared theme
  classes and their tests, which is a shared-mechanism change, not this run's business (C16).
- `CountdownReleasesCubit`'s existing timer, release-date resolution and
  coming-soon-label logic — reused as-is; the widgets add no clock (C3, C19).
- `_localDatasource.getWishlistedGames()`'s existing single call in `getCountdownGame` —
  reused for the flag; no extra read (C20).
- Existing l10n keys: none of the new strings fit. `reminder` ("Reminder") is a noun and
  §4.1 specifies the verb "Remind", so a `remind` key is added instead; ASSUMPTION-6
  offered these keys for reuse, it did not require it.
- `ButtonPressScale`, `PrimaryButton`, `ActionRow` — deliberately not reused; see the
  C3 note above (press-scale animation) and §3.2 (Remind is a small `ink12` `radius.xs`
  control, not a 52px full-width row).

## Out of scope

- Reminder scheduling, wishlisting from the card, the out-this-week rail's anatomy, the
  countdown section's failure card, wiring the tile, and pixel verification — per
  `tech-ac.md ## Out of scope`.
- `_buildReleasesList` stays a `Widget`-returning method, and the section's hardcoded
  English headings (`Next Release Countdown`, `Out This Week`, `No releases in this
  period`) stay unlocalised. Both are pre-existing debt in a file this run only
  partially reworks; no criterion covers them and C18 requires the rail to behave as it
  does today. Raise separately.
- Relocating `test/features/featured/**` unit tests to the layer-based `test/use_case/`
  and `test/cubit/` paths. They are edited in place because this run's signature change
  forces it; moving them is unrelated churn.
- Any change to `AppColorTokens` / `AppTypeTokens`, and the `welcome_to_gameyes` emoji.

## Open questions

None.
