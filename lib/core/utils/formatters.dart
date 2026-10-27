import 'package:intl/intl.dart';

import '../strings.dart';

final _inr = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
final _date = DateFormat('d MMM yyyy', 'en_IN');
final _short = DateFormat('d MMM', 'en_IN');

String formatInr(num? value) => value == null ? '—' : _inr.format(value);

/// ₹10,00,000 → "₹10 L", ₹1,50,00,000 → "₹1.5 Cr".
String formatInrCompact(num? value) {
  if (value == null) return '—';
  String trim(double v) => v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 1);
  if (value >= 10000000) return '₹${trim(value / 10000000)} Cr';
  if (value >= 100000) return '₹${trim(value / 100000)} L';
  return formatInr(value);
}

/// 125000 → "1,25,000" (Indian digit grouping).
String formatIndianNumber(num value) => NumberFormat.decimalPattern('en_IN').format(value);

/// "22 Oct"
String formatShortDate(DateTime? d) => d == null ? '—' : _short.format(d);

String formatDate(DateTime? d) => d == null ? '—' : _date.format(d);

/// "Health", "Life", "Motor" or "Other", in the app's language.
String policyTypeLabel(String type) => strings.policyTypeName(type);

/// A readable label for an API value such as `half_yearly` or `spouse`: the translated name when the app knows
/// it, otherwise the value with its first letter capitalised.
String humanise(String key) {
  final known = strings.enumLabel(key == 'other' ? 'otherValue' : key);
  if (known.isNotEmpty) return known;
  final words = key.replaceAll('_', ' ');
  return words.isEmpty ? words : words[0].toUpperCase() + words.substring(1);
}
