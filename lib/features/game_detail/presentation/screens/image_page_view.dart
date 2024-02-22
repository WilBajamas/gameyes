import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_screenshot.dart';
import 'package:go_router/go_router.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';

class ImagePageView extends StatelessWidget {
  final (List<String?> images, int indexTapped) pageViewInfo;
  const ImagePageView({Key? key, required this.pageViewInfo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.cancel_outlined),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                height: context.screenHeight / 3,
                child: ScrollSnapList(
                  initialIndex: pageViewInfo.$2.toDouble(),
                  onItemFocus: (int _) {},
                  itemSize: context.screenWidth,
                  itemBuilder: (_, index) => GameScreenshot(
                    imageUrl: pageViewInfo.$1[index],
                    borderRadius: 0,
                  ),
                  itemCount: pageViewInfo.$1.length,
                  duration: 200,
                  scrollPhysics: const PageScrollPhysics(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
