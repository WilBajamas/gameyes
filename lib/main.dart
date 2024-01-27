import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/config/routes.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data.dart';
import 'package:gaming_library_assessment_flutter/config/theme/theme_data_dark.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/res/const.dart';
import 'package:gaming_library_assessment_flutter/features/home/presentation/cubit/home_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/home/presentation/screen/home_screen.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart'
    as injection;

void main() {
  runApp(const MyApp());
  configureDependencies();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => injection.getIt<HomeCubit>(),
          child: const HomeScreen(),
        ),
      ],
      child: MaterialApp(
        themeMode: ThemeMode.system,
        theme: buildTheme(),
        darkTheme: buildDarkTheme(),
        routes: routes,
        initialRoute: RouteConstants.root,
      ),
    );
  }
}
