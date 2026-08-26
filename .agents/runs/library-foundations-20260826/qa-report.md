# QA Report
Source: `tech-ac.md` — Week 3 item 3.1 (D1–D5, `orchestrator-state.md`)
Date: 2026-08-26

Overall result: PASS

Verified against the working tree at `e1ada3a02004bcdf45ec430a0688216a1a3c4b23`
(`ce354fe` on top touches only run-record bookkeeping — `diff-summary.md` and
`orchestrator-state.md`; no source, no tests).

20 live criteria checked. `3.1-AC6` – `3.1-AC9` are retired by D5
(`tech-ac.md ## Retired criteria`) and were not checked.

## Manual verification required
NONE — and this is a finding, not an omission. The item changes no widget and no
screen; both tokens are minted unused (`tdd.md ## UI layer`), so nothing renders
differently and there is nothing to open. Adding a manual check here would mean
inventing a screen this item does not touch. The visual read of the two fills
belongs to the later items that consume them (Library §5 cover placeholder, §11
recruit card), not to this one. Nothing is added to `manual-check-backlog.md`.

## Scope check (git, not `diff-summary.md`)
`git diff --name-only ab586dc..e1ada3a` — 13 files: the 6 allowlisted source/doc
files, plus 7 pipeline artifacts inside the run folder. No file outside the
allowlist. `git diff --name-only ab586dc..HEAD -- test/` is **empty** — no test
file changed anywhere, confirming D5 (`3.1-AC23`).

`git status --short` shows one uncommitted file:
`.agents/runs/library-foundations-20260826/orchestrator-state.md` — the Phase
CODE_REVIEW→QA advance plus the deviation-approval and code-review lines. Run
bookkeeping, not source; reported for completeness, not blocking.

`diff-summary.md`'s file list matches git exactly. No undeclared file.

Deviations: none claimed, none found; `## Deviation approvals` reads
"NONE — Dev reported no deviations".

## Static analysis
Status: PASS
Errors: NONE

`build_runner` not run — correctly N/A. `app_color_tokens.dart` carries no
`part` directive and no annotation, and the allowlist contains no generated
file, so there is no generated output to be stale.

`flutter analyze` — **30 issues, 0 errors, 2 warnings, 28 info**, matching
`Analyzer baseline` exactly. Zero findings of any severity attributed to
`app_color_tokens.dart`. The 2 warnings are the pre-existing deliberate
`_TaskReminder` pair (`task_detail_screen.dart:201`, `:204`) and were correctly
left alone — a count of 28 would have been the regression.

## Test results
Status: SKIPPED (testing-mode: none)

No test file created or modified, per D5 and `task-brief.md ## Testing mode`.

The suite was still run to verify `3.1-AC23`: **+361 -10**, matching `Test
baseline` exactly. The 10 failures are the recorded pre-existing set and
nothing else — `tracker_repository_test.dart` (4),
`game_detail_cubit_test.dart` (3), `games_bloc_test.dart` (3). All are outside
the allowlist; no regression, no new failure, no added test.

## Coverage gaps (coverage mode only)
N/A — mode is `none`. The accepted gap is on record: `surfaceArt` and
`surfaceArtDeep` ship with zero test coverage by human decision D5.

## Acceptance criteria

### Colour tokens — verified by source read, not by the suite
Per `tech-ac.md ### Colour tokens` and `tdd.md ### 3.1-AC4 has no runtime check
behind it`, these five were checked by reading
`lib/config/theme/tokens/app_color_tokens.dart` and the commit diff directly. A
green suite is not evidence for any of them.

3.1-AC1: PASS — `app_color_tokens.dart:66` (`final Color surfaceArt`, last of
the `// ** Surfaces` group) and `:117` (`surfaceArt: Color(0xFF2F3782)` in
`dark`). Matches `surfaceIndigoPanel` at `:113` as D2 requires.
3.1-AC2: PASS — `:67` (`final Color surfaceArtDeep`) and `:118`
(`surfaceArtDeep: Color(0xFF7D4EE0)`). Same value as `_statusViolet` at `:11`,
written as an inline literal rather than bound to that const, per `tdd.md`'s
reuse decision.
3.1-AC3: PASS — both fields are `final Color`. Grep for `Gradient`, `List<Color>`
and any stop list across the file returns nothing; every member of the class
remains a `Color` or an existing token group.
3.1-AC4: PASS — verified by reading both bodies, independently of
`diff-summary.md`'s claim.
  - `copyWith` params `:187-188` (`Color? surfaceArt`, `Color? surfaceArtDeep`);
    return block `:225-226` — `surfaceArt: surfaceArt ?? this.surfaceArt,` and
    `surfaceArtDeep: surfaceArtDeep ?? this.surfaceArtDeep,`, the same
    `x ?? this.x` form as `surfaceToast` above them.
  - `lerp` `:274-275` — `surfaceArt: Color.lerp(a.surfaceArt, b.surfaceArt, t)!,`
    and `surfaceArtDeep: Color.lerp(a.surfaceArtDeep, b.surfaceArtDeep, t)!,`,
    the same `Color.lerp(a.x, b.x, t)!` form as their neighbours.
  - Both are `required` constructor params at `:27-28`.
  All five sites carry both fields in the same relative position (immediately
  after `surfaceToast`). Neither failure case is live: no field is missing from
  `lerp` and none from `copyWith`.
