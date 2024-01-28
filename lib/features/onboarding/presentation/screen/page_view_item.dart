import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:lottie/lottie.dart';

class PageViewItem extends StatelessWidget {
  final String description;
  final String animationPath;

  const PageViewItem({
    required this.description,
    required this.animationPath,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox(
            height: context.screenHeight * 0.5,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Lottie.asset(
                  '${PathConstants.lottieAnimationAssetPath}$animationPath',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          const SizedBox(height: 30),
          //** Onboard description */
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              description,
              style: context.themeData.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
