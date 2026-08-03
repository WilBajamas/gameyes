import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/blocs/welcome_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/blocs/welcome_state.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/widgets/cover_tile.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/widgets/welcome_container.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/widgets/welcome_key_art.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/widgets/welcome_skip_text.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/widgets/welcome_stat_pill.dart';
import 'package:gaming_library_assessment_flutter/widgets/primary_button.dart';

import '../../../../generated/l10n.dart';

@RoutePage()
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<WelcomeCubit>(),
      child: const _WelcomeView(),
    );
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView();

  @override
  Widget build(BuildContext context) {
    return BlocListener<WelcomeCubit, WelcomeState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == WelcomeStatus.finished) {
          context.replaceRoute(HomeRoute());
        }
      },
      child: BlocBuilder<WelcomeCubit, WelcomeState>(
        builder: (context, state) {
          final tokens = context.tokens;
          return Scaffold(
            body: PopScope(
              canPop: state.step == WelcomeStep.one,
              onPopInvokedWithResult: (didPop, _) {
                if (!didPop && state.step == WelcomeStep.two) {
                  context.read<WelcomeCubit>().back();
                }
              },
              child: AnimatedSwitcher(
                duration: tokens.motion.resolve(
                  context,
                  tokens.motion.screenTransition,
                ),
                switchInCurve: tokens.motion.screenTransitionCurve,
                switchOutCurve: tokens.motion.screenTransitionCurve,
                child: state.step == WelcomeStep.one
                    ? const _WelcomeStepOne(key: ValueKey(WelcomeStep.one))
                    : const _WelcomeStepTwo(key: ValueKey(WelcomeStep.two)),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WelcomeStepOne extends StatelessWidget {
  const _WelcomeStepOne({super.key});

  @override
  Widget build(BuildContext context) {
    return WelcomeContainer(
      step: WelcomeStep.one,
      heroContent: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 38,
            bottom: 96,
            child: Transform.rotate(
              angle: -0.157,
              child: const CoverTile(width: 100, height: 134),
            ),
          ),
          Positioned(
            right: 34,
            bottom: 88,
            child: Transform.rotate(
              angle: 0.175,
              child: const CoverTile(width: 100, height: 134),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 112,
            child: Center(
              child: Transform.rotate(
                angle: 0.035,
                child: const CoverTile(
                  width: 124,
                  height: 166,
                  showsPlaying: true,
                  hasFloatShadow: true,
                ),
              ),
            ),
          ),
          const Positioned(
            left: 24,
            right: 24,
            bottom: 34,
            child: WelcomeStatPill(),
          ),
        ],
      ),
      actions: Row(
        children: [
          Expanded(
            child: PrimaryButton(
              label: S.current.next,
              onPressed: context.read<WelcomeCubit>().next,
            ),
          ),
          const SizedBox(width: 10),
          SkipTextAction(
            label: S.current.skip,
            onPressed: context.read<WelcomeCubit>().finish,
          ),
        ],
      ),
    );
  }
}

class _WelcomeStepTwo extends StatelessWidget {
  const _WelcomeStepTwo({super.key});

  @override
  Widget build(BuildContext context) {
    return WelcomeContainer(
      step: WelcomeStep.two,
      heroContent: const WelcomeKeyArt(),
      socialProof: const _WelcomeSocialProof(),
      actions: PrimaryButton(
        label: S.current.get_started,
        onPressed: context.read<WelcomeCubit>().finish,
      ),
    );
  }
}

class _WelcomeSocialProof extends StatelessWidget {
  const _WelcomeSocialProof();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      children: [
        SizedBox(
          width: 62,
          height: 34,
          child: Stack(
            clipBehavior: Clip.none,
            children: const [
              Positioned(
                left: 0,
                child: CoverTile(width: 26, height: 34, mini: true),
              ),
              Positioned(
                left: 18,
                child: CoverTile(width: 26, height: 34, mini: true),
              ),
              Positioned(
                left: 36,
                child: CoverTile(width: 26, height: 34, mini: true),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            S.current.welcome_social_proof,
            style: tokens.typography.caption.style,
          ),
        ),
      ],
    );
  }
}
