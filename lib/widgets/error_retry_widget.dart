import 'package:flutter/material.dart';
import 'package:gaming_library_assessment_flutter/core/utils/extensions.dart';

class ErrorRetryWidget extends StatelessWidget {
  final VoidCallback onRetryClicked;
  final String? text;
  final EdgeInsetsGeometry? padding;

  const ErrorRetryWidget({
    Key? key,
    this.text,
    this.padding,
    required this.onRetryClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text ?? context.localisations.error_results,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: onRetryClicked,
            child: Text(context.localisations.retry),
          ),
        ],
      ),
    );
  }
}
