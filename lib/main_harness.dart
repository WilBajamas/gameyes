// Scratch harness for the on-device manual-check sitting. NOT part of the
// shipped app: it is a separate entrypoint, registers no route, and nothing in
// lib/ imports it. Run it with
//   flutter run --flavor dev -t lib/main_harness.dart
//
// It hosts the three modules that ship unwired — the completion ring (2.2),
// rows and hairline groups (2.6), and error states (2.7) — so the manual checks
// against them can be performed without waiting for a real caller. Delete this
// file once those checks are cleared and the components have real callers.

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_cover_entity.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/game_entity.dart';
import 'package:gaming_library_assessment_flutter/core/enums/library_status.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/completion_ring/completion_ring.dart';
import 'package:gaming_library_assessment_flutter/widgets/completion_ring/enum/completion_ring_size.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_states/destructive_action_pair.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_states/enum/error_notice_variant.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_states/error_notice.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_states/failed_item.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_card/enum/game_card_size.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_card/game_card.dart';
import 'package:gaming_library_assessment_flutter/widgets/hairline_group.dart';
import 'package:gaming_library_assessment_flutter/widgets/label_value_row.dart';

import 'generated/l10n.dart';

void main() => runApp(const HarnessApp());

class HarnessApp extends StatelessWidget {
  const HarnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QuestLoggd harness',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: buildTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: ThemeMode.dark,
      home: const _HarnessHome(),
    );
  }
}

class _HarnessHome extends StatelessWidget {
  const _HarnessHome();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.tokens.color.canvas,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 48),
          children: const [
            _Section(id: '2.2-C1 / C2 / C3', title: 'Ring — three sizes'),
            _RingSizes(),
            _Section(id: '2.2-C4 / C9 / C12', title: 'Ring — sweep 0 to 100'),
            _RingSweep(),
            _Section(id: '2.2-C5', title: 'Ring — out of range (-5 and 140)'),
            _RingOutOfRange(),
            _Section(id: '2.2-C8 / C10', title: 'Ring — 99, 99.9, 100'),
            _RingSwitchover(),
            _Section(
              id: '2.2-C13',
              title: 'Ring — caption at 80 and 88, none at 60',
            ),
            _RingCaptions(),
            _Section(id: '2.6-MC-1 / 2 / 3', title: 'Rows in a hairline group'),
            _Rows(),
            _Section(id: '2.7-MC-1 / MC-4', title: 'Error notice — strip and toast'),
            _Notices(),
            _Section(id: '2.7-MC-2 / MC-5', title: 'Failed item'),
            _FailedItems(),
            _Section(id: '2.7 (AC22-25)', title: 'Destructive action pair'),
            _Destructive(),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.id, required this.title});

  final String id;
  final String title;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Padding(
      padding: const EdgeInsets.only(top: 32, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            id,
            style: tokens.typography.microLabel.style.copyWith(
              color: tokens.color.accentIndigo,
            ),
          ),
          const SizedBox(height: 2),
          Text(title, style: tokens.typography.cardHeading.style),
        ],
      ),
    );
  }
}

class _RingSizes extends StatelessWidget {
  const _RingSizes();

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CompletionRing(value: 62, size: CompletionRingSize.inline),
        CompletionRing(
          value: 62,
          size: CompletionRingSize.specimen,
          caption: 'Backlog',
        ),
        CompletionRing(
          value: 62,
          size: CompletionRingSize.detail,
          caption: 'Backlog',
        ),
      ],
    );
  }
}

class _RingSweep extends StatelessWidget {
  const _RingSweep();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        CompletionRing(value: 0, size: CompletionRingSize.inline),
        CompletionRing(value: 25, size: CompletionRingSize.inline),
        CompletionRing(value: 50, size: CompletionRingSize.inline),
        CompletionRing(value: 75, size: CompletionRingSize.inline),
        CompletionRing(value: 100, size: CompletionRingSize.inline),
        CompletionRing(value: 0, size: CompletionRingSize.detail),
        CompletionRing(value: 100, size: CompletionRingSize.detail),
      ],
    );
  }
}

