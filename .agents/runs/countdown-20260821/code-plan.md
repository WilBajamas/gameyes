# Code Plan
Source: `.agents/week-2-task-briefs.md` Stage 2 item 2.3 — Countdown + Countdown tile
Date: 2026-08-21

## CREATE NEW

### lib/features/featured/domain/entities/countdown_game_entity.dart
```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';

part 'countdown_game_entity.freezed.dart';

@freezed
sealed class CountdownGameEntity with _$CountdownGameEntity {
  const factory CountdownGameEntity({
    required GameEntity? game,
    required bool isWishlisted,
  }) = _CountdownGameEntity;
}
```

### lib/widgets/countdown/enum/countdown_form.dart
```dart
import 'package:flutter/widgets.dart';

enum CountdownForm {
  card(
    figureSize: 22,
    blockMinWidth: 40,
    blockPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
    isGlass: false,
  ),
  tile(
    figureSize: 30,
    blockMinWidth: 52,
    blockPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    isGlass: true,
  );

  const CountdownForm({
    required this.figureSize,
    required this.blockMinWidth,
    required this.blockPadding,
    required this.isGlass,
  });

  final double figureSize;
  final double blockMinWidth;
  final EdgeInsets blockPadding;
  final bool isGlass;
}
```

### lib/widgets/countdown/countdown_digit_row.dart
```dart
class CountdownDigitRow extends StatelessWidget {
  const CountdownDigitRow({
    super.key,
    required this.form,
    required this.remaining,
    this.releaseDateText,
  });

  final CountdownForm form;
  final Duration? remaining;
  final String? releaseDateText;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final time = remaining;

    if (time == null) {
      final date = releaseDateText;

      if (date != null) {
        return Text(
          date,
          style: tokens.typography.meta.style.copyWith(
            color: tokens.color.ink55,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        );
      }

      return Text(
        tokens.typography.pill.format(S.current.countdown_date_unannounced),
        style: tokens.typography.pill.style.copyWith(color: tokens.color.ink55),
        maxLines: 1,
      );
    }

    if (time <= Duration.zero) {
      return Text(
        tokens.typography.pill.format(S.current.countdown_released),
        style: tokens.typography.pill.style.copyWith(color: tokens.color.ink),
        maxLines: 1,
      );
    }

    final days = time.inDays.toString().padLeft(2, '0');
    final hours = (time.inHours % 24).toString().padLeft(2, '0');
    final minutes = (time.inMinutes % 60).toString().padLeft(2, '0');

    return Semantics(
      container: true,
      excludeSemantics: true,
      label: S.current.countdown_time_remaining(days, hours, minutes),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        spacing: 6,
        children: [
          _CountdownUnit(form: form, value: days, label: S.current.countdown_days),
          _CountdownColon(form: form),
          _CountdownUnit(form: form, value: hours, label: S.current.countdown_hours),
          _CountdownColon(form: form),
          _CountdownUnit(form: form, value: minutes, label: S.current.countdown_minutes),
        ],
      ),
    );
  }
}

class _CountdownUnit extends StatelessWidget {
  const _CountdownUnit({
    required this.form,
    required this.value,
    required this.label,
  });

  final CountdownForm form;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final radius = BorderRadius.circular(tokens.radius.xs);
    final figure = Padding(
      padding: form.blockPadding,
      child: Text(
        value,
        style: tokens.typography.countdownFigure.style.copyWith(
          fontSize: form.figureSize,
        ),
        maxLines: 1,
      ),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(minWidth: form.blockMinWidth),
          child: form.isGlass
              ? GlassSurface(
                  fill: tokens.color.glass32,
                  borderRadius: radius,
                  child: figure,
                )
              : DecoratedBox(
                  decoration: BoxDecoration(
                    color: tokens.color.ink08,
                    borderRadius: radius,
                  ),
                  child: figure,
                ),
        ),
        Text(
          tokens.typography.microLabel.format(label),
          style: tokens.typography.microLabel.style.copyWith(
            color: tokens.color.ink55,
          ),
          maxLines: 1,
        ),
      ],
    );
  }
}

class _CountdownColon extends StatelessWidget {
  const _CountdownColon({required this.form});

  final CountdownForm form;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Text(
      ':',
      style: tokens.typography.countdownColon.style.copyWith(
        color: form.isGlass ? tokens.color.countdownColon : tokens.color.ink12,
      ),
    );
  }
}
```

