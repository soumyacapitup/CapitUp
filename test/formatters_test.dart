import 'package:flutter_test/flutter_test.dart';
import 'package:insureiq/core/utils/formatters.dart';

void main() {
  test('formats rupees in the Indian numbering system', () {
    expect(formatInr(1000000), '₹10,00,000');
    expect(formatInr(null), '—');
  });

  test('compact lakh / crore formatting', () {
    expect(formatInrCompact(1000000), '₹10 L');
    expect(formatInrCompact(15000000), '₹1.5 Cr');
    expect(formatInrCompact(24580), '₹24,580');
  });

  test('humanise snake_case keys', () {
    expect(humanise('room_rent_limit'), 'Room rent limit');
  });
}
