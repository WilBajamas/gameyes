# Ambiguities Report
Source: BRD v1.1 & Wireframes (Cold and Hot states)
Date: May 30, 2026

## CRITICAL (pipeline blocked — requires human decision before proceeding)

NONE

## ASSUMPTIONS (minor — pipeline may proceed)

ASSUMPTION: Following Z1-BL-02 literally, as soon as library count >= 1, the Welcome Checklist card is replaced by the standard stat view and never returns. Thus, the checklist will never be displayed to the user in a state where Step 1 (library count >= 1) or Step 2 (status Playing, which implies library count >= 1) is marked as complete in the checklist UI itself, except if the user adds a wishlist game first (Step 3), in which case it will show "1 of 3 complete" prior to library addition.

ASSUMPTION: Per the BRD §08 and §09, the 'From the community' section shown in the hot state wireframe is out of scope for this release. Zone 3 will only implement the genre picker and critics grid components.

ASSUMPTION: The countdown timer will count down to 00:00:00 (midnight) in the user's local time zone on the release date of the game, unless a specific global release time is provided by the API database.

ASSUMPTION: The rolling 7-day window for "Out This Week" is defined as today (inclusive) through today + 6 days, resulting in a total of 7 calendar days shown in the horizontal scroll list.

ASSUMPTION: If fewer than 4 games with new critic reviews in the last 7 days match the user's genre preferences, the backfill will prioritize global top-scored games that have reviews in the last 7 days. If there are still fewer than 4 games, it will backfill with global top-scored games of any age.

ASSUMPTION: If calculated progress percentage based on logged hours and average completion hours exceeds 100%, the UI will display the progress bar filled to 100% (or cap the bar width at 100%) but continue to display the actual hours logged.

ASSUMPTION: The revamped home screen will be implemented as a new route and screens inside a new feature folder named 'featured_revamp' (e.g., `lib/features/featured_revamp/...`), leaving the existing `featured_screen.dart` and `featured` feature folder completely untouched.
