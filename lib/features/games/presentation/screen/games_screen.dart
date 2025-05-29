import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/filter/presentation/widget/filter_bottom_sheet.dart';
import 'package:gaming_library_assessment_flutter/features/games/presentation/bloc/games_bloc.dart';
import 'package:gaming_library_assessment_flutter/features/home/presentation/notifier/scroll_notifier.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_sliver_app_bar.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_retry_widget.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item_grid_loading_shimmer.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({super.key});

  @override
  State<GamesScreen> createState() => _GamesScreenState();
}

class _GamesScreenState extends State<GamesScreen> {
  final _scrollController = ScrollController();
  final _scrollChangeNotifier = getIt.get<ScrollNotifier>();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _fetchNextPage() => context.read<GamesBloc>().add(
        const GamesNextPage(),
      );

  void _onScroll() {
    _scrollChangeNotifier.isScrolled =
        _scrollController.position.userScrollDirection;

    if (_isBottom &&
        context.read<GamesBloc>().state.nextPageStatus !=
            GamesNextPageStatus.failed) {
      _fetchNextPage();
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<GamesBloc, GamesState>(
          builder: (context, state) {
            return CustomScrollView(
              controller: _scrollController,
              slivers: [
                const GamesAppBar(),
                if (state.status == GamesStatus.success)
                  CupertinoSliverRefreshControl(
                    onRefresh: () async => context.read<GamesBloc>().add(
                          const GamesFetched(),
                        ),
                  ),
                if (state.status == GamesStatus.success)
                  const GamesSliverGrid(),
                if (state.nextPageStatus == GamesNextPageStatus.loading)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 14,
                      ),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  ),
                if (state.nextPageStatus == GamesNextPageStatus.failed)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      child: ErrorRetryWidget(
                        onRetryClicked: _fetchNextPage,
                      ),
                    ),
                  ),
                if (state.status == GamesStatus.failed)
                  SliverFillRemaining(
                    child: Center(
                      child: ErrorRetryWidget(
                        onRetryClicked: () => context.read<GamesBloc>().add(
                              const GamesFetched(),
                            ),
                      ),
                    ),
                  ),
                if (state.status == GamesStatus.empty)
                  SliverFillRemaining(
                    child: Center(
                      child: ErrorRetryWidget(
                        text: S.current.no_results_found,
                        onRetryClicked: () => context.read<GamesBloc>().add(
                              const GamesFetched(),
                            ),
                      ),
                    ),
                  ),
                if (state.status == GamesStatus.loading)
                  const SliverFillRemaining(
                    child: GameItemGridLoadingShimmer(),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class GamesSliverGrid extends StatelessWidget {
  const GamesSliverGrid({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GamesBloc>().state;
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemCount: state.games.length,
        itemBuilder: (context, index) => GameItem(
          fromScreen: RouteConstants.games,
          game: state.games[index],
          onItemClick: () {
            final extra = (
              state.games[index].id!,
              RouteConstants.games,
              state.games[index].backgroundImage
            );
            context.push(
              RouteConstants.gameDetail,
              extra: extra,
            );
          },
        ),
      ),
    );
  }
}

class GamesAppBar extends StatelessWidget {
  const GamesAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultSliverAppBar(
      title: S.current.games,
      subtitle: S.current.games_screen_subtitle,
      actionOne: (
        IconButton(
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (bottomSheetContext) => FilterBottomSheet(
                onSaveClick: (filter) => context.read<GamesBloc>().add(
                      GamesFetched(
                        searchTerm: filter.searchTerm,
                        dateFrom: filter.dateFrom,
                        dateTo: filter.dateTo,
                        platforms: filter.platforms,
                        ordering: filter.ordering,
                        genres: filter.genres,
                        ascending: filter.ascending,
                      ),
                    ),
                filterState: context.read<GamesBloc>().state.filterState,
              ),
              isScrollControlled: true,
              showDragHandle: true,
            );
          },
          icon: Icon(
            Icons.filter_list,
            color: context.themeData.colorScheme.onSurface,
          ),
        ),
        null
      ),
    );
  }
}