class _RingOutOfRange extends StatelessWidget {
  const _RingOutOfRange();

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 16,
      children: [
        CompletionRing(value: -5, size: CompletionRingSize.specimen),
        CompletionRing(value: 140, size: CompletionRingSize.specimen),
      ],
    );
  }
}

class _RingSwitchover extends StatelessWidget {
  const _RingSwitchover();

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 16,
      children: [
        CompletionRing(value: 99, size: CompletionRingSize.specimen),
        CompletionRing(value: 99.9, size: CompletionRingSize.specimen),
        CompletionRing(value: 100, size: CompletionRingSize.specimen),
      ],
    );
  }
}

class _RingCaptions extends StatelessWidget {
  const _RingCaptions();

  @override
  Widget build(BuildContext context) {
    return const Row(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CompletionRing(
          value: 48,
          size: CompletionRingSize.inline,
          caption: 'Dropped at 60',
        ),
        CompletionRing(
          value: 48,
          size: CompletionRingSize.specimen,
          caption: 'Playing',
        ),
        CompletionRing(
          value: 48,
          size: CompletionRingSize.detail,
          caption: 'Playing',
        ),
      ],
    );
  }
}

class _Rows extends StatelessWidget {
  const _Rows();

  @override
  Widget build(BuildContext context) {
    return const Column(
      spacing: 16,
      children: [
        HairlineGroup(
          children: [
            LabelValueRow(label: 'Platform', value: 'PlayStation 5'),
            LabelValueRow(label: 'Playtime', value: '42h 10m'),
            LabelValueRow(
              label: 'Storefront',
              value: 'Steam',
              showChevron: true,
            ),
          ],
        ),
        HairlineGroup(
          children: [
            LabelValueRow(
              label: 'A single row, to confirm no hairline above or below',
              value: 'None',
            ),
          ],
        ),
      ],
    );
  }
}

class _Notices extends StatefulWidget {
  const _Notices();

  @override
  State<_Notices> createState() => _NoticesState();
}

class _NoticesState extends State<_Notices> {
  bool _stripVisible = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (_stripVisible)
          ErrorNotice(
            variant: ErrorNoticeVariant.strip,
            message: 'Could not reach the library. Check your connection.',
            onDismiss: () => setState(() => _stripVisible = false),
          )
        else
          OutlinedButton(
            onPressed: () => setState(() => _stripVisible = true),
            child: const Text('Show the strip again'),
          ),
        ErrorNotice(
          variant: ErrorNoticeVariant.toast,
          message: 'That did not save.',
          onDismiss: () {},
        ),
      ],
    );
  }
}

class _FailedItems extends StatelessWidget {
  const _FailedItems();

  static const _game = GameEntity(
    id: 1,
    name: 'A game with cover art',
    cover: GameCoverEntity(
      url: 'https://images.igdb.com/igdb/image/upload/t_cover_big/co1r7f.jpg',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 16,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          width: 140,
          child: FailedItem(
            semanticsLabel: 'Failed to sync',
            child: GameCard(
              size: GameCardSize.md,
              game: _game,
              inLibrary: true,
              status: LibraryStatus.playing,
            ),
          ),
        ),
        const SizedBox(
          width: 140,
          child: FailedItem(
            semanticsLabel: 'Failed to sync',
            child: GameCard(size: GameCardSize.md, game: _game),
          ),
        ),
      ],
    );
  }
}

class _Destructive extends StatelessWidget {
  const _Destructive();

  @override
  Widget build(BuildContext context) {
    return DestructiveActionPair(
      destructiveLabel: 'Remove',
      safeLabel: 'Keep',
      onDestructive: () {},
      onSafe: () {},
    );
  }
}