3.1-AC5: PASS — the commit diff for this file is **insertion-only**: six hunks,
twelve added lines, zero deletions and zero modified lines. `statusViolet`,
`surfaceIndigoPanel` and `AppStatusTokens` (including `playing`) are untouched.
No comment was added, as `task-brief.md` requires.

### `system-foundation-specs.md`
3.1-AC10: PASS — `:209-212`, a two-row table giving `--surface-art` `#2f3782`
and `--surface-art-deep` `#7d4ee0`, each stated as a flat fill with its role
stated separately (cover stand-in §5 / empty-state card §11), opened at `:206`
by "**not a pair and not a ramp** — each has one role, and neither is derived
from the other". The pair/ramp reading D3 closed is explicitly excluded.
3.1-AC11: PASS — rule 4 at `:181-184`. Keeps "No fourth loud accent"
("Indigo, magenta and cyan are the set"), records violet ratified as a surface
"2026-08-26 ... in exactly one place — `--surface-art-deep` — and nowhere else",
points at §2.2 for the reason instead of restating it, and notes violet as a
status hue is still §7.1's open decision. The "not a UI colour until ratified"
clause is gone.
3.1-AC12: PASS — §7.1 at `:349-353`. "never a surface" no longer appears
anywhere in the file; replaced by the dated carve-out cross-referencing §2.2,
with "whether it stays a *status hue* ... is still open" preserved. Options
`1a`/`1b`/`1c` survive untouched at `:358-359`, so the open decision was not
accidentally closed.
3.1-AC12a: PASS — `:214-220`, the "**Why violet is admissible as a surface
here**" paragraph: rule 4 bars violet as an accent competing for attention on
small repeated interactive parts, and `--surface-art-deep` is "one large flat
block, non-interactive, on one empty state, carrying no status or action
meaning". Closes by naming itself the paragraph to change if the carve-out is
withdrawn. This is the sole place in the repo that reason exists, as D5 leaves
it — and it is present.
3.1-AC13: PASS — register row `:334` now reads
`` `--surface-art` `#2f3782` / `--surface-art-deep` `#7d4ee0` `` with "Flat
fills (§2.2)"; rule 7 at `:188` now points at `(§6)`, not `(§5)`. Register line
327 (violet/cyan as status *dots*) left standing as required.
3.1-AC14: PASS — §3.2 Game card `:250`: "Covers carry an indigo→canvas scrim" —
the 50% desaturation is gone, the scrim survives. §3.3 Cover tile `:269`:
"Image with a flat indigo wash" — `saturate(.5) contrast(1.05)` is gone, the
flat indigo wash survives.

### `library-design-conventions.md`
3.1-AC15: PASS — §5 `:65`: "Cover `aspect-ratio:3/4` on `--surface-art` with
the app-wide indigo→canvas veil". Filter gone; veil and `--surface-art` fill
both retained, so §6's back-reference at `:79` ("Cover 46 × 62 at
`--radius-sm` with the same veil") still resolves to a veil that exists.
3.1-AC16: PASS — §3 `:41`: "Playing indigo `#5865f2`", plus the shipped
carve-out in the same bullet — "On the **active** Playing chip the dot reverts
to ink: the filled pill already carries the hue, so an indigo dot on it would
be invisible (this ships today)". Matches `status_chip.dart`'s shipped
behaviour, which is out of scope and unchanged. The failure case (a bare
"Playing indigo" handing item 4.3 an invisible dot) is averted. Note: the doc
names the hex rather than the Dart identifier `accentIndigo`, which is this
doc's consistent convention throughout (§12 does the same) — the value is
exact and the carve-out is present, so this is the criterion as written, not a
substitute.
3.1-AC17: PASS — §12 `:154`: "Indigo `#5865f2` — active status chip, active
tab, and the Playing status dot wherever it appears: the chip row (§3), the
grid cover's status pill (§5) and the list row's status line (§6). Nothing
else." All three sites corrected §3 puts indigo are admitted; §12 and §3 no
longer contradict.
3.1-AC18: PASS — §11 `:143`: "flat `--surface-art-deep` fill (`#7d4ee0`)", and
the no-decorative-circle reason is rewritten to stand on the flat fill itself
("on an otherwise empty screen the violet block is already the one loud shape")
rather than crediting a gradient, with the dated flat-not-gradient decision and
"Do not reintroduce one" for item 4.5.

