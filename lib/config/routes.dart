import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/features/home/presentation/screen/home_screen.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/screen/onboarding_screen.dart';

final routes = {
  RouteConstants.root: (context) => OnboardingScreen(),
  RouteConstants.home: (context) => const HomeScreen(),
};
