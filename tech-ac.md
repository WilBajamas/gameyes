# Technical Acceptance Criteria
Source: BRD v1.1 §3-§6 & Wireframes (Cold and Hot states)
Date: May 30, 2026
BA Agent version: 1.0

## Feature summary
This feature implements a revamped Home screen layout inside a new feature folder (`lib/features/featured_revamp`) without altering the existing `featured_screen.dart`. The revamped screen consists of three main zones: Zone 1 ("You"), displaying a personalized library snapshot (or an onboarding checklist in a cold state); Zone 2 ("Right Now"), featuring a live countdown to the user's next wishlist release or a global anticipated title, alongside a rolling "Out This Week" releases list; and Zone 3 ("Discover"), containing a critic score grid filtered by genre preferences. The screen uses Local Storage (shared preferences) for genre preferences, the Isar local database for user library data, Dio/Retrofit APIs for game discovery databases, and flutter_bloc for state management, leveraging Skeletonizer for shimmer loading indicators.

## Technical acceptance criteria

[Z1-BL-01] UI / STATE: If the local Isar database contains exactly 0 games, the `featured_revamp` home screen Bloc/Cubit must yield a state that renders the welcome checklist card in Zone 1. This card must display a 3-step list ("Add a game you've played", "Mark what you're playing now", "Wishlist an upcoming game") with a progress track and an inline "+ Add" tap handler for each.
  Failure case: If the local library database has 0 games but the checklist card is not displayed, or if any step/button is non-functional.

[Z1-BL-02] UI / STATE: If the local Isar database contains 1 or more games, the `featured_revamp` Bloc must replace the welcome checklist card with the standard library stats view. Once replaced, the checklist card must never render again in the current or future sessions.
  Failure case: If the welcome checklist remains visible after library count becomes >= 1, or if it returns on subsequent launches.

[Z1-BL-03] UI / STATE: If the local Isar database contains exactly 1 game with the status set to "Playing", the Now Playing card in Zone 1 must display that game's cover art, title, and a progress bar (if hours are logged).
  Failure case: If a single active game has "Playing" status but the Now Playing card fails to display its info, or shows a ghost state.

[Z1-BL-04] UI / STATE / ROUTING: If the local Isar database contains 2 or more games with the status set to "Playing", the Now Playing card must display the game with the most recently updated timestamp. The card subtitle must show "+ [N-1] more playing", and tapping the card must route via AutoRoute to the library filter screen showing only games with "Playing" status.
  Failure case: If a game other than the most recently updated is shown, the subtitle number is incorrect, or tapping does not navigate to the filtered library route.

[Z1-BL-05] UI: If the local Isar database contains 0 games with the status "Playing" (but library count >= 1), the Now Playing card must render as a ghost card with a dashed border, showing a placeholder icon, a description "No game in progress", and a text CTA button "Mark something as playing →".
  Failure case: If the Now Playing card collapses, shows blank space, or fails to render the CTA button when no games are active.

[Z1-BL-06] STATE: The progress percentage for the Now Playing card must be calculated in the Bloc layer: use manual percentage if set on the library entry; else if hours logged and average completion hours exist in the database, calculate `(hours logged / average completion hours) * 100` capped at 100%; otherwise, display only the logged hours text and omit the progress bar.
  Failure case: If the calculation fails or throws an exception when average completion hours are missing, or if progress percentage exceeds 100%.

[Z1-BL-07] STATE / LOCAL STORAGE: The "This week" hours calculation must sum the user's session play logs in the Isar database within a rolling 7-day window (last 168 hours) from the current system timestamp. If no session logs exist in this window, it must return "0h".
  Failure case: If the value displays null, "—", or calculates based on fixed calendar week boundaries instead of a rolling 168-hour window.

[Z1-BL-08] STATE: Each welcome checklist step completion must be calculated by the Bloc independently: Step 1 (Add a played game) completes when library count >= 1; Step 2 (Mark now playing) completes when at least 1 game has the status "Playing"; Step 3 (Wishlist game) completes when wishlist count >= 1.
  Failure case: If step status updates do not trigger a state change and visual update of the progress bar in the welcome card.

[Z2-BL-01] STATE / API: The countdown selector must fetch the user's wishlist from local storage/Isar and select the game with the nearest future release date. If the wishlist has 0 upcoming games, it must fall back to querying the API for the globally most anticipated game.
  Failure case: If the countdown card remains blank, shows an error, or fails to query the global anticipated game when wishlist is empty.

