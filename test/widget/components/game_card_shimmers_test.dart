import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item_grid_loading_shimmer.dart';
import 'package:gaming_library_assessment_flutter/widgets/game_item_loading_shimmer.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  GoogleFonts.config.allowRuntimeFetching = false;

  testWidgets('renders the grid shimmer cells without throwing', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildDarkTheme(),
        home: const Scaffold(body: GameItemGridLoadingShimmer()),
      ),
    );

    expect(tester.takeException(), isNull);
  });

  testWidgets('renders the horizontal shimmer cells without throwing', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: buildDarkTheme(),
        home: const Scaffold(body: GameItemLoadingShimmer()),
      ),
    );

    expect(tester.takeException(), isNull);
  });
}
