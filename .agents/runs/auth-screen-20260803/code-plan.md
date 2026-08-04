# Code Plan
Source: `.agents/runs/auth-screen-20260803/tech-ac.md`
Date: 2026-08-03

This is a review skeleton. `task-brief.md` remains the implementation source of truth.

## Approved feedback delta

- Route legal links directly to the annotated `AppWebView`; do not create `LegalWebViewScreen`.
- Use `fvm dart ...` and `fvm flutter ...` for every Dart or Flutter command.

## CREATE NEW

### `lib/features/auth/presentation/blocs/sign_in_state.dart`

```dart
part 'sign_in_state.freezed.dart';

enum SignInStatus { idle, loading, failed }

@freezed
sealed class SignInState with _$SignInState {
  const factory SignInState({
    @Default(SignInStatus.idle) SignInStatus status,
    SignInProvider? activeProvider,
    ErrorType? error,
  }) = _SignInState;
}
```

### `lib/features/auth/presentation/blocs/sign_in_cubit.dart`

```dart
@injectable
class SignInCubit extends Cubit<SignInState> {
  SignInCubit(this._signIn) : super(const SignInState());

  final SignInUseCase _signIn;

  Future<void> signIn(SignInProvider provider) async {
    if (state.status == SignInStatus.loading) return;

    emit(SignInState(
      status: SignInStatus.loading,
      activeProvider: provider,
    ));

    final result = await _signIn(provider);
    switch (result) {
      case Success<void>():
        emit(const SignInState());
      case Failure<void>(error: SignInCancelled()):
        emit(const SignInState());
      case Failure<void>(error: final error):
        emit(SignInState(status: SignInStatus.failed, error: error));
    }
  }
}
```

### `lib/features/auth/presentation/screens/auth_screen.dart`