[Z2-BL-02] UI / STATE: The countdown card must calculate and display Days, Hours, and Minutes remaining until midnight (00:00:00) in the user's local time zone on the release date. The state must update the remaining time every 60 seconds in the background.
  Failure case: If the timer displays seconds, ticks on every second, or calculates timezone offsets incorrectly.

[Z2-BL-03] STATE / API: The countdown card must exclude games from selection that do not have a day-level release date (e.g. TBA, Q4 2026).
  Failure case: If a game with a generic release year or quarter is selected for the countdown card.

[Z2-BL-04] STATE / API: The "Out This Week" API client must query for games with a release date within a rolling 7-day window from today (inclusive) to today + 6 days.
  Failure case: If the API query uses calendar-week boundaries instead of a rolling 7-day offset.

[Z2-BL-05] STATE / UI: If the API returns 0 games for the rolling 7-day window, the repository must expand the query to 14 days. The UI must then update the section header label from "Out this week" to "Coming soon".
  Failure case: If the section renders empty, collapses, or fails to update the label when the window is expanded.

[Z2-BL-06] STATE / UI: On the release date of the countdown game, the UI must display a release celebration state: the badge must read "Out today!" and the timer blocks must be replaced by a release announcement. This celebration state must persist for the release date only (local time) before advancing to the next upcoming game.
  Failure case: If the countdown timer displays negative values on release day, or fails to transition to the next game on the day after release.

[Z2-BL-07] STATE / UI: The "Out This Week" list must display a maximum of 10 items. The items must be sorted placing user-wishlisted games first, followed by global popularity score descending.
  Failure case: If the scroll list exceeds 10 items, or if sorting fails to prioritize wishlisted games.

[Z3-BL-01] STATE / API: The Critics grid must query the API for games with reviews published in the last 7 days, sorted by score descending, and display exactly 4 games. If the user has genre preferences set, it must filter by those genres first; if fewer than 4 results are found, it must backfill the remaining slots with global top-scored games from the last 7 days.
  Failure case: If the grid displays fewer than 4 games when data is available, or if the genre preference filter is ignored.

[Z3-BL-02] UI: The Critic score text color must use green (`#4caf7d`) for scores >= 80%, amber (`#e6a430`) for scores 60%–79%, and red (`#e05555`) for scores below 60%. Card backgrounds must remain neutral.
  Failure case: If score colors do not map correctly to the defined thresholds, or if card backgrounds change color.

[Z3-BL-03] UI / STATE: On first load with no saved genre preferences in local storage/user profile, the Genre Picker must pre-select the top 2 genres globally based on user statistics. The pre-selection must remain consistent across app launches.
  Failure case: If pre-selected genres are randomized on each load, or if no genres are pre-selected on first launch.

[Z3-BL-04] STATE / LOCAL STORAGE: Genre selections made in the picker must be persisted to local storage immediately upon tapping a pill. Tapping the "Skip" link must store an explicit "no preference" flag in local storage, which collapses the genre picker immediately and prevents it from displaying on future app opens.
  Failure case: If genre choices require a confirmation button to save, or if skipping the picker does not prevent it from appearing on the next launch.

[SYS-BL-01] STATE / LOCAL STORAGE: Zone 1 must load data from the local database (Isar) immediately upon home screen initialization and must not wait for any network API responses.
  Failure case: If Zone 1 shows a loading spinner or remains blank while waiting for network API requests.

[SYS-BL-02] UI: No zone on the revamped home screen is permitted to render as a blank space. Every zone must display either its populated state, its designated cold/empty/ghost state, or an inline error state with a retry button.
  Failure case: If any zone collapses into an empty gap or displays a blank space under any network or data condition.

[SYS-BL-03] UI: The application must utilize skeleton shimmer loading states (`Skeletonizer`) for lazy-loaded network data in Zones 2 and 3. The UI must not use full-screen blocking spinners or loading indicators.
  Failure case: If the screen displays a spinning loading indicator that blocks user interaction or does not show shimmer placeholders.

[SYS-BL-04] UI: Games displayed in Zone 2 ("Out This Week") and Zone 3 ("Critics This Week") that are already present in the user's local library must be visually marked with a status/library checkmark badge.
  Failure case: If a game in the user's library is displayed in Zone 2 or 3 without any visual indicator showing it is already owned/tracked.

