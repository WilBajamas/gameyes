import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_detail_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/game_detail/presentation/cubit/game_screenshot_cubit.dart';
import 'package:gaming_library_assessment_flutter/widgets/error_retry_widget.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_detail_section_point.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_screenshot.dart';
import 'package:gaming_library_assessment_flutter/widgets/metacritic_indicator.dart';

class GameDetailScreen extends StatefulWidget {
  final int? gameId;
  final String? slug;

  const GameDetailScreen({Key? key, this.gameId, this.slug}) : super(key: key);

  @override
  State<GameDetailScreen> createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  @override
  void initState() {
    context.read<GameDetailCubit>().fetchGameDetail(id: widget.gameId!);
    context
        .read<GameScreenshotCubit>()
        .fetchGameScreenshots(slug: widget.slug!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            const SliverAppBar(),
          ],
          body: BlocBuilder<GameDetailCubit, GameDetailState>(
            builder: (context, state) {
              switch (state.status) {
                case GameDetailStatus.loading:
                  return const Center(child: CircularProgressIndicator());
                case GameDetailStatus.failed:
                  return Center(
                    child: ErrorRetryWidget(
                      onRetryClicked: () => widget.gameId != null
                          ? context
                              .read<GameDetailCubit>()
                              .fetchGameDetail(id: widget.gameId!)
                          : null,
                    ),
                  );
                case GameDetailStatus.success:
                  return ListView(
                    padding: const EdgeInsets.only(bottom: 16),
                    children: [
                      DetailTopHeader(
                        state: state,
                        id: widget.gameId,
                      ),
                      const SizedBox(height: 20),
                      DetailMidSection(state: state),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.only(left: 16, bottom: 12),
                        child: Text(
                          context.localisations.screenshots,
                          style: context.themeData.textTheme.displayLarge,
                        ),
                      ),
                      DetailScreenshotsSection(slug: widget.slug),
                    ],
                  );
              }
            },
          ),
        ),
      ),
    );
  }
}

class DetailTopHeader extends StatelessWidget {
  final GameDetailState state;
  final int? id;

  // ignore: lines_longer_than_80_chars
  const DetailTopHeader({Key? key, required this.state, this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.6,
      child: Stack(
        children: [
          // ** Background image //
          SizedBox(
            height: context.screenHeight,
            child: state.response?.backgroundImageAdditional != null
                ? Image.network(
                    state.response!.backgroundImageAdditional!,
                    fit: BoxFit.cover,
                  )
                : null,
          ),

          Container(
            color: Colors.black.withOpacity(0.7), // 70% opacity
          ),

          // ** Content //
          Container(
            padding: const EdgeInsets.all(16),
            width: context.screenWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: context.screenWidth,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ** Image //
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AspectRatio(
                            aspectRatio: 2 / 3,
                            child: CachedNetworkImage(
                              imageUrl: state.response?.backgroundImage ?? '-',
                              errorWidget: (context, _, __) => Container(
                                color: Colors.white,
                                child: Center(
                                  child: Icon(
                                    Icons.error,
                                    size: 40,
                                    color:
                                        context.themeData.colorScheme.primary,
                                  ),
                                ),
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ** Name //
                            Text(
                              state.response!.name!,
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                              style: context.themeData.textTheme.displayMedium!
                                  .merge(const TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(height: 8),
                            // ** Release date //
                            Text(
                              '${context.localisations.release_date}:',
                              style: context.themeData.textTheme.titleMedium!
                                  .copyWith(color: Colors.white),
                            ),
                            Text(
                              state.response!.released.stringToDateString(),
                              style: context.themeData.textTheme.bodyLarge!
                                  .copyWith(color: Colors.white),
                            ),
                            const SizedBox(height: 16),
                            // ** Metacritic score //
                            Row(
                              children: [
                                MetacriticIndicator(
                                  score: state.response?.metacritic,
                                  size: 60,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Text(
                                    context.localisations.metacritic_score,
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // ** Description //
                Expanded(
                  child: Text(
                    state.response!.description!,
                    overflow: TextOverflow.fade,
                    softWrap: true,
                    style: context.themeData.textTheme.bodySmall!
                        .merge(const TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailMidSection extends StatelessWidget {
  final GameDetailState state;

  const DetailMidSection({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GameDetailSectionPoint(
                  title: context.localisations.genre,
                  value: state.response!.genreListString,
                ),
                const SizedBox(height: 12),
                GameDetailSectionPoint(
                  title: context.localisations.publishers,
                  value: state.response!.publisherListString,
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GameDetailSectionPoint(
                  title: context.localisations.developers,
                  value: state.response!.developerListString,
                ),
                const SizedBox(height: 12),
                GameDetailSectionPoint(
                  title: context.localisations.platforms,
                  value: state.response!.platformListString,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailScreenshotsSection extends StatelessWidget {
  final String? slug;

  const DetailScreenshotsSection({Key? key, required this.slug})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight / 3,
      child: BlocBuilder<GameScreenshotCubit, GameScreenshotState>(
        builder: (context, state) {
          switch (state.status) {
            case ScreenshotsStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case ScreenshotsStatus.failure:
              return Center(
                child: ErrorRetryWidget(
                  onRetryClicked: () => context
                      .read<GameScreenshotCubit>()
                      .fetchGameScreenshots(slug: slug!),
                ),
              );
            case ScreenshotsStatus.success:
              if (state.response?.results != null &&
                  state.response!.results.isNotEmpty) {
                return ListView.builder(
                  padding: const EdgeInsets.only(left: 12),
                  itemCount: state.response!.results.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GameScreenshot(
                      imageUrl: state.response?.results[index].image,
                    ),
                  ),
                );
              } else {
                return Center(
                  child: ErrorRetryWidget(
                    text: context.localisations.no_results_found,
                    onRetryClicked: () => context
                        .read<GameScreenshotCubit>()
                        .fetchGameScreenshots(slug: slug!),
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
