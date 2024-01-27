import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item.dart';

class FeaturedScreen extends StatelessWidget {
  const FeaturedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              stretchTriggerOffset: 300.0,
              expandedHeight: context.screenHeight / 4,
              flexibleSpace: const FlexibleSpaceBar(
                title: Text(StringConstants.featured),
                background: FlutterLogo(),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            const SliverToBoxAdapter(child: MostAnticipated()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            const SliverToBoxAdapter(child: BestMetacritic()),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
            const SliverToBoxAdapter(child: RecentlyReleased()),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
          ],
        ),
      ),
    );
  }
}

class MostAnticipated extends StatelessWidget {
  const MostAnticipated({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              StringConstants.mostAnticipated,
              style: context.themeData().textTheme.displayMedium,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (context, index) => const GameItem(
                imageUrl:
                    'https://media.rawg.io/media/games/20a/20aa03a10cda45239fe22d035c0ebe64.jpg',
                name: 'Testing',
                date: 'Test date',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BestMetacritic extends StatelessWidget {
  const BestMetacritic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              StringConstants.bestMetacritic,
              style: context.themeData().textTheme.displayMedium,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (context, index) => const GameItem(
                imageUrl:
                    'https://media.rawg.io/media/games/20a/20aa03a10cda45239fe22d035c0ebe64.jpg',
                name: 'Testing',
                date: 'Test date',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecentlyReleased extends StatelessWidget {
  const RecentlyReleased({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.screenHeight / 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              StringConstants.latestReleases,
              style: context.themeData().textTheme.displayMedium,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 2,
              itemBuilder: (context, index) => const GameItem(
                imageUrl:
                    'https://media.rawg.io/media/games/20a/20aa03a10cda45239fe22d035c0ebe64.jpg',
                name: 'Testing',
                date: 'Test date',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
