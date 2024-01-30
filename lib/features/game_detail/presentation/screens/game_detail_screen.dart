import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_detail_section_point.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_screenshot.dart';
import 'package:gaming_library_assessment_flutter/widgets/metacritic_indicator.dart';

class GameDetailScreen extends StatelessWidget {
  final int? gameId;

  const GameDetailScreen({Key? key, required this.gameId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            const SliverAppBar(),
          ],
          body: ListView(
            padding: const EdgeInsets.only(bottom: 16),
            children: [
              const DetailTopHeader(),
              const SizedBox(height: 20),
              const DetailMidSection(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 16, bottom: 12),
                child: Text(
                  context.localisations.screenshots,
                  style: context.themeData.textTheme.displayMedium,
                ),
              ),
              const DetailScreenshotsSection(),
            ],
          ),
        ),
      ),
    );
  }
}

class DetailTopHeader extends StatelessWidget {
  const DetailTopHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight * 0.6,
      child: Stack(
        children: [
          SizedBox(
            height: context.screenHeight,
            child: Image.asset(
              'assets/images/featured_title_img.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.7), // 70% opacity
          ),
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
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: AspectRatio(
                            aspectRatio: 2 / 3,
                            child: Container(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Testing name',
                              style: context.themeData.textTheme.displayMedium!
                                  .merge(const TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Testing release date',
                              style: context.themeData.textTheme.bodyLarge!
                                  .merge(const TextStyle(color: Colors.white)),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const MetacriticIndicator(
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
                Expanded(
                  child: Text(
                    'Test description',
                    style: context.themeData.textTheme.bodyLarge,
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
  const DetailMidSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GameDetailSectionPoint(title: 'Test', value: 'test value'),
            GameDetailSectionPoint(title: 'Test', value: 'test value'),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GameDetailSectionPoint(title: 'Test', value: 'test value'),
            GameDetailSectionPoint(title: 'Test', value: 'test value'),
          ],
        ),
      ],
    );
  }
}

class DetailScreenshotsSection extends StatelessWidget {
  const DetailScreenshotsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight / 3,
      child: ListView.builder(
        padding: const EdgeInsets.only(left: 12),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => const Padding(
          padding: EdgeInsets.only(right: 12),
          child: GameScreenshot(imageUrl: ''),
        ),
      ),
    );
  }
}
