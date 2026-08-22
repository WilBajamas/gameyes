import 'package:flutter/widgets.dart';
import 'package:gaming_library_assessment_flutter/widgets/countdown/countdown_digit_row.dart';
import 'package:gaming_library_assessment_flutter/widgets/countdown/enum/countdown_form.dart';

class CountdownTile extends StatelessWidget {
  const CountdownTile({
    super.key,
    required this.remaining,
    this.releaseDateText,
  });

  final Duration? remaining;
  final String? releaseDateText;

  @override
  Widget build(BuildContext context) {
    return CountdownDigitRow(
      form: CountdownForm.tile,
      remaining: remaining,
      releaseDateText: releaseDateText,
    );
  }
}
