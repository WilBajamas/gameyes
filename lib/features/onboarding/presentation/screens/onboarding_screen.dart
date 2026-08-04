import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/const.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/blocs/welcome_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/blocs/welcome_state.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/widgets/welcome_container.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/widgets/welcome_hero.dart';
import 'package:gaming_library_assessment_flutter/features/onboarding/presentation/widgets/welcome_skip_text.dart';
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
          context.replaceRoute(const AuthRoute());
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
      heroHeight: 400,
      hero: WelcomeHero(
        contentAsset: WelcomeAssetConstants.heroOne,
        backgroundColor: context.tokens.color.surfaceIndigoPanel,
      ),
      headline: S.current.welcome_headline_one,
      body: S.current.welcome_body_one,
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
      heroHeight: 356,
      hero: const WelcomeHero(
        contentAsset: WelcomeAssetConstants.heroTwo,
        backgroundAsset: WelcomeAssetConstants.heroTwoBackground,
      ),
      headline: S.current.welcome_headline_two,
      body: S.current.welcome_body_two,
      actions: PrimaryButton(
        label: S.current.get_started,
        onPressed: context.read<WelcomeCubit>().finish,
      ),
    );
  }
}
