import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/features/home/presentation/notifier/scroll_notifier.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_sliver_app_bar.dart';

import '../../../../generated/l10n.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _controller = ScrollController();
  final _scrollChangeNotifier = getIt.get<ScrollNotifier>();

  @override
  void initState() {
    _controller.addListener(_onScroll);

    super.initState();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    _scrollChangeNotifier.isScrolled = _controller.position.userScrollDirection;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _controller,
          physics: const BouncingScrollPhysics(),
          slivers: [
            DefaultSliverAppBar(
              title: S.current.settings,
            ),
            const SliverToBoxAdapter(
              child: Center(child: Text('Settings')),
            ),
          ],
        ),
      ),
    );
  }
}
