# Design Brief — Game Library App Revamp
### Sections 3–8: Target User, Principles, Screen Briefs, Navigation, Cross-cutting Patterns, Constraints

---

## 3. Target user

**Primary:** The backlog-anxious gamer. Owns more games than they'll finish. Wants to feel in control of a collection that's outgrown their memory. Checks in a few times a week.

**Secondary:** The release-tracker. Doesn't care much about logging past games, but wants to know what's coming and what reviewed well. Opens the app when news breaks.

Design for both. The primary user needs the library to feel like theirs. The secondary user needs a reason to open the app on a Tuesday.

---

## 4. Design principles

These are non-negotiable. Everything you design should pass all five.

**Never empty.** Every screen, every section, every state provides value even with zero user data. Empty states are onboarding opportunities, not apologies. Backlogr's four grey boxes are the anti-pattern.

**Reward ten seconds.** A user who opens the app, glances, and closes should get something. Depth is available for those who scroll, but the top of every screen is self-sufficient.

**Personal beats popular.** When we can show the user their own data, we show their own data. Global fallbacks exist, but they're fallbacks, and they should visibly announce what the user gets by engaging.

**Show, don't ask.** No blocking onboarding wizards. Let people in, then teach through the interface. Ghost states that preview what's coming beat modals that explain it.

**Density with breathing room.** IGDB proves gamers tolerate information density. But we're mobile-first. Find the line where informative becomes cluttered.

---

## 5. Screen briefs

### Home — highest priority, spec exists

Three zones, top to bottom, answering three questions in sequence:

- **Zone 1 "You"** — Where am I? Now Playing card with progress, three stat pills, onboarding checklist in cold state.
- **Zone 2 "Right Now"** — What's happening? Live countdown card, rolling 7-day release scroll.
- **Zone 3 "Discover"** — What next? Genre picker, critics score grid.

Full BRD with states and business logic is written. Wireframes exist for standard and cold states.

**Design challenges:**
The Now Playing card is the emotional anchor of the entire app. It needs to feel special — this is the user's current relationship with a game, not a list row. Consider cover art treatment, progress visualisation beyond a plain bar, and what it looks like at 5% versus 95% complete.

The countdown card competes for attention with Zone 1. Zone 1 must win. Solve the hierarchy.

Zone transitions need to read as distinct sections without hard dividers making the screen feel like three separate pages stapled together.

---

### Library — highest priority, no spec

The most important screen we haven't designed. This is where the primary user lives.

**Requirements:**
Status filtering across Playing, Backlog, Completed, Dropped, Wishlist, On Hold. Grid and list view toggle. Sort by recently added, alphabetical, release date, rating, playtime. Filter by platform, genre, year, score. Custom user-created lists. Bulk edit mode. Search within library. Per-tab empty states.

**Design challenges:**
A user with 300 games and a user with 3 games need the same screen to work. Design for both ends.

Six status categories is a lot of navigation. Tabs, segmented control, filter chips, or something else? Backlogr uses status cards on their home screen, which is clean but requires a tap to get anywhere.

Cover art grids are visually strong but low information. List views are informative but ugly. Find a middle option, or make the toggle so good that users actually switch.

Bulk edit is a power feature. It should be discoverable without cluttering the default view.

---

### Game Detail — high priority, no spec

Every path in the app terminates here. It's the most-visited screen and currently the least considered.

**Requirements:**
Hero art, metadata (developer, publisher, date, platforms), primary add-to-library action with status picker, critic and user scores, description, screenshot and trailer gallery, genres and tags, where to play, average completion time, personal section (your status, rating, hours, notes), community reviews, similar games.

**Design challenges:**
The add-to-library action is the single most important interaction in the app. It must be immediate and obvious. Everything else on this screen is secondary.

Users arrive in two states: game already in their library, or not. These are functionally different screens. Design both.

Long metadata lists become walls of text. Prioritise ruthlessly — what does a user actually decide with?

---

### Search / Browse — high priority, partial spec

Currently the discovery surface. Needs restructuring.

