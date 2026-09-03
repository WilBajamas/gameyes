import 'package:flutter/material.dart';

import '../generated/l10n.dart';

class ErrorRetryWidget extends StatelessWidget {
  final VoidCallback onRetryClicked;
  final String? text;
  final EdgeInsetsGeometry? padding;

  const ErrorRetryWidget({
    super.key,
    this.text,
    this.padding,
    required this.onRetryClicked,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text ?? S.current.error_results, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetryClicked,
            child: Text(S.current.retry),
          ),
        ],
      ),
    );
  }
}
