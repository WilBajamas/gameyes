import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/filter/presentation/cubit/filter_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/filter/presentation/widget/filter_bottom_sheet.dart';
import 'package:gaming_library_assessment_flutter/features/games/presentation/bloc/games_bloc.dart';
import 'package:gaming_library_assessment_flutter/features/home/presentation/notifier/scroll_notifier.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_retry_widget.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item_grid_loading_shimmer.dart';

class GamesScreen extends StatefulWidget {
  const GamesScreen({Key? key}) : super(key: key);

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
    _fetchGames();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _fetchGames({bool resetPage = true}) {
    final filterState = context.read<FilterCubit>().state;
    context.read<GamesBloc>().add(
          GamesFetched(
            resetPage: resetPage,
            searchTerm: filterState.searchTerm,
            dateFrom: filterState.dateFrom,
            dateTo: filterState.dateTo,
            platforms: [filterState.gamesPlatform],
            ordering: filterState.ordering,
          ),
        );
  }

  void _onScroll() {
    _scrollChangeNotifier.isScrolled =
        _scrollController.position.userScrollDirection;

    if (_isBottom) {
      _fetchGames(resetPage: false);
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
        child: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              actions: [
                IconButton(
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => FilterBottomSheet(
                      onSaveClick: () => _fetchGames(),
                    ),
                    isScrollControlled: true,
                    showDragHandle: true,
                  ),
                  icon: const Icon(
                    Icons.filter_list,
                  ),
                ),
              ],
            ),
          ],
          body: RefreshIndicator(
            onRefresh: () async {
              _fetchGames();
            },
            child: BlocBuilder<GamesBloc, GamesState>(
              builder: (context, state) {
                switch (state.status) {
                  case GamesStatus.failure:
                    return Center(
                      child: ErrorRetryWidget(
                        onRetryClicked: () => _fetchGames(),
                      ),
                    );
                  case GamesStatus.success:
                    if (state.games.isEmpty) {
                      return Center(
                        child: ErrorRetryWidget(
                          text: context.localisations.no_results_found,
                          onRetryClicked: () => _fetchGames(),
                        ),
                      );
                    }
                    return GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.6,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return GameItem(
                          game: state.games[index],
                        );
                      },
                      itemCount: state.games.length,
                      controller: _scrollController,
                    );
                  case GamesStatus.initial:
                    return const GameItemGridLoadingShimmer();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