**Requirements:**
Live search with recent searches. Featured hero carousel. Sections for Top Sellers, Most Anticipated, Free to Play, New Releases. Genre grid. Advanced filters. Results screen with quick-add on each row.

**Design challenges:**
Search-focused users want the field immediately. Browse-focused users want content. One screen serves both — resolve the tension.

Quick-add from search results is a conversion moment. Adding a game without leaving the results list should be frictionless.

Backlogr's hero carousel is the best-looking thing across all three competitors. Match or beat it.

---

### Stats / Insights — medium priority, no spec

Retention feature. Turns a utility into something people revisit.

**Requirements:**
Totals (games, hours, completion rate). Hours over time. Games completed per period. Genre and platform breakdown. Average rating given. Backlog burndown. Annual Year in Review.

**Design challenges:**
Charts on mobile are hard. Most apps do them badly. Decide which two or three visualisations actually earn their space.

Year in Review is the highest-shareability asset we could build. Design it as a standalone artefact people screenshot and post, not a page they scroll.

Stats with no data are meaningless. What does this screen look like for a user with four games?

---

### Profile — medium priority, no spec

**Requirements:**
Own profile with avatar, bio, stats summary, currently playing showcase, pinned favourites, reviews, custom lists, follower counts. Other users' profiles with follow action.

**Design challenges:**
This screen overlaps heavily with Library and Stats. Define the boundaries so it doesn't become a duplicate.

The pinned favourites showcase is an identity feature — how a user presents themselves. Make it feel expressive.

---

### Feed / Community — medium priority, exists

**Requirements:**
Activity from followed users, recent community reviews, newly published lists, filtering by Following / Everyone / Popular, like and reply.

**Design challenges:**
A social feed with no follows is dead. The empty state must actively recruit — suggest people to follow based on shared library or genre overlap.

---

### Onboarding — medium priority, no spec

**Requirements:**
Splash, welcome carousel (2–3 slides maximum), auth with social options including Discord, email fallback, password reset, email verification.

**Design challenges:**
Keep pre-app friction near zero. Genre preferences, platform preferences, and the three-step checklist all happen inside the app after entry, not before.

Library import from Steam or PSN would be transformative for cold start, but it's a large technical scope. Design the entry point assuming it exists later.

---

### Settings, Notifications — lower priority, no spec

Settings covers account, privacy, notification preferences, appearance, defaults, connected accounts, data export, regional, about, support.

Notification centre covers release reminders, social activity, weekly digest, with read state management.

Standard patterns are acceptable here. Don't over-invest.

---

## 6. Navigation decision — needs your input

Current: **Home · Search · Feed · Profile**

My proposal: **Home · Library · Search · Stats · Profile**

Library earns a tab because it's the core product. Stats earns a tab because it drives return visits. Feed loses its tab and folds into Profile or Home Zone 3.

The counter-argument: social features drive growth, and demoting Feed signals we're de-prioritising community. I'd rather win at self-tracking first and add social depth once the core is strong.

Five tabs is the ceiling. If you want Feed back, something else comes out. Push back on this if you disagree — the decision should be design-informed, not just PO opinion.

---

## 7. Cross-cutting patterns to design once, use everywhere

**Add-to-library bottom sheet.** Status picker, rating, platform selection. Triggered from Home, Search, Game Detail, Library. Single component, many contexts.

**Log session flow.** Date and duration entry. Should take under five seconds.

**Custom list creation.** Name, description, cover image, privacy toggle.

**Skeleton loading.** Shimmer, not spinners. Applies to every async surface in the app.

**Inline error with retry.** Per-section, never full-page. Applies everywhere.

**Game card.** Appears in at least six contexts at three sizes. Design the system, not the instances.

**Library indicator badge.** Marks games the user already tracks, shown on any card outside the Library screen. Prevents redundant add attempts.

---

## 8. Constraints

Dark theme is the default and the priority. Light theme is secondary but must exist.

Mobile-first. No tablet-specific layouts in this phase.

Cover art quality varies — some games have poor or missing art. Every card design needs a graceful fallback.

Offline mode is out of scope for this phase. Design assumes connectivity with inline error states.

Community text reviews are out of Home scope for v1. They stay in Feed.