```dart
const _temporaryLegalUrl = 'https://google.com';

@RoutePage()
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => getIt<SignInCubit>(),
        child: const _AuthView(),
      );
}

class _AuthView extends StatelessWidget {
  const _AuthView();

  @override
  Widget build(BuildContext context) {
    final motion = context.tokens.motion;
    return BlocBuilder<SignInCubit, SignInState>(
      builder: (context, state) => Scaffold(
        body: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0, end: 1),
          duration: motion.resolve(context, motion.screenTransition),
          curve: motion.screenTransitionCurve,
          builder: (context, value, child) => Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 12 * (1 - value)),
              child: child,
            ),
          ),
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _AuthContent(state: state),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AuthContent extends StatelessWidget {
  const _AuthContent({required this.state});

  final SignInState state;

  @override
  Widget build(BuildContext context) {
    // A spacer pins legal copy low when height permits; SliverFillRemaining
    // turns the same column into reachable scroll content on short screens.
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(child: _LogoPlaceholder()),
          const SizedBox(height: 32),
          Text(S.current.auth_title, ...),
          const SizedBox(height: 8),
          Text(S.current.auth_lead, ...),
          const SizedBox(height: 28),
          _ProviderAction(
            provider: SignInProvider.discord,
            providerName: 'Discord',
            label: S.current.continue_with_discord,
            assetPath: 'assets/icons/discord-logo.svg',
            fill: context.tokens.color.accentIndigo,
            enabled: state.status != SignInStatus.loading,
            loading: state.activeProvider == SignInProvider.discord,
            onPressed: () => context.read<SignInCubit>().signIn(
                  SignInProvider.discord,
                ),
          ),
          const SizedBox(height: 10),
          _ProviderAction(
            provider: SignInProvider.google,
            providerName: 'Google',
            label: S.current.continue_with_google,
            assetPath: 'assets/icons/google-logo.svg',
            fill: context.tokens.color.surfaceRaised,
            enabled: state.status != SignInStatus.loading,
            loading: state.activeProvider == SignInProvider.google,
            onPressed: () => context.read<SignInCubit>().signIn(
                  SignInProvider.google,
                ),
          ),
          if (state.status == SignInStatus.failed) ...[
            const SizedBox(height: 10),
            const _InlineSignInError(),
          ],
          const SizedBox(height: 14),
          Text(S.current.auth_scope_reassurance, ...),
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
      ),
    );
  }
}

class _LogoPlaceholder extends StatelessWidget {
  const _LogoPlaceholder();

  @override
  Widget build(BuildContext context) => CustomPaint(
        foregroundPainter: _DashedBorderPainter(
          color: context.tokens.color.ink24,
          radius: 20,
        ),
        child: SizedBox.square(
          dimension: 88,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: context.tokens.color.ink12,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(child: Text('LOGO', ...)),
          ),
        ),
      );
}

class _ProviderAction extends StatelessWidget {
  const _ProviderAction({
    required this.provider,
    required this.providerName,
    required this.label,
    required this.assetPath,
    required this.fill,
    required this.enabled,
    required this.loading,
    required this.onPressed,
  });

  final SignInProvider provider;
  final String providerName;
  final String label;
  final String assetPath;
  final Color fill;
  final bool enabled;
  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Semantics(
        button: true,
        enabled: enabled,
        child: IgnorePointer(
          ignoring: !enabled,
          child: ButtonPressScale(
            onPressed: onPressed,
            child: SizedBox(
              height: 52,
              width: double.infinity,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: fill,
                  borderRadius: BorderRadius.circular(
                    context.tokens.radius.sm,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      assetPath,
                      width: 20,
                      height: 20,
                      fit: BoxFit.contain,
                      semanticsLabel: label,
                    ),
                    const SizedBox(width: 10),
                    Text(label, ...),
                    if (loading) ...[
                      const SizedBox(width: 10),
                      SizedBox.square(
                        dimension: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          semanticsLabel:
                              S.current.auth_signing_in(providerName),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      );
}

class _InlineSignInError extends StatelessWidget {
  const _InlineSignInError();

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, color: context.tokens.color.error, ...),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              S.current.auth_sign_in_error,
              style: ...copyWith(color: context.tokens.color.errorInk),
            ),
          ),
        ],
      );
}

class _LegalFooter extends StatelessWidget {
  const _LegalFooter({
    required this.onTermsPressed,
    required this.onPrivacyPressed,
  });

  final VoidCallback onTermsPressed;
  final VoidCallback onPrivacyPressed;

  @override
  Widget build(BuildContext context) => Text.rich(
        TextSpan(
          children: [
            TextSpan(text: S.current.auth_legal_prefix),
            WidgetSpan(child: _InlineLink(...onTermsPressed...)),
            TextSpan(text: S.current.auth_legal_middle),
            WidgetSpan(child: _InlineLink(...onPrivacyPressed...)),
            TextSpan(text: S.current.auth_legal_suffix),
          ],
        ),
        textAlign: TextAlign.center,
      );
}

class _InlineLink extends StatelessWidget { ... }

class _DashedBorderPainter extends CustomPainter {
  const _DashedBorderPainter({required this.color, required this.radius});
  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) { ...draw rounded dashed path... }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.radius != radius;
}
```

### `lib/widgets/app_web_view.dart`

```dart
@RoutePage()
class AppWebView extends StatefulWidget {
  const AppWebView({super.key, required this.url});

  final Uri url;

  @override
  State<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  late final WebViewController _controller;
  int _progress = 0;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (progress) => setState(() => _progress = progress),
        ),
      )
      ..loadRequest(widget.url);
  }

  @override
  void didUpdateWidget(covariant AppWebView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) _controller.loadRequest(widget.url);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_progress < 100)
              LinearProgressIndicator(value: _progress / 100),
          ],
        ),
      );
}
```

## MODIFY EXISTING

### `pubspec.yaml`

```yaml
dependencies:
  flutter_svg: ^2.3.0
  webview_flutter: ^4.14.1

flutter:
  assets:
    - assets/images/
    - assets/animations/
    - assets/icons/ # already present; unchanged
```

### `pubspec.lock`

```text
Dependency resolution output only: direct entries for flutter_svg 2.3.x and
webview_flutter 4.14.x plus the solver-selected transitive packages. Do not
hand-edit this file or upgrade unrelated direct dependencies.
```

### `lib/config/route/auto_route_config.dart`

