import 'package:flutter_test/flutter_test.dart';
import 'package:insureiq/core/observability.dart';

void main() {
  test('reports mask numbers and emails and carry no user data', () {
    final r = CrashReporter();
    final body = r.buildReport(
      StateError('Policy P/171100/01/2026/004521 for asha@example.com, phone 98765 43210'),
      StackTrace.fromString('#0 main (file:///lib/main.dart:1)'),
      fatal: true,
    )!;
    final message = body['message']! as String;
    expect(message, isNot(contains('004521')));
    expect(message, isNot(contains('asha@')));
    expect(message, isNot(contains('43210')));
    expect(message, contains('[number]'));
    expect(body.keys, isNot(contains('user')));
    expect(body['error_type'], 'StateError');
    expect(body['fatal'], true);
  });

  test('the same crash is sent once, and at most N per session', () {
    final r = CrashReporter(maxPerSession: 2);
    final stack = StackTrace.fromString('#0 a (file:///a.dart:1)');
    expect(r.buildReport(StateError('x'), stack, fatal: false), isNotNull);
    expect(r.buildReport(StateError('x'), stack, fatal: false), isNull); // duplicate
    expect(r.buildReport(ArgumentError('y'), stack, fatal: false), isNotNull);
    expect(r.buildReport(const FormatException('z'), stack, fatal: false), isNull); // budget used up
  });

  test('long messages and stacks are capped', () {
    final body = CrashReporter().buildReport(
      Exception('a' * 2000),
      StackTrace.fromString('#0 f\n' * 3000),
      fatal: false,
    )!;
    expect((body['message']! as String).length, lessThanOrEqualTo(300));
    expect((body['stack']! as String).length, lessThanOrEqualTo(8000));
  });
}
