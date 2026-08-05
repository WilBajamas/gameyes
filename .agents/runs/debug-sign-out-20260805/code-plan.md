# Code Plan
Source: W1-8.1 — `source-request.md` (Product Owner ticket, 2026-08-05),
follow-up to W1-8
Date: 2026-08-05

## CREATE NEW

### lib/features/auth/presentation/blocs/sign_out_state.dart

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/error.dart';

part 'sign_out_state.freezed.dart';

enum SignOutStatus { idle, loading, failed }

@freezed
sealed class SignOutState with _$SignOutState {
  const factory SignOutState({
    @Default(SignOutStatus.idle) SignOutStatus status,
    ErrorType? error,
  }) = _SignOutState;
}
```

### lib/features/auth/presentation/blocs/sign_out_cubit.dart

```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/data/models/result.dart';
import 'package:gaming_library_assessment_flutter/features/auth/domain/use_cases/sign_out_use_case.dart';
import 'package:injectable/injectable.dart';

import 'sign_out_state.dart';

@injectable
class SignOutCubit extends Cubit<SignOutState> {
  SignOutCubit(this._signOut) : super(const SignOutState());

  final SignOutUseCase _signOut;

  Future<void> signOut() async {
    if (state.status == SignOutStatus.loading) return;

    emit(const SignOutState(status: SignOutStatus.loading));

    final result = await _signOut();
    // Signing out can send the person back to the sign-in screen before this
    // call comes back, taking the settings screen and this object with it.
    if (isClosed) return;

    switch (result) {
      case Success<void>():
        emit(const SignOutState());
      case Failure<void>(error: final error):
        emit(SignOutState(status: SignOutStatus.failed, error: error));
    }
  }
}
```

Note for review: nothing here imports `auto_route`, `lib/config/route/**` or any
auth-status stream, and there is no success branch that does anything visible.
That absence is the point of [W1-8.1-AC05], [AC06] and [AC07].

### lib/features/settings/presentation/widgets/sign_out_section.dart

```dart
part of '../screens/settings_screen.dart';

class _SignOutSection extends StatelessWidget {
  const _SignOutSection();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
    child: BlocBuilder<SignOutCubit, SignOutState>(
      builder: (context, state) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SignOutButton(
            loading: state.status == SignOutStatus.loading,
            onPressed: () => context.read<SignOutCubit>().signOut(),
          ),
          if (state.status == SignOutStatus.failed) ...[
            const SizedBox(height: 10),
            const _InlineSignOutError(),
          ],
        ],
      ),
    ),
  );
}

class _SignOutButton extends StatelessWidget {
  const _SignOutButton({required this.loading, required this.onPressed});

  final bool loading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    return Semantics(
      button: true,
      enabled: !loading,
      child: IgnorePointer(
        ignoring: loading,
        child: ButtonPressScale(
          onPressed: onPressed,
          child: SizedBox(
            height: 52,
            width: double.infinity,
            child: DecoratedBox(
              // Same raised action row as the sign-in provider buttons.
              // Signing out destroys nothing, so it is not styled as
              // destructive.
              decoration: BoxDecoration(
                color: tokens.color.surfaceRaised,
                borderRadius: BorderRadius.circular(tokens.radius.sm),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    S.current.auth_sign_out,
                    style: tokens.typography.body.style,
                  ),
                  if (loading) ...[
                    const SizedBox(width: 10),
                    const SizedBox.square(
                      dimension: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
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
}

class _InlineSignOutError extends StatelessWidget {
  const _InlineSignOutError();

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
            S.current.auth_sign_out_error,
            style: tokens.typography.meta.style.copyWith(
              color: tokens.color.errorInk,
            ),
          ),
        ),
      ],
    );
  }
}
```

`S.current.auth_sign_out` and `S.current.auth_sign_out_error` do not resolve
until a human regenerates the localisation output in the IDE — see
`task-brief.md ## Localisation — required manual step`.

## MODIFY EXISTING

### lib/features/settings/presentation/screens/settings_screen.dart

```dart
// added imports, alongside the existing ones
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';
import 'package:gaming_library_assessment_flutter/features/auth/presentation/blocs/sign_out_cubit.dart';
import 'package:gaming_library_assessment_flutter/features/auth/presentation/blocs/sign_out_state.dart';
import 'package:gaming_library_assessment_flutter/widgets/button_press_scale.dart';

part '../widgets/sign_out_section.dart';

// ...unchanged State class, controller and scroll wiring...

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
            // NEW — the only addition to this screen.
            SliverToBoxAdapter(
              child: BlocProvider(
                create: (_) => getIt<SignOutCubit>(),
                child: const _SignOutSection(),
              ),
            ),
          ],
        ),
```

### lib/l10n/intl_en.arb

```json
  "auth_sign_in_error": "We couldn't sign you in. Please try again.",
  "auth_sign_out": "Sign out",
  "auth_sign_out_error": "We couldn't sign you out. Please try again.",
  "auth_scope_reassurance": "Just sign in for now — we'll help you set things up next.",
```

### lib/l10n/intl_zh.arb

```json
  "auth_sign_in_error": "无法登录，请重试。",
  "auth_sign_out": "退出登录",
  "auth_sign_out_error": "无法退出登录，请重试。",
  "auth_scope_reassurance": "现在只需登录，接下来我们会帮你完成设置。",
```

## TEST FILES

### test/cubit/auth/sign_out_cubit_test.dart

- `'starts idle with no error'` — the cubit's initial state is the default
  `SignOutState`.
- `'emits [loading, idle] when sign-out succeeds'` — and the repository stub
  recorded exactly one call [AC03].
- `'emits [loading, failed] when sign-out fails'` — the emitted state carries
  the `ErrorType` from the failure, so every non-success outcome lands on the
  error state rather than back at rest [AC10].
- `'ignores additional taps while sign-out is in flight'` — a second call during
  an unresolved future emits nothing further and starts no second call [AC03].
- `'clears the previous error when a new attempt starts'` — from `failed`, a
  further call emits `loading` with a null error [AC11].
- `'emits nothing when the screen is gone before the result arrives'` — closing
  the cubit mid-flight completes without throwing [AC10].

### test/widget/settings/settings_screen_test.dart

- `'renders the sign-out control alongside the existing settings content'` —
  the control and the existing placeholder are both present on a plain render,
  with no flag or build-mode condition involved [AC01/AC13].
- `'starts one sign-out and shows the pending state on a single tap'` — one tap,
  no dialog or sheet in the tree, a visible progress indicator, exactly one use
  case call [AC02/AC03/AC04].
- `'shows nothing and returns to rest when sign-out succeeds'` — no snackbar, no
  dialog, no banner, no error text after a successful sign-out [AC07].
- `'shows the inline error in the section when sign-out fails'` — the error text
  renders inside the section, the existing settings content is still on screen,
  and there is no `SnackBar` or `Dialog` in the tree [AC08/AC09].
- `'clears the inline error and retries when the control is tapped again'` —
  after a failure the control is still tappable, a second call is made, and the
  error text is gone [AC11].
- `'never performs a route action on success or on failure'` —
  `verifyNever` on the mocked `StackRouter` for both outcomes. This is the
  ticket's most important constraint [AC05].
