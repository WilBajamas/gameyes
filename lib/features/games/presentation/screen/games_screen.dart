import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/filter/presentation/widget/filter_bottom_sheet.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item.dart';

class GamesScreen extends StatelessWidget {
  const GamesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, _) => [
            SliverAppBar(
              backgroundColor: context.themeData.colorScheme.primary,
              actions: [
                IconButton(
                  onPressed: () => showModalBottomSheet(
                    context: context,
                    builder: (context) => const FilterBottomSheet(),
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
            onRefresh: () async {},
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) => const GameItem(
                imageUrl: null,
                name: 'name',
                date: '2020-01-01',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
