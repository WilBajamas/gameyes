import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/const.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/blocs/welcome_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/widgets/welcome_container.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/primary_button.dart';
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

    final page = _page(S.current.welcome_headline_one);
    expect(find.text(S.current.welcome_headline_one), findsOneWidget);
    expect(find.text(S.current.welcome_body_one), findsOneWidget);
    expect(_countDots(tester, page, 22), 1);
    expect(_countDots(tester, page, 5), 1);
  });

  testWidgets('shows the first hero art once and no background image', (
    tester,
  ) async {
    await _pumpWelcome(tester);

    final page = _page(S.current.welcome_headline_one);
    expect(
      find.descendant(
        of: page,
        matching: _assetImage(WelcomeAssetConstants.heroOne),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: page, matching: find.byType(Image)),
      findsOneWidget,
    );
  });

  testWidgets('moves to the second step without writing the seen flag', (
    tester,
  ) async {
    await _pumpWelcome(tester);

    await tester.tap(find.text(S.current.next));
    await tester.pumpAndSettle();

    final page = _page(S.current.welcome_headline_two);
    expect(find.text(S.current.welcome_headline_two), findsOneWidget);
    expect(find.text(S.current.welcome_body_two), findsOneWidget);
    expect(
      find.descendant(of: page, matching: find.text(S.current.skip)),
      findsNothing,
    );
    expect(_countDots(tester, page, 22), 1);
    expect(_countDots(tester, page, 5), 1);
    verifyNever(preferences.setBool(StorageConstants.firstUseKey, true));
  });

  testWidgets('shows the second hero art and its background once each', (
    tester,
  ) async {
    await _pumpWelcome(tester);

    await tester.tap(find.text(S.current.next));
    await tester.pumpAndSettle();

    final page = _page(S.current.welcome_headline_two);
    expect(
      find.descendant(
        of: page,
        matching: _assetImage(WelcomeAssetConstants.heroTwo),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: page,
        matching: _assetImage(WelcomeAssetConstants.heroTwoBackground),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: page,
        matching: _assetImage(WelcomeAssetConstants.heroOne),
      ),
      findsNothing,
    );
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

  testWidgets(
    'moves to the second step when swiped forward without writing the '
    'seen flag',
    (tester) async {
      await _pumpWelcome(tester);

      await _swipe(tester, forward: true);

      expect(_page(S.current.welcome_headline_two), findsOneWidget);
      verifyNever(preferences.setBool(StorageConstants.firstUseKey, true));
    },
  );

  testWidgets('returns to the first step when swiped backward', (tester) async {
    await _pumpWelcome(tester);

    await _swipe(tester, forward: true);
    await _swipe(tester, forward: false);

    expect(_page(S.current.welcome_headline_one), findsOneWidget);
  });

  testWidgets('keeps the first page dot active while a drag is held', (
    tester,
  ) async {
    await _pumpWelcome(tester);

    final gesture = await tester.startGesture(
      tester.getCenter(find.byType(PageView)),
    );
    await gesture.moveBy(const Offset(-100, 0));
    await tester.pump();

    final page = _page(S.current.welcome_headline_one);
    expect(_countDots(tester, page, 22), 1);
    expect(_countDots(tester, page, 5), 1);

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets('changes page instantly when motion is reduced', (tester) async {
    await _pumpWelcome(tester, disableAnimations: true);

    await tester.tap(find.text(S.current.next));
    await tester.pump();

    expect(_page(S.current.welcome_headline_two), findsOneWidget);
  });

  testWidgets('keeps the action row off the bottom system inset', (
    tester,
  ) async {
    const bottomInset = 40.0;
    await _pumpWelcome(tester, bottomInset: bottomInset);

    final page = _page(S.current.welcome_headline_one);
    final actionBottom = tester
        .getBottomLeft(
          find.descendant(of: page, matching: find.byType(PrimaryButton)),
        )
        .dy;
    final safeAreaBottom = 844.0 - bottomInset;

    expect(safeAreaBottom - actionBottom, 24);
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

    await tester.tap(find.text(S.current.next));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}

Future<void> _pumpWelcome(
  WidgetTester tester, {
  Size size = const Size(390, 844),
  double textScaleFactor = 1,
  bool disableAnimations = false,
  double bottomInset = 0,
  StackRouter? router,
}) async {
  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final app = MediaQuery(
    data: MediaQueryData(
      size: size,
      textScaler: TextScaler.linear(textScaleFactor),
      disableAnimations: disableAnimations,
      padding: EdgeInsets.only(bottom: bottomInset),
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

Future<void> _swipe(WidgetTester tester, {required bool forward}) async {
  await tester.drag(find.byType(PageView), Offset(forward ? -400 : 400, 0));
  await tester.pumpAndSettle();
}

// The `WelcomeContainer` ancestor of a page's own headline — used to scope
// widget counts to the visible page, since the paging viewport may keep the
// offscreen page mounted.
Finder _page(String headline) {
  return find.ancestor(
    of: find.text(headline),
    matching: find.byType(WelcomeContainer),
  );
}

int _countDots(WidgetTester tester, Finder page, double width) {
  return tester
      .widgetList<Container>(
        find.descendant(of: page, matching: find.byType(Container)),
      )
      .where((container) => container.constraints?.maxWidth == width)
      .length;
}

Finder _assetImage(String assetName) {
  return find.byWidgetPredicate(
    (widget) =>
        widget is Image &&
        widget.image is AssetImage &&
        (widget.image as AssetImage).assetName == assetName,
  );
}
