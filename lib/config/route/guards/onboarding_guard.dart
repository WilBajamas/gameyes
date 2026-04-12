import 'package:auto_route/auto_route.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/core/services/storage/shared_preferences.dart';

class OnboardingGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) async {
    final preferences = getIt<SharedPreference>();
    final isFirstUse = await preferences.readValue<bool>(
      StorageConstants.firstUseKey,
    );

    if (isFirstUse == null || isFirstUse == false) {
      router.navigate(OnboardingRoute());
    } else {
      resolver.next();
    }
  }
}
