import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_sliver_app_bar.dart';

import '../../../../generated/l10n.dart';

@RoutePage()
class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            DefaultSliverAppBar(title: S.current.feed),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(child: Text(S.current.coming_soon)),
            ),
          ],
        ),
      ),
    );
  }
}
