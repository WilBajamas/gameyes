import 'package:flutter_test/flutter_test.dart';
import 'package:gaming_library_assessment_flutter/core/services/supabase/igdb_call_log.dart';

void main() {
  test('should return the body unchanged when it is shorter than the cap', () {
    final body = List.generate(3, (i) => 'line $i').join('\n');

    final result = IgdbCallLog.trimToLineCap(body);

    expect(result, body);
  });

  test('should return the body unchanged when it is exactly at the cap', () {
    final body = List.generate(50, (i) => 'line $i').join('\n');

    final result = IgdbCallLog.trimToLineCap(body);

    expect(result, body);
  });

  test('should keep only the first 50 lines when the body is longer than the '
      'cap', () {
    final lines = List.generate(60, (i) => 'line $i');
    final body = lines.join('\n');

    final result = IgdbCallLog.trimToLineCap(body);

    expect(result, startsWith(lines.take(50).join('\n')));
  });

  test('should say the output was cut short when the body is longer than the '
      'cap', () {
    final body = List.generate(60, (i) => 'line $i').join('\n');

    final result = IgdbCallLog.trimToLineCap(body);

    expect(result, endsWith('[cut short: showing 50 of 60 lines]'));
  });
}