### lib/widgets/countdown/countdown_card.dart
```dart
class CountdownCard extends StatelessWidget {
  const CountdownCard({
    super.key,
    required this.title,
    required this.isWishlisted,
    required this.remaining,
    required this.onOpen,
    this.releaseDateText,
    this.onRemind,
  });

  final String title;
  final bool isWishlisted;
  final Duration? remaining;
  final String? releaseDateText;
  final VoidCallback onOpen;
  final VoidCallback? onRemind;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final remind = onRemind;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onOpen,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: tokens.color.surfaceRaised,
          borderRadius: BorderRadius.circular(tokens.radius.lg),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            spacing: 12,
            children: [
              _ReasonLine(isWishlisted: isWishlisted),
              Text(
                title.toUpperCase(),
                style: tokens.typography.cardHeading.style,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              CountdownDigitRow(
                form: CountdownForm.card,
                remaining: remaining,
                releaseDateText: releaseDateText,
              ),
              if (remind != null) _RemindAction(onPressed: remind),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReasonLine extends StatelessWidget {
  const _ReasonLine({required this.isWishlisted});

  final bool isWishlisted;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    if (!isWishlisted) {
      return Text(
        S.current.most_anticipated,
        style: tokens.typography.zoneLink.style.copyWith(
          color: tokens.color.ink55,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: 6,
      children: [
        Icon(
          Icons.bookmark_outline,
          size: 14,
          color: tokens.color.accentLinkCyan,
        ),
        Flexible(
          child: Text(
            S.current.on_your_wishlist,
            style: tokens.typography.zoneLink.style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _RemindAction extends StatelessWidget {
  const _RemindAction({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        constraints: const BoxConstraints(minHeight: 44),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: tokens.color.ink12,
          borderRadius: BorderRadius.circular(tokens.radius.xs),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 6,
          children: [
            Icon(Icons.notifications_none, size: 14, color: tokens.color.ink),
            Text(
              S.current.remind,
              style: tokens.typography.zoneLink.style.copyWith(
                color: tokens.color.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### lib/widgets/countdown/countdown_tile.dart
```dart
class CountdownTile extends StatelessWidget {
  const CountdownTile({
    super.key,
    required this.remaining,
    this.releaseDateText,
  });

  final Duration? remaining;
  final String? releaseDateText;

  @override
  Widget build(BuildContext context) {
    return CountdownDigitRow(
      form: CountdownForm.tile,
      remaining: remaining,
      releaseDateText: releaseDateText,
    );
  }
}
```

## MODIFY EXISTING

### lib/features/featured/domain/repositories/featured_repository.dart
```dart
export '../entities/countdown_game_entity.dart';
export '../entities/library_snapshot_entity.dart';
export '../entities/genre_preferences_entity.dart';

abstract interface class FeaturedRepository {
  Future<Result<LibrarySnapshotEntity>> getLibrarySnapshot();
  Future<Result<CountdownGameEntity>> getCountdownGame();
  Future<Result<List<GameEntity>>> getOutThisWeekGames(bool forceExtendWindow);
  // remaining signatures unchanged
}
```

### lib/features/featured/data/repositories/featured_repository_impl.dart
```dart
  @override
  Future<Result<CountdownGameEntity>> getCountdownGame() async {
    try {
      final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      final wishlisted = await _localDatasource.getWishlistedGames();
      final wishlistIds = wishlisted
          .map((g) => g.gameId)
          .where((id) => id != null)
          .cast<int>()
          .toSet();

      if (wishlistIds.isNotEmpty) {
        final idsString = wishlistIds.join(',');
        // query unchanged
        final games = await _featuredApiService.fetchGames(query);
        if (games.isNotEmpty) {
          return Success(_countdownFrom(games.first.toEntity(), wishlistIds));
        }
      }

      // fallback query unchanged
      final games = await _featuredApiService.fetchGames(query);
      if (games.isNotEmpty) {
        return Success(_countdownFrom(games.first.toEntity(), wishlistIds));
      }

      return Success(const CountdownGameEntity(game: null, isWishlisted: false));
    } catch (e, stacktrace) {
      // unchanged
      return Failure(const ErrorType.unknown());
    }
  }

  // The card's reason line claims a wishlist entry, so the flag is membership of
  // the wishlisted ids, and both selection branches derive it here.
  CountdownGameEntity _countdownFrom(GameEntity game, Set<int> wishlistIds) {
    return CountdownGameEntity(
      game: game,
      isWishlisted: wishlistIds.contains(game.id),
    );
  }
