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

class _WelcomeView extends StatefulWidget {
  const _WelcomeView();

  @override
  State<_WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<_WelcomeView> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Only a settled page moves the step. A partial drag snaps back and never
  // reports a change, and neither call writes anything to storage.
  void _onPageSettled(int index) {
    final cubit = context.read<WelcomeCubit>();
    if (index == 0) {
      cubit.back();
    } else {
      cubit.next();
    }
  }

  void _followStep(BuildContext context, WelcomeState state) {
    if (!_controller.hasClients) return;
    final target = state.step == WelcomeStep.one ? 0 : 1;
    // A swipe moves the page first and the step second; animating again
    // here would fight the gesture that caused it.
    if (_controller.page?.round() == target) return;

    final motion = context.tokens.motion;
    final duration = motion.resolve(context, motion.screenTransition);
    if (duration == Duration.zero) {
      _controller.jumpToPage(target);
    } else {
      _controller.animateToPage(
        target,
        duration: duration,
        curve: motion.screenTransitionCurve,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            BlocListener<WelcomeCubit, WelcomeState>(
              listener: (context, state) {
                if (state.status == WelcomeStatus.finished) {
                  context.replaceRoute(const AuthRoute());
                }
              },
            ),
            BlocListener<WelcomeCubit, WelcomeState>(listener: _followStep),
          ],
          child: BlocSelector<WelcomeCubit, WelcomeState, WelcomeStep>(
            selector: (state) => state.step,
            builder: (context, step) {
              return PopScope(
                canPop: step == WelcomeStep.one,
                onPopInvokedWithResult: (didPop, _) {
                  if (!didPop && step == WelcomeStep.two) {
                    context.read<WelcomeCubit>().back();
                  }
                },
                child: PageView(
                  controller: _controller,
                  onPageChanged: _onPageSettled,
                  children: const [_WelcomeStepOne(), _WelcomeStepTwo()],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WelcomeStepOne extends StatelessWidget {
  const _WelcomeStepOne();

  @override
  Widget build(BuildContext context) {
    return WelcomeContainer(
      step: WelcomeStep.one,
      heroHeight: WelcomeLayoutConstants.heroHeightOne,
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
  const _WelcomeStepTwo();

  @override
  Widget build(BuildContext context) {
    return WelcomeContainer(
      step: WelcomeStep.two,
      heroHeight: WelcomeLayoutConstants.heroHeightTwo,
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
