import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_cached_network_image.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets(
    'shows the default spinner when no placeholder is supplied',
    (tester) async {
      await tester.pumpWidget(
        wrap(const DefaultCachedNetworkImage(imageUrl: 'https://x.test/a.png')),
      );

      final cachedImage = tester.widget<CachedNetworkImage>(
        find.byType(CachedNetworkImage),
      );
      final context = tester.element(find.byType(CachedNetworkImage));
      final placeholder = cachedImage.placeholder!(
        context,
        'https://x.test/a.png',
      );

      await tester.pumpWidget(wrap(placeholder));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets('shows the default error icon when no errorWidget is supplied', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(const DefaultCachedNetworkImage(imageUrl: 'https://x.test/a.png')),
    );

    final cachedImage = tester.widget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );
    final context = tester.element(find.byType(CachedNetworkImage));
    final errorWidget = cachedImage.errorWidget!(
      context,
      'https://x.test/a.png',
      Exception('failed'),
    );

    await tester.pumpWidget(wrap(errorWidget));

    expect(find.byIcon(Icons.error), findsOneWidget);
  });

  testWidgets('leaves imageBuilder null when none is supplied', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(const DefaultCachedNetworkImage(imageUrl: 'https://x.test/a.png')),
    );

    final cachedImage = tester.widget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );

    expect(cachedImage.imageBuilder, isNull);
  });
}