```dart
List<AutoRoute> get routes => [
  AutoRoute(path: '/onboarding', page: OnboardingRoute.page),
  AutoRoute(path: '/auth', page: AuthRoute.page),
  AutoRoute(path: '/legal', page: AppWebViewRoute.page),
  AutoRoute(
    path: '/',
    page: HomeRoute.page,
    initial: true,
    guards: [OnboardingGuard()],
    children: [...],
  ),
  ...
];
```

### `lib/features/onboarding/presentation/screens/onboarding_screen.dart`

```dart
listener: (context, state) {
  if (state.status == WelcomeStatus.finished) {
    context.replaceRoute(const AuthRoute());
  }
},
```

### `lib/l10n/intl_en.arb`

```json
{
  "auth_title": "SIGN IN",
  "auth_lead": "No setup questions. Genres and platforms happen inside.",
  "continue_with_discord": "Continue with Discord",
  "continue_with_google": "Continue with Google",
  "auth_scope_reassurance": "We only read your name and avatar. Nothing gets posted.",
  "auth_sign_in_error": "Sign-in failed. Please try again.",
  "auth_signing_in": "Signing in with {provider}",
  "@auth_signing_in": {
    "placeholders": {"provider": {"type": "String"}}
  },
  "auth_legal_prefix": "By continuing, you agree to the ",
  "auth_terms": "Terms",
  "auth_legal_middle": " and ",
  "auth_privacy_policy": "Privacy Policy",
  "auth_legal_suffix": "."
}
```

### `lib/l10n/intl_zh.arb`

```json
{
  "auth_title": "登录",
  "auth_lead": "无需预先设置，进入应用后再选择游戏类型和平台。",
  "continue_with_discord": "使用 Discord 继续",
  "continue_with_google": "使用 Google 继续",
  "auth_scope_reassurance": "我们只会读取你的姓名和头像，不会发布任何内容。",
  "auth_sign_in_error": "登录失败，请重试。",
  "auth_signing_in": "正在使用 {provider} 登录",
  "@auth_signing_in": {
    "placeholders": {"provider": {"type": "String"}}
  },
  "auth_legal_prefix": "继续即表示你同意",
  "auth_terms": "条款",
  "auth_legal_middle": "和",
  "auth_privacy_policy": "隐私政策",
  "auth_legal_suffix": "。"
}
```

## TEST FILES

### `test/cubit/auth/sign_in_cubit_test.dart`

- `'should start idle without provider or error'` — verifies the default state.
- `'emits [loading, idle] when Discord sign-in starts successfully'` — verifies Discord forwarding and no success-navigation state.
- `'emits [loading, idle] when Google sign-in starts successfully'` — verifies Google forwarding.
- `'should ignore another provider while sign-in is loading'` — holds the first future open and verifies only one use-case call.
- `'emits [loading, idle] when sign-in is cancelled'` — verifies cancellation remains silent.
- `'emits [loading, failed] when sign-in fails'` — preserves the returned `ErrorType`.
- `'clears the previous error when retry starts'` — seeds failed state and verifies the loading state has no error.

### `test/widget/auth/auth_screen_test.dart`

- `'shows logo, sign-in copy, Discord before Google, reassurance, and legal links'` — verifies core content and ordering.
- `'calls SignInCubit with Discord when Discord is tapped'` — verifies provider selection.
- `'calls SignInCubit with Google when Google is tapped'` — verifies provider selection.
- `'keeps the active label and progress while both provider actions are disabled'` — verifies loading UI and lockout semantics.
- `'shows an inline retryable message only in failed state'` — verifies bounded error rendering.
- `'pushes the legal WebView with google.com when Terms is tapped'` — verifies the temporary URI.
- `'pushes the legal WebView with google.com when Privacy Policy is tapped'` — verifies the temporary URI.
- `'collapses press motion when reduced motion is enabled'` — verifies token behavior.
- `'does not overflow at 360x600 with 1.5 text scale'` — verifies responsive reachability.
- Native `WebViewWidget` page rendering is a manual platform check, not pumped in this test.

### `test/widget/onboarding/welcome_screen_test.dart`

- Existing welcome content, flag-writing, motion, and overflow tests remain.
- `'writes the seen flag and replaces onboarding with AuthRoute when Skip is tapped'` — replaces the old completion-only assertion with route evidence.
- `'writes the seen flag and replaces onboarding with AuthRoute when Get started is tapped'` — covers the second completion path.
