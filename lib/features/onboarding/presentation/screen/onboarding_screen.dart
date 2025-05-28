import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/storage/shared_preferences.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/screen/page_view_item.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_filled_button_full_width.dart';
import 'package:go_router/go_router.dart';

import '../../../../generated/l10n.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  Map<String, String> get titleAndAnimations => {
        S.current.onboarding_description_one:
            AssetConstants.onboardingAnimation1,
        S.current.onboarding_description_two:
            AssetConstants.onboardingAnimation2,
        S.current.onboarding_description_three:
            AssetConstants.onboardingAnimation3,
      };

  final _pageController = PageController();

  bool _isLastPage = false;

  void skipClicked() {
    getIt<SharedPreference>().writeValue(StorageConstants.firstUseKey, true);
    context.go(RouteConstants.featured);
  }

  void nextButtonClick() {
    !_isLastPage
        ? _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeIn,
          )
        : skipClicked();
  }

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
                  onPressed: () => skipClicked(),
                  child: Text(
                    S.current.skip,
                    style: context.themeData.textTheme.bodyLarge,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) => setState(
                  () => _isLastPage = titleAndAnimations.length - 1 == index,
                ),
                itemCount: titleAndAnimations.length,
                itemBuilder: (context, index) => PageViewItem(
                  description: titleAndAnimations.entries.toList()[index].key,
                  animationPath:
                      titleAndAnimations.entries.toList()[index].value,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: DefaultFilledButtonFullWidth(
                _isLastPage
                    ? S.current.skip
                    : S.current.next,
                () => nextButtonClick(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
