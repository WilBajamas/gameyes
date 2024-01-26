import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/screen/page_view_item.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_filled_button_full_width.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({Key? key}) : super(key: key);

  final descriptions = const [
    StringConstants.onboardingDescriptionOne,
    StringConstants.onboardingDescriptionTwo,
    StringConstants.onboardingDescriptionThree,
  ];

  final animations = const [
    AssetConstants.onboardingAnimation1,
    AssetConstants.onboardingAnimation2,
    AssetConstants.onboardingAnimation3,
  ];

  final _pageController = PageController();

  void nextButtonClick() => _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeIn,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: TextButton(
                  onPressed: () {
                    // TODO: To Home screen
                  },
                  child: Text(
                    StringConstants.skip,
                    style: context.themeData().textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: descriptions.length,
                itemBuilder: (context, index) => PageViewItem(
                  description: descriptions[index],
                  animationPath: animations[index],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: DefaultFilledButtonFullWidth(
                StringConstants.next,
                () => nextButtonClick(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
