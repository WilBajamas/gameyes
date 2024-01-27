import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/screen/featured_screen.dart';
import 'package:gaming_library_assessment_flutter/features/games/presentation/screen/games_screen.dart';
import 'package:gaming_library_assessment_flutter/features/home/presentation/cubit/home_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/settings/presentation/screen/settings_screen.dart';
import 'package:gaming_library_assessment_flutter/widgets/navigation_destination.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: NavigationBar(
            onDestinationSelected: (int index) =>
                context.read<HomeCubit>().selectScreenTab(index),
            selectedIndex: state.currentTabScreen.index,
            destinations: const [
              CustomNavigationDestination(
                iconData: Icons.newspaper,
                label: StringConstants.featured,
              ),
              CustomNavigationDestination(
                iconData: Icons.gamepad,
                label: StringConstants.games,
              ),
              CustomNavigationDestination(
                iconData: Icons.menu,
                label: StringConstants.settings,
              ),
            ],
          ),
          body: [
            const FeaturedScreen(),
            const GamesScreen(),
            const SettingsScreen(),
          ][state.currentTabScreen.index],
        );
      },
    );
  }
}
