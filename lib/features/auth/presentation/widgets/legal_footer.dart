part of '../screens/auth_screen.dart';

class _LegalFooter extends StatelessWidget {
  const _LegalFooter({
    required this.onTermsPressed,
    required this.onPrivacyPressed,
  });

  final VoidCallback onTermsPressed;
  final VoidCallback onPrivacyPressed;

  @override
  Widget build(BuildContext context) {
    final tokens = context.tokens;
    final textStyle = tokens.typography.caption.style;
    final linkStyle = textStyle.copyWith(color: tokens.color.accentLinkCyan);
    return Center(
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(S.current.auth_legal_prefix, style: textStyle),
          InkWell(
            onTap: onTermsPressed,
            child: Text(S.current.auth_terms, style: linkStyle),
          ),
          Text(S.current.auth_legal_middle, style: textStyle),
          InkWell(
            onTap: onPrivacyPressed,
            child: Text(S.current.auth_privacy, style: linkStyle),
          ),
          Text(S.current.auth_legal_suffix, style: textStyle),
        ],
      ),
    );
  }
}
