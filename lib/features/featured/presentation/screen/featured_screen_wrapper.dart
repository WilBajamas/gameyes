import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/bloc/featured_bloc.dart';
import 'package:gaming_library_assessment_flutter/features/featured/presentation/screen/featured_screen.dart';

class FeaturedScreenWrapper extends StatelessWidget {
  const FeaturedScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FeaturedBloc(),
      child: const FeaturedScreen(),
    );
  }
}
