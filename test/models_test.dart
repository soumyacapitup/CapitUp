import 'package:flutter_test/flutter_test.dart';
import 'package:insureiq/features/policy/data/models.dart';

void main() {
  test('parses a policy from the API shape', () {
    final p = Policy.fromJson({
      'id': 'p1',
      'document_id': 'd1',
      'policy_type': 'health',
      'insurer': 'Star Health',
      'plan_name': null,
      'policy_number': 'P/1',
      'start_date': '2026-10-01',
      'end_date': '2027-09-30',
      'premium': '24580.00',
      'sum_insured': '1000000.00',
      'payment_frequency': 'annual',
      'verified': false,
      'source': 'upload',
      'extraction_confidence': 0.7,
      'field_confidence': {'insurer': 0.9, 'premium': 1},
      'details': {'maternity': 'Covered after 24 months'},
      'status': 'active',
      'days_to_expiry': 361,
    });
    expect(p.premium, 24580);
    expect(p.sumInsured, 1000000);
    expect(p.endDate, DateTime(2027, 9, 30));
    expect(p.fieldConfidence['premium'], 1.0);
    expect(p.details['maternity'], isNotNull);
  });

  test('parses an answer with citations', () {
    final a = Answer.fromJson({
      'id': 'a1',
      'question': 'Is maternity covered?',
      'answer': 'Yes, after 24 months.',
      'answerable': true,
      'confidence': 'high',
      'citations': [
        {'page': 2, 'section': 'SECTION 3 BENEFITS', 'excerpt': 'Maternity Benefit…'},
      ],
      'disclaimer': 'Based on your policy document.',
      'created_at': '2026-10-04T10:00:00Z',
    });
    expect(a.citations.single.label, 'Page 2 · SECTION 3 BENEFITS');
  });

  test('maps document error codes to friendly text', () {
    final d = PolicyDocument.fromJson({'id': 'd', 'status': 'failed', 'error_code': 'pdf_password_protected'});
    expect(d.isDone, isTrue);
    expect(d.errorText, contains('password'));
  });
}
