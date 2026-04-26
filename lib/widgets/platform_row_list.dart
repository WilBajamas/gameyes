import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/enums/game_platform.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class PlatformRowList extends StatelessWidget {
  final List<GamePlatform> platforms;
  final int showMax;

  const PlatformRowList({super.key, required this.platforms, this.showMax = 4});

  (int, int) get _itemCountAndRemaining {
    final remaining = platforms.length - showMax;

    final indexCount = remaining <= 0 ? platforms.length : showMax + 1;

    return (indexCount, remaining);
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: _itemCountAndRemaining.$1,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, index) => const SizedBox(
        width: 2,
      ),
      itemBuilder: (context, index) {
        final remainingItemsCount = platforms.length - showMax;

        return index == showMax && remainingItemsCount > 0
            ? Text(
                '+${_itemCountAndRemaining.$2}',
                style: const TextStyle(
                  fontSize: 12,
                ),
              )
            : Image.asset(
                'assets/images/${platforms[index].assetName}',
                color: context.themeData.colorScheme.onSurface,
              );
      },
    );
  }
}
