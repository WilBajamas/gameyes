import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_cached_network_image.dart';

void main() {
  Widget wrap(Widget child) => MaterialApp(home: Scaffold(body: child));

  testWidgets(
    'shows the default spinner while no placeholder is supplied and the '
    'image has not resolved',
    (tester) async {
      await tester.pumpWidget(
        wrap(const DefaultCachedNetworkImage(imageUrl: 'https://x.test/a.png')),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    },
  );

  testWidgets('supplies its own non-null errorWidget when none is supplied', (
    tester,
  ) async {
    await tester.pumpWidget(
      wrap(const DefaultCachedNetworkImage(imageUrl: 'https://x.test/a.png')),
    );

    final cachedImage = tester.widget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );

    expect(cachedImage.errorWidget, isNotNull);
  });

  testWidgets('leaves imageBuilder null when none is supplied', (tester) async {
    await tester.pumpWidget(
      wrap(const DefaultCachedNetworkImage(imageUrl: 'https://x.test/a.png')),
    );

    final cachedImage = tester.widget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );

    expect(cachedImage.imageBuilder, isNull);
  });

  testWidgets('passes a supplied imageBuilder through to CachedNetworkImage', (
    tester,
  ) async {
    Widget imageBuilder(BuildContext context, ImageProvider image) =>
        const SizedBox.shrink();

    await tester.pumpWidget(
      wrap(
        DefaultCachedNetworkImage(
          imageUrl: 'https://x.test/a.png',
          imageBuilder: imageBuilder,
        ),
      ),
    );

    final cachedImage = tester.widget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );

    expect(cachedImage.imageBuilder, same(imageBuilder));
  });

  testWidgets('passes a supplied placeholder through to CachedNetworkImage', (
    tester,
  ) async {
    Widget placeholder(BuildContext context, String url) =>
        const SizedBox.shrink();

    await tester.pumpWidget(
      wrap(
        DefaultCachedNetworkImage(
          imageUrl: 'https://x.test/a.png',
          placeholder: placeholder,
        ),
      ),
    );

    final cachedImage = tester.widget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );

    expect(cachedImage.placeholder, same(placeholder));
  });

  testWidgets('passes a supplied errorWidget through to CachedNetworkImage', (
    tester,
  ) async {
    Widget errorWidget(BuildContext context, String url, Object error) =>
        const SizedBox.shrink();

    await tester.pumpWidget(
      wrap(
        DefaultCachedNetworkImage(
          imageUrl: 'https://x.test/a.png',
          errorWidget: errorWidget,
        ),
      ),
    );

    final cachedImage = tester.widget<CachedNetworkImage>(
      find.byType(CachedNetworkImage),
    );

    expect(cachedImage.errorWidget, same(errorWidget));
  });
}