```

### lib/features/featured/domain/use_cases/get_countdown_game_use_case.dart
```dart
@injectable
class GetCountdownGameUseCase {
  final FeaturedRepository _repository;

  GetCountdownGameUseCase(this._repository);

  Future<Result<CountdownGameEntity>> call() async =>
      _repository.getCountdownGame();
}
```

### lib/features/featured/presentation/blocs/countdown_releases_state.dart
```dart
  const factory CountdownReleasesState({
    @Default(CountdownReleasesStatus.initial) CountdownReleasesStatus status,
    GameEntity? countdownGame,
    @Default(<GameEntity>[]) List<GameEntity> outThisWeekGames,
    Duration? durationRemaining,
    @Default(false) bool isReleaseDay,
    @Default(false) bool isWishlisted,
    String? errorMessage,
    @Default(false) bool isComingSoonLabel,
  }) = _CountdownReleasesState;
```

### lib/features/featured/presentation/blocs/countdown_releases_cubit.dart
```dart
    switch (countdownResult) {
      case Success(value: final countdown):
        switch (releasesResult) {
          case Success(value: final releases):
            // release-window / coming-soon logic unchanged

            emit(
              state.copyWith(
                status: CountdownReleasesStatus.success,
                countdownGame: countdown.game,
                isWishlisted: countdown.isWishlisted,
                outThisWeekGames: releases,
                isComingSoonLabel: isComingSoon,
              ),
            );

            _updateCountdown();
            _startTimer();
          case Failure():
            // unchanged
        }
      case Failure():
        // unchanged
    }
```
`_startTimer`, `_updateCountdown`, `_getReleaseDate` and `close()` are not edited.

### lib/features/featured/presentation/widgets/countdown_releases.dart
```dart
class CountdownReleasesWidget extends StatelessWidget {
  final GameEntity? countdownGame;
  final List<GameEntity> outThisWeekGames;
  final Duration? durationRemaining;
  final bool isWishlisted;
  final bool isComingSoonLabel;
  final Set<int> localLibraryGameIds;
  final Function(int, String, String?) onGameClick;

  const CountdownReleasesWidget({
    super.key,
    required this.countdownGame,
    required this.outThisWeekGames,
    required this.durationRemaining,
    required this.isWishlisted,
    required this.isComingSoonLabel,
    required this.localLibraryGameIds,
    required this.onGameClick,
  });

  @override
  Widget build(BuildContext context) {
    final game = countdownGame;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (game != null) ...[
          const Text('Next Release Countdown', style: ...),
          const SizedBox(height: 10),
          CountdownCard(
            title: game.name,
            isWishlisted: isWishlisted,
            remaining: durationRemaining,
            releaseDateText: game.releaseDates?.firstOrNull?.human,
            onOpen: () => onGameClick(game.id, game.name, game.cover.url),
          ),
          const SizedBox(height: 24),
        ],
        // out-this-week heading, count and _buildReleasesList unchanged
      ],
    );
  }
}
```
Deleted: the line-7 `// TODO: Refactor this`, `_buildCountdownCard`,
`_buildCelebrationState`, `_buildTimerBlocks`, `_buildTimeBox`, the
`DefaultCachedNetworkImage` import if it is now unused, and every remaining comment in
the file.

### lib/features/featured/presentation/screens/featured_screen.dart
```dart
            if (isLoading) {
              return Skeletonizer(
                child: CountdownReleasesWidget(
                  countdownGame: GameLoadingWidgetData.countdownGame,
                  outThisWeekGames: GameLoadingWidgetData.weeklyReleases,
                  durationRemaining: GameLoadingWidgetData.countdownDuration,
                  isWishlisted: false,
                  isComingSoonLabel: false,
                  localLibraryGameIds: ownedIds,
                  onGameClick: (_, __, ___) {},
                ),
              );
            }

            // ...

            return CountdownReleasesWidget(
              countdownGame: state.countdownGame,
              outThisWeekGames: state.outThisWeekGames,
              durationRemaining: state.durationRemaining,
              isWishlisted: state.isWishlisted,
              isComingSoonLabel: state.isComingSoonLabel,
              localLibraryGameIds: ownedIds,
              onGameClick: (id, name, imageUrl) { /* unchanged */ },
            );
```

