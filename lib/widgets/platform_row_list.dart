import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/domain/entities/platform_entity.dart';

class PlatformRowList extends StatelessWidget {
  final List<PlatformEntity> platforms;
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
      separatorBuilder: (_, index) => const SizedBox(width: 2),
      itemBuilder: (context, index) {
        final remainingItemsCount = platforms.length - showMax;

        return index == showMax && remainingItemsCount > 0
            ? Text(
                '+${_itemCountAndRemaining.$2}',
                style: const TextStyle(fontSize: 12),
              )
            : platforms[index].platformLogo?.url != null
            ? Image.network(platforms[index].platformLogo!.url!)
            : const SizedBox.shrink();
      },
    );
  }
}
