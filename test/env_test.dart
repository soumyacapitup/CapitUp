import 'package:flutter_test/flutter_test.dart';
import 'package:insureiq/core/config/env.dart';

void main() {
  test('legal links default to the pages the backend serves', () {
    expect(Env.privacyPolicyUrl, endsWith('/privacy'));
    expect(Env.termsUrl, endsWith('/terms'));
    expect(Env.privacyPolicyUrl, isNot(contains('example.com')));
  });

  test('a development build lists what a store build must change', () {
    final problems = Env.releaseProblems();
    expect(problems, contains(startsWith('API_BASE_URL must be https://')));
    expect(problems, contains('SUPPORT_EMAIL is a placeholder'));
  });
}
