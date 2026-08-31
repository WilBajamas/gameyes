# Ambiguities Report
Source: `.agents/week-3-task-briefs.md` item 3.4b (lines 261–272); criteria reused from
`.agents/runs/library-bloc-preferences-20260827/tech-ac.md` (3.4-AC26–3.4-AC36).
Date: 2026-08-30

## CRITICAL (pipeline blocked — requires human decision before proceeding)

NONE.

This is a genuine none, not an empty section. The eleven carried criteria were written,
reviewed and gated during the 3.4a run, and the three decisions that could have blocked
them are closed and explicitly not re-openable: D14 (every now-playing tap goes to the
Library tab via `setActiveIndex(1)`, the single-game branch stops pushing
`TrackerGameDetailRoute`, the tracker tree becomes unreachable but is not deleted), D15
(`countSavedGames` and `getOwnedGameIds` repoint at `library_entries`), and the human
instruction that `_buildNowPlayingCard` becomes a `StatelessWidget`. The one new
criterion, 3.4-AC44, is a test-coverage requirement over behaviour D17.8 already decided
— it asks for no business decision.

Two things were checked rather than assumed before declaring this:

- **3.4-AC34's fields all exist.** `LibraryEntryEntity` carries `title`, `coverUrl`,
  `playtimeHours` and `progressPercent`, and the `progress_percent` / `playtime_hours`
  columns exist in `supabase/migrations/20260827120000_library_entries_details.sql`. The
  criterion is satisfiable as written, with the one documented exception already recorded
  as a known gap (the average-completion branch, which no column backs).
- **3.4-AC33's degrade path exists.** 3.4a landed `BaseRepositoryMixin`'s `notSignedIn`
  mapping on both new repository methods, which is what lets a signed-out read become
  empty/zero inside a `Success` snapshot rather than failing Featured.

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: "the requested page size" in 3.4-AC44 means the library feature's existing
page-size constant, not a new or test-only value. The criterion constrains the seeded
data in the test, not the page size.

ASSUMPTION: 3.4-AC44 is satisfied at the bloc level, alongside the existing next-page
tests, because that is the layer the surviving mutation was found at. A test placed
elsewhere that provably fails the same mutation would satisfy it equally.

ASSUMPTION: 3.4-AC44's numbering. The source file's last criterion is 3.4-AC43, so 44 is
the next free number. It appears only in this run's file; the source file stays at 43 per
D16.

## OBSERVATIONS (no decision needed, recorded for the Tech Lead)

OBSERVATION-1: Three further coverage gaps were recorded by 3.4a QA and are **not** part
of this run's added scope — the failed-append path (3.4-AC10), the whitespace-only search
term (3.4-AC8), and two overlapping next-page requests (3.4-AC6). All three are correct
in source and none is gated here; only the 3.4-AC7 append gap was folded in. Noted so a
later reader does not mistake their absence for an oversight.

OBSERVATION-2: 3.4-AC36 is a MANUAL criterion and closes `3.2-MC-6`. It cannot be
satisfied by the pipeline and needs an on-device check at the QA gate, with one playing
game and with several.

OBSERVATION-3: `.agents/handover.md` line 17 still describes
`feature/library-bloc-preferences` as unmerged. Phase 0 verified it is merged and level
with this branch at `f167a17`. A doc correction, outside this run's criteria — the Tech
Lead's to place if it is placed at all.