### The remaining rejected-filter sites (D4)
3.1-AC19: PASS — `home-screen-design-conventions.md:51` drops the filter and
keeps the veil with its exact stops (`rgba(88,101,242,.26) → rgba(35,39,42,.6)`),
the purpose sentence and the 2026-07-30 recomputation note verbatim. `:123`
now reads "Every cover in the app: `object-fit:cover` plus the indigo→canvas
gradient veil" — still declaring the veil app-wide, no longer declaring the
filter. The root of the recurrence is closed.
3.1-AC20: PASS — `home-screen-design-conventions.md:83`: "the same
saturate/veil treatment" → "the same veil". No dangling pointer to a treatment
that no longer exists.
3.1-AC21: PASS — `game-detail-design-conventions.md:36`: "Key art
`object-fit:cover` with the app-wide cover treatment — the indigo→canvas veil"
(reference kept, filter gone); lines 41 and 162 untouched.
`onboarding-welcome-design-spec.md:85-86`: "Every cover image gets a
top-to-bottom indigo→canvas tint" (tint kept, filter gone). **Line 67's
`saturate(.4) contrast(1.05)` screen-2 key art is intact and untouched** — the
deliberate exclusion held.

### Cross-cutting
3.1-AC22: PASS — sweep run independently.
  - `saturate(.5) contrast(1.05)` across `.agents/references/` — **zero hits**.
  - `desaturat` — **exactly four**, all expected:
    `home-screen-design-conventions.md:154`,
    `library-design-conventions.md:179`,
    `game-detail-design-conventions.md:162` (the three stand-in-photography
    production notes) and `game-detail-design-conventions.md:41` (the rejected
    hero-ramp option, a hero treatment not a cover one).
  - `saturate(` — one hit, `onboarding-welcome-design-spec.md:67`, the
    excluded screen-2 key art. No missed site.
  The indigo→canvas veil survives at all eight corrected sites — checked
  individually above, not inferred from the sweep.
3.1-AC23: PASS — git shows no file under `lib/` other than
`app_color_tokens.dart`, and no test file at all, modified between `ab586dc`
and `HEAD`. Analyzer at 30 issues / 0 errors / 2 warnings / 28 info; suite at
exactly +361 -10 with the same 10 pre-existing failures. No screen or widget
diff, so no criterion leaked into Stage 4's scope.

## Architectural compliance
Status: PASS
FAILs: NONE
WARNINGs: NONE

Against `tdd.md`: both fields declared in the existing `// ** Surfaces` group
immediately after `surfaceToast` in that order, at all five sites in the same
relative position; both `final Color`; `dark` uses inline literals; no
`Gradient`/`List<Color>`/stop list; no comment added; `surfaceIndigoPanel`'s
literal not refactored and neither token bound to `_statusViolet` or
`_accentIndigo`, exactly as the reuse decision requires. No package added —
`pubspec.yaml` untouched. Class and path match (`AppColorTokens`,
`lib/config/theme/tokens/app_color_tokens.dart`).

Against the component skills: no layer skill applies. The allowlist touches no
widget, screen, bloc/cubit, use case, entity, repository, datasource or DTO —
`AppColorTokens` is a theme token class, and nothing consumes the new fields.
`flutter-widgets`' theme rule (`context.themeData`, never `Theme.of`) governs
consumers, of which this item has none. `flutter-widget-test` does not apply:
no test file is in the allowlist and none changed.

`tdd.md`'s one unverified caveat is now resolved: adding two required
constructor parameters broke no call site. `AppColorTokens(` is constructed at
four places, all inside its own file; the analyzer reports no
missing-argument error anywhere, in or out of the allowlist.

## Escalation required
NONE
