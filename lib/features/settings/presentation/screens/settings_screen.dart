import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/auth/presentation/blocs/sign_out_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/auth/presentation/blocs/sign_out_state.dart';
import 'package:gaming_library_assessment_flutter/features/home/presentation/notifier/scroll_notifier.dart';
import 'package:gaming_library_assessment_flutter/widgets/button_press_scale.dart';
import 'package:gaming_library_assessment_flutter/widgets/default_sliver_app_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../generated/l10n.dart';

part '../widgets/sign_out_section.dart';

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

  // TEMP: item 9 igdb-proxy smoke test. Remove once the pipeline run
  // repoints the real client at this function.
  Future<void> _testIgdbProxy(BuildContext context) async {
    String message;
    try {
      final response = await getIt<SupabaseClient>().functions.invoke(
        'igdb-proxy',
        body: {'endpoint': 'games', 'query': 'fields name; limit 5;'},
      );
      message = 'Status ${response.status}\n${response.data}';
    } catch (e) {
      message = 'Error: $e';
    }
    if (!context.mounted) return;
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('igdb-proxy result'),
        content: SingleChildScrollView(child: Text(message)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          controller: _controller,
          physics: const BouncingScrollPhysics(),
          slivers: [
            DefaultSliverAppBar(title: S.current.settings),
            const SliverToBoxAdapter(child: Center(child: Text('Settings'))),
            // TEMP: item 9 igdb-proxy smoke test button. Remove once the
            // pipeline run repoints the real client at this function.
            SliverToBoxAdapter(
              child: Center(
                child: ElevatedButton(
                  onPressed: () => _testIgdbProxy(context),
                  child: const Text('Test igdb-proxy'),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: BlocProvider(
                create: (_) => getIt<SignOutCubit>(),
                child: const _SignOutSection(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
