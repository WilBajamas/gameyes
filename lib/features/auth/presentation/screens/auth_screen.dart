import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/config/route/auto_route_config.gr.dart';
import 'package:gaming_library_assessment_flutter/core/di/service_locator.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/entities/sign_in_provider.dart';
import 'package:gaming_library_assessment_flutter/features/auth/presentation/blocs/sign_in_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/auth/presentation/blocs/sign_in_state.dart';
import 'package:gaming_library_assessment_flutter/generated/l10n.dart';
import 'package:gaming_library_assessment_flutter/widgets/button_press_scale.dart';
import 'package:gaming_library_assessment_flutter/widgets/logo_placeholder.dart';

part '../widgets/legal_footer.dart';
part '../widgets/provider_action_button.dart';

// TODO: Temporary - Replace with actual legal URLs later
const _temporaryLegalUrl = 'https://google.com';

@RoutePage()
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (_) => getIt<SignInCubit>(),
    child: Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: const _AuthContent(),
            ),
          ],
        ),
      ),
    ),
  );
}

class _AuthContent extends StatelessWidget {
  const _AuthContent();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
      child: BlocBuilder<SignInCubit, SignInState>(
        builder: (context, state) {
          final loading = state.status == SignInStatus.loading;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(child: LogoPlaceholder(width: 88, height: 88)),
              const SizedBox(height: 32),
              Text(
                tokens.typography.welcomeHeadline.format(S.current.auth_title),
                style: tokens.typography.welcomeHeadline.style,
              ),
              const SizedBox(height: 8),
              Text(S.current.auth_lead, style: tokens.typography.body.style),
              const SizedBox(height: 28),
              _ProviderActionButton(
                label: S.current.continue_with_discord,
                assetPath: 'assets/icons/discord-logo.png',
                fill: tokens.color.accentIndigo,
                enabled: !loading,
                loading: state.activeProvider == SignInProvider.discord,
                loadingLabel: S.current.auth_signing_in('Discord'),
                onPressed: () =>
                    context.read<SignInCubit>().signIn(SignInProvider.discord),
              ),
              const SizedBox(height: 10),
              _ProviderActionButton(
                label: S.current.continue_with_google,
                assetPath: 'assets/icons/google-logo.png',
                fill: tokens.color.surfaceRaised,
                enabled: !loading,
                loading: state.activeProvider == SignInProvider.google,
                loadingLabel: S.current.auth_signing_in('Google'),
                onPressed: () =>
                    context.read<SignInCubit>().signIn(SignInProvider.google),
              ),
              if (state.status == SignInStatus.failed) ...[
                const SizedBox(height: 10),
                const _InlineSignInError(),
              ],
              const SizedBox(height: 14),
              Text(
                S.current.auth_scope_reassurance,
                style: tokens.typography.meta.style,
              ),
              const Spacer(),
              _LegalFooter(
                onTermsPressed: () => context.router.push(
                  AppWebViewRoute(url: Uri.parse(_temporaryLegalUrl)),
                ),
                onPrivacyPressed: () => context.router.push(
                  AppWebViewRoute(url: Uri.parse(_temporaryLegalUrl)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InlineSignInError extends StatelessWidget {
  const _InlineSignInError();

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.error_outline, color: tokens.color.error, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            S.current.auth_sign_in_error,
            style: tokens.typography.meta.style.copyWith(
              color: tokens.color.errorInk,
            ),
          ),
        ),
      ],
    );
  }
}
