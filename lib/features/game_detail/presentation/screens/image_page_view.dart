import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_screenshot.dart';

@RoutePage()
class ImagePageView extends StatelessWidget {
  final (List<String?> images, int indexTapped) pageViewInfo;
  const ImagePageView({super.key, required this.pageViewInfo});

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
                onPressed: () => context.router.pop(),
                icon: const Icon(Icons.cancel_outlined),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: SizedBox(
                height: context.screenHeight / 3,
                child: PageView.builder(
                  controller: PageController(initialPage: pageViewInfo.$2),
                  itemBuilder: (_, index) => GameScreenshot(
                    imageUrl: pageViewInfo.$1[index],
                    borderRadius: 0,
                  ),
                  itemCount: pageViewInfo.$1.length,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
