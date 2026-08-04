import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/config/theme/tokens/app_tokens.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/blocs/welcome_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'welcome_screen_test.mocks.dart';

@GenerateMocks([SharedPreferences, StackRouter])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  late MockSharedPreferences preferences;
  late MockStackRouter router;

  setUpAll(() async {
    await S.load(const Locale('en'));
  });

  setUp(() {
    preferences = MockSharedPreferences();
    router = MockStackRouter();
    when(router.replace<dynamic>(any)).thenAnswer((_) async => null);
    getIt.registerFactory<WelcomeCubit>(() => WelcomeCubit(preferences));
  });

  tearDown(() async {
    reset(preferences);
    await GetIt.instance.reset();
  });

  testWidgets('shows the first step with its copy and active first dot', (
    tester,
  ) async {
    await _pumpWelcome(tester);

    expect(find.text(S.current.welcome_headline_one), findsOneWidget);
    expect(find.text(S.current.welcome_body_one), findsOneWidget);
    expect(_countDots(tester, 22), 1);
    expect(_countDots(tester, 5), 1);
    expect(_countGreen(tester), 1);
  });

  testWidgets('moves to the second step without writing the seen flag', (
    tester,
  ) async {
    await _pumpWelcome(tester);

    await tester.tap(find.text(S.current.next));
    await tester.pumpAndSettle();

    expect(find.text(S.current.welcome_headline_two), findsOneWidget);
    expect(find.text(S.current.welcome_body_two), findsOneWidget);
    expect(find.text(S.current.skip), findsNothing);
    expect(_countDots(tester, 22), 1);
    expect(_countDots(tester, 5), 1);
    expect(_countGreen(tester), 1);
    verifyNever(preferences.setBool(StorageConstants.firstUseKey, true));
  });

  testWidgets('writes the seen flag when Skip exits the first step', (
    tester,
  ) async {
    when(
      preferences.setBool(StorageConstants.firstUseKey, true),
    ).thenAnswer((_) async => true);
    await _pumpWelcome(tester, router: router);

    await tester.tap(find.text(S.current.skip));
    await tester.pump();

    verify(preferences.setBool(StorageConstants.firstUseKey, true)).called(1);
    expect(
      verify(router.replace<dynamic>(captureAny)).captured.single,
      isA<AuthRoute>(),
    );
  });

  testWidgets('writes the seen flag when Get started exits the second step', (
    tester,
  ) async {
    when(
      preferences.setBool(StorageConstants.firstUseKey, true),
    ).thenAnswer((_) async => true);
    await _pumpWelcome(tester, router: router);

    await tester.tap(find.text(S.current.next));
    await tester.pumpAndSettle();
    await tester.tap(find.text(S.current.get_started));
    await tester.pump();

    verify(preferences.setBool(StorageConstants.firstUseKey, true)).called(1);
    expect(
      verify(router.replace<dynamic>(captureAny)).captured.single,
      isA<AuthRoute>(),
    );
  });

  testWidgets('collapses the switcher duration when motion is reduced', (
    tester,
  ) async {
    await _pumpWelcome(tester, disableAnimations: true);

    final switcher = tester.widget<AnimatedSwitcher>(
      find.byType(AnimatedSwitcher),
    );

    expect(switcher.duration, Duration.zero);
  });

  testWidgets('does not overflow on a short viewport with larger text', (
    tester,
  ) async {
    await _pumpWelcome(
      tester,
      size: const Size(360, 600),
      textScaleFactor: 1.5,
    );

    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpWelcome(
  WidgetTester tester, {
  Size size = const Size(390, 844),
  double textScaleFactor = 1,
  bool disableAnimations = false,
  StackRouter? router,
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final app = MediaQuery(
    data: MediaQueryData(
      size: size,
      textScaler: TextScaler.linear(textScaleFactor),
      disableAnimations: disableAnimations,
    ),
    child: MaterialApp(theme: buildDarkTheme(), home: const OnboardingScreen()),
  );
  await tester.pumpWidget(
    router == null
        ? app
        : StackRouterScope(controller: router, stateHash: 0, child: app),
  );
  await tester.pumpAndSettle();
  expect(find.byType(OnboardingScreen), findsOneWidget);
}

int _countDots(WidgetTester tester, double width) {
  return tester
      .widgetList<Container>(find.byType(Container))
      .where((container) => container.constraints?.maxWidth == width)
      .length;
}

int _countGreen(WidgetTester tester) {
  return tester
      .widgetList<Container>(find.byType(Container))
      .where(
        (container) =>
            container.decoration is BoxDecoration &&
            (container.decoration as BoxDecoration).color ==
                AppTokens.dark.color.green,
      )
      .length;
}
