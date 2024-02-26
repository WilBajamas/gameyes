import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class PlatformRowList extends StatelessWidget {
  PlatformRowList({Key? key}) : super(key: key);

// ! Pass real platforms
  final assetlist = [
    'icon_android.png',
    'icon_apple.png',
    'icon_atari.png',
    'icon_linux.png',
    'icon_nintendo.png',
    'icon_playstation.png',
    'icon_sega.png',
    'icon_web.png',
    'icon_wii.png',
    'icon_windows.png',
    'icon_xbox.png',
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: 5,
      physics: const NeverScrollableScrollPhysics(),
      separatorBuilder: (_, index) => const SizedBox(
        width: 2,
      ),
      itemBuilder: (context, index) {
        final remainingItemsCount = assetlist.length - 4;

        return index == 4 && remainingItemsCount > 0
            ? Text(
                '+$remainingItemsCount',
                style: const TextStyle(
                  fontSize: 12,
                ),
              )
            : Image.asset(
                'assets/images/${assetlist[index]}',
                color: context.themeData.colorScheme.onBackground,
              );
      },
    );
  }
}
