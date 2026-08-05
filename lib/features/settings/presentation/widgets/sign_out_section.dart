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