### lib/l10n/intl_en.arb
```json
  "countdown_days": "Days",
  "countdown_hours": "Hrs",
  "countdown_minutes": "Min",
  "countdown_released": "Out now",
  "countdown_date_unannounced": "Date to be announced",
  "countdown_time_remaining": "{days} days, {hours} hours, {minutes} minutes until release",
  "@countdown_time_remaining": {
    "placeholders": { "days": {}, "hours": {}, "minutes": {} }
  },
  "on_your_wishlist": "On your wishlist",
  "most_anticipated": "Most anticipated",
  "remind": "Remind"
```
The three unit labels and the two caps lines are uppercased by their type token at
render time, so the stored values stay sentence case and translate cleanly.

### lib/l10n/intl_zh.arb
The same nine keys, translated in the register the file already uses — `countdown_days`
天, `countdown_hours` 小时, `countdown_minutes` 分钟, `countdown_released` 现已推出,
`countdown_date_unannounced` 发售日期待公布, `on_your_wishlist` 在你的愿望单中,
`most_anticipated` 最受期待, `remind` 提醒 — plus the same `@countdown_time_remaining`
placeholder block.

## TEST FILES

### test/widget/components/countdown_test.dart
Shared `buildCard({...})` / `buildTile({...})` helpers in the `stat_pill_test.dart`
shape: `MaterialApp(theme: buildDarkTheme(), localizationsDelegates: [S.delegate, ...])`,
`GoogleFonts.config.allowRuntimeFetching = false`.
- `'shows three padded unit groups and two colons when a duration is supplied'` — for 3d 5h 12m, expects `03`, `05`, `12`, `DAYS`, `HRS`, `MIN`, and `findsNWidgets(2)` on `find.text(':')`.
- `'shows the released label and no digits when the duration has run out'` — `Duration.zero`, expects the released label and `find.text(':')` `findsNothing`.
- `'shows the supplied release date when no duration is given'` — `remaining: null`, `releaseDateText: 'Q2 2026'`.
- `'shows the unannounced date label when neither a duration nor a date is given'` — both null, expects the label and no colons.
- `'shows the wishlist reason line in link cyan when the game is wishlisted'` — asserts the reason `Text`'s `style.color` equals the pumped theme's `accentLinkCyan` token, never a hex.
- `'shows the neutral reason line when the game is not wishlisted'` — expects the neutral copy present and the wishlist copy absent.
- `'hides the remind action when no handler is supplied'` — `onRemind: null`, Remind label `findsNothing`.
- `'calls onOpen once when the card is tapped'` — taps the title, expects a counter of 1.
- `'calls onRemind without opening the game when the remind action is tapped'` — expects remind 1, open 0.
- `'leaves the digits unchanged when time passes without a rebuild'` — `await tester.pump(const Duration(minutes: 5))`, expects the same three digit strings; teardown fails on any pending timer.
- `'shows the same three unit groups in the tile form'` — the same duration through `CountdownTile`: same digits, same labels, two colons.

### test/repository/featured/featured_repository_test.dart
`@GenerateMocks([FeaturedLocalDatasource, FeaturedApiService])`. Distinguish the two
queries by stubbing on `argThat(contains('id = '))` for the wishlist query and
`argThat(contains('hypes'))` for the fallback.
- `'should return isWishlisted true when the selected game id is in the wishlisted set'`
- `'should return isWishlisted false when selection falls through to the global fallback'`

### test/features/featured/domain/use_cases/get_countdown_game_use_case_test.dart
`FakeFeaturedRepository.getCountdownGame` returns `Result<CountdownGameEntity>`; the
existing success / null-game / failure tests keep their shape against the new type.
- `'should pass the repository wishlist flag through unchanged'`

### test/features/featured/presentation/blocs/countdown_releases_cubit_test.dart
`FakeGetCountdownGameUseCase` returns `Result<CountdownGameEntity>` and gains an
`isWishlisted` field; the existing four tests keep their shape.
- `'sets isWishlisted from the use case result on a successful load'`
- `'leaves isWishlisted false when the load fails'`