[SYS-BL-05] STATE: When the application returns to the foreground after being in the background for 15 minutes or longer, it must execute a silent background refresh of the API data for Zone 2 and Zone 3. The UI must not block user scrolling or navigation during this refresh.
  Failure case: If the screen triggers a full-page loading skeleton when coming to the foreground, or if the refresh interrupts the user's current scroll position.

[SYS-STATE-01] UI / STATE: On first launch (empty state), Zone 1 must render the onboarding checklist, Zone 2 must render the global countdown card and wishlist nudge, and Zone 3 must render the genre picker.
  Failure case: If the user's first launch displays success states or empty lists instead of the onboarding guide and nudges.

[SYS-STATE-02] UI / STATE: When the device is completely offline on app launch, Zone 1 must load and display user library stats from the local Isar database. Zones 2 and 3 must render an inline "No connection" error message with a retry button.
  Failure case: If the app crashes or shows a global error screen when offline, or if Zone 1 fails to render local data.

[SYS-STATE-03] UI / STATE: Under slow network conditions (API response time > 2 seconds), Zone 1 must display local data immediately, while Zones 2 and 3 must display skeleton shimmer animations.
  Failure case: If Zone 1 is delayed in rendering due to slow API responses for Zones 2/3.

[SYS-STATE-04] UI / STATE: If a network API request fails for a single zone, that zone must display an inline error card with a retry button. The other zones must render their data normally without showing error states.
  Failure case: If a network failure in Zone 3 causes a global screen error or affects the rendering of Zone 1 or Zone 2.

[SYS-STATE-05] UI / STATE / ROUTING: If a network request returns a 401 Unauthorized status indicating an expired session, the application must immediately redirect the user to the login screen and clear any displayed session data.
  Failure case: If the screen displays cached user stats or allows interaction after a session expires.

[SYS-STATE-06] UI / STATE: Tapping or pulling to trigger a pull-to-refresh on the home screen must initiate parallel API queries for Zones 2 and Zone 3 and a local database reload for Zone 1. The refresh indicator must be non-intrusive and existing content must remain visible during loading.
  Failure case: If pulling to refresh clears existing content from the screen before the new data arrives, or if queries are executed sequentially.

## Out of scope
- OOS-01: All "See All" destination screens (e.g., New Releases full page, Critics Aggregator full page). Tapping the "See all" link must be a disabled action in this release.
- OOS-02: Any modifications to the Search screen, Feed screen, or Profile screen tabs.
- OOS-03: Any modifications to the Game Detail screen. Tapping game cards on the revamped home screen must route to the existing game detail screen.
- OOS-04: Push notifications related to game releases or countdowns.
- OOS-05: Social activity features (e.g., friend activity, community text reviews).
- OOS-06: Platform-specific filtering (PC, PlayStation, Xbox, etc.). The dashboard is platform-agnostic.
- OOS-07: Promotional banner slots on the Home screen.

## Assumptions
- ASSUMPTION: Following Z1-BL-02 literally, as soon as library count >= 1, the Welcome Checklist card is replaced by the standard stat view and never returns. Thus, the checklist will never be displayed to the user in a state where Step 1 (library count >= 1) or Step 2 (status Playing, which implies library count >= 1) is marked as complete in the checklist UI itself, except if the user adds a wishlist game first (Step 3), in which case it will show "1 of 3 complete" prior to library addition.
- ASSUMPTION: Per the BRD §08 and §09, the 'From the community' section shown in the hot state wireframe is out of scope for this release. Zone 3 will only implement the genre picker and critics grid components.
- ASSUMPTION: The countdown timer will count down to 00:00:00 (midnight) in the user's local time zone on the release date of the game, unless a specific global release time is provided by the API database.
- ASSUMPTION: The rolling 7-day window for "Out This Week" is defined as today (inclusive) through today + 6 days, resulting in a total of 7 calendar days shown in the horizontal scroll list.
- ASSUMPTION: If fewer than 4 games with new critic reviews in the last 7 days match the user's genre preferences, the backfill will prioritize global top-scored games that have reviews in the last 7 days. If there are still fewer than 4 games, it will backfill with global top-scored games of any age.
- ASSUMPTION: If calculated progress percentage based on logged hours and average completion hours exceeds 100%, the UI will display the progress bar filled to 100% (or cap the bar width at 100%) but continue to display the actual hours logged.
- ASSUMPTION: The revamped home screen will be implemented as a new route and screens inside a new feature folder named 'featured_revamp' (e.g., `lib/features/featured_revamp/...`), leaving the existing `featured_screen.dart` and `featured` feature folder completely untouched.
