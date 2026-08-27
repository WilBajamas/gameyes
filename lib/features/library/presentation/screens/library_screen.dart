import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_sliver_app_bar.dart';
import 'package:gaming_library_assessment_flutter/widgets/empty_state_card.dart';

import '../../../../generated/l10n.dart';

@RoutePage()
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            DefaultSliverAppBar(title: S.current.library),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverToBoxAdapter(
                child: EmptyStateCard(
                  headline: S.current.no_games_saved,
                  supportingLine: S.current.no_games_saved_description,
                  actionLabel: S.current.browse_games,
                  onActionPressed: () =>
                      AutoTabsRouter.of(context).setActiveIndex(2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
