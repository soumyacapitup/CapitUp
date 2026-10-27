import '../../../core/strings.dart';

double? _num(Object? v) => v == null ? null : double.tryParse(v.toString());
DateTime? _date(Object? v) => v == null ? null : DateTime.parse(v as String);

class Policy {
  Policy({
    required this.id,
    required this.policyType,
    required this.verified,
    required this.source,
    required this.status,
    required this.fieldConfidence,
    required this.details,
    this.documentId,
    this.insurer,
    this.planName,
    this.policyNumber,
    this.startDate,
    this.endDate,
    this.premium,
    this.sumInsured,
    this.paymentFrequency,
    this.extractionConfidence,
    this.daysToExpiry,
    this.renewalStatus = 'pending',
    this.members = const [],
    this.nominees = const [],
  });

  final String id;
  final String? documentId;
  final String policyType;
  final String? insurer;
  final String? planName;
  final String? policyNumber;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? premium;
  final double? sumInsured;
  final String? paymentFrequency;
  final bool verified;
  final String source;
  final double? extractionConfidence;
  final Map<String, double> fieldConfidence;
  final Map<String, dynamic> details;

  /// active | expiring_soon | expired | unknown
  final String status;
  final int? daysToExpiry;

  /// pending | renewed | not_renewing
  final String renewalStatus;
  final List<FamilyMember> members;
  final List<Nominee> nominees;

  String get displayName => insurer ?? strings.untitledPolicy;

  factory Policy.fromJson(Map<String, dynamic> j) => Policy(
    id: j['id'] as String,
    documentId: j['document_id'] as String?,
    policyType: j['policy_type'] as String,
    insurer: j['insurer'] as String?,
    planName: j['plan_name'] as String?,
    policyNumber: j['policy_number'] as String?,
    startDate: _date(j['start_date']),
    endDate: _date(j['end_date']),
    premium: _num(j['premium']),
    sumInsured: _num(j['sum_insured']),
    paymentFrequency: j['payment_frequency'] as String?,
    verified: j['verified'] as bool,
    source: j['source'] as String,
    extractionConfidence: _num(j['extraction_confidence']),
    fieldConfidence: (j['field_confidence'] as Map? ?? {}).map((k, v) => MapEntry(k as String, _num(v) ?? 0)),
    details: Map<String, dynamic>.from(j['details'] as Map? ?? {}),
    status: j['status'] as String,
    daysToExpiry: j['days_to_expiry'] as int?,
    renewalStatus: j['renewal_status'] as String? ?? 'pending',
    members: (j['members'] as List? ?? []).map((m) => FamilyMember.fromJson(m as Map<String, dynamic>)).toList(),
    nominees: (j['nominees'] as List? ?? []).map((m) => Nominee.fromJson(m as Map<String, dynamic>)).toList(),
  );
}

class FamilyMember {
  FamilyMember({required this.id, required this.relation, required this.fullName, this.dateOfBirth});
  final String id;

  /// self | spouse | child | parent | other
  final String relation;
  final String fullName;
  final DateTime? dateOfBirth;

  factory FamilyMember.fromJson(Map<String, dynamic> j) => FamilyMember(
    id: j['id'] as String,
    relation: j['relation'] as String,
    fullName: j['full_name'] as String,
    dateOfBirth: _date(j['date_of_birth']),
  );
}

class AppNotification {
  AppNotification({
    required this.id,
    required this.kind,
    required this.title,
    required this.body,
    required this.createdAt,
    this.deepLink,
    this.readAt,
  });
  final String id;
  final String kind;
  final String title;
  final String body;
  final String? deepLink;
  final DateTime createdAt;
  final DateTime? readAt;

  bool get isRead => readAt != null;

  factory AppNotification.fromJson(Map<String, dynamic> j) => AppNotification(
    id: j['id'] as String,
    kind: j['kind'] as String,
    title: j['title'] as String,
    body: j['body'] as String,
    deepLink: j['deep_link'] as String?,
    createdAt: DateTime.parse(j['created_at'] as String).toLocal(),
    readAt: j['read_at'] == null ? null : DateTime.parse(j['read_at'] as String),
  );
}

class HealthFinding {
  HealthFinding(this.key, this.label, this.grade, this.detail);
  final String key;
  final String label;
  final String grade;
  final String detail;

  factory HealthFinding.fromJson(Map<String, dynamic> j) =>
      HealthFinding(j['key'] as String, j['label'] as String, j['grade'] as String, j['detail'] as String);
}

class HealthCheck {
  HealthCheck({
    required this.available,
    this.score,
    required this.strong,
    required this.attention,
    required this.notCovered,
    required this.notMentioned,
    required this.disclaimer,
  });
  final bool available;
  final int? score;
  final List<HealthFinding> strong;
  final List<HealthFinding> attention;
  final List<HealthFinding> notCovered;
  final List<String> notMentioned;
  final String disclaimer;

  static List<HealthFinding> _list(Object? v) =>
      (v as List).map((f) => HealthFinding.fromJson(f as Map<String, dynamic>)).toList();

  factory HealthCheck.fromJson(Map<String, dynamic> j) => HealthCheck(
    available: j['available'] as bool,
    score: j['score'] as int?,
    strong: _list(j['strong']),
    attention: _list(j['attention']),
    notCovered: _list(j['not_covered']),
    notMentioned: List<String>.from(j['not_mentioned'] as List),
    disclaimer: j['disclaimer'] as String,
  );
}

class PolicyDocument {
  PolicyDocument({required this.id, required this.status, this.errorCode, this.policyId});

  final String id;

  /// uploaded | processing | extracted | failed
  final String status;
  final String? errorCode;
  final String? policyId;

  bool get isDone => status == 'extracted' || status == 'failed';

  factory PolicyDocument.fromJson(Map<String, dynamic> j) => PolicyDocument(
    id: j['id'] as String,
    status: j['status'] as String,
    errorCode: j['error_code'] as String?,
    policyId: j['policy_id'] as String?,
  );

  String get errorText => switch (errorCode) {
    'pdf_password_protected' => strings.errPdfPassword,
    'pdf_too_many_pages' => strings.errPdfTooManyPages,
    'pdf_unreadable' => strings.errPdfUnreadable,
    'no_text_found' => strings.errNoText,
    'ocr_unavailable' => strings.errOcrUnavailable,
    'ai_unavailable' => strings.errAiUnavailable,
    _ => strings.errProcessing,
  };
}

class Citation {
  Citation({this.page, this.section, required this.excerpt});
  final int? page;
  final String? section;
  final String excerpt;

  factory Citation.fromJson(Map<String, dynamic> j) =>
      Citation(page: j['page'] as int?, section: j['section'] as String?, excerpt: j['excerpt'] as String);

  String get label => [if (page != null) strings.pageLabel('$page'), if (section != null) section].join(' · ');
}

class Answer {
  Answer({
    required this.id,
    required this.question,
    required this.answer,
    required this.answerable,
    required this.confidence,
    required this.citations,
    required this.disclaimer,
    this.provider,
    this.relatedClauses = const [],
  });

  final String id;
  final String? provider;
  final List<Clause> relatedClauses;
  final String question;
  final String answer;
  final bool answerable;
  final String confidence;
  final List<Citation> citations;
  final String disclaimer;

  factory Answer.fromJson(Map<String, dynamic> j) => Answer(
    id: j['id'] as String,
    question: j['question'] as String,
    answer: j['answer'] as String,
    answerable: j['answerable'] as bool,
    confidence: j['confidence'] as String,
    citations: (j['citations'] as List).map((c) => Citation.fromJson(c as Map<String, dynamic>)).toList(),
    disclaimer: j['disclaimer'] as String,
    provider: j['provider'] as String?,
    relatedClauses: (j['related_clauses'] as List? ?? [])
        .map((c) => Clause.fromJson(c as Map<String, dynamic>))
        .toList(),
  );
}

class PolicySummary {
  PolicySummary({
    required this.headline,
    required this.keyPoints,
    required this.watchOuts,
    required this.disclaimer,
    this.provider,
  });
  final String? provider;
  final String headline;
  final List<String> keyPoints;
  final List<String> watchOuts;
  final String disclaimer;

  factory PolicySummary.fromJson(Map<String, dynamic> j) => PolicySummary(
    headline: j['headline'] as String,
    keyPoints: List<String>.from(j['key_points'] as List),
    watchOuts: List<String>.from(j['watch_outs'] as List),
    disclaimer: j['disclaimer'] as String,
    provider: j['provider'] as String?,
  );
}

class RenewalItem {
  RenewalItem({
    required this.policyId,
    required this.policyType,
    this.insurer,
    required this.endDate,
    required this.daysToExpiry,
  });
  final String policyId;
  final String policyType;
  final String? insurer;
  final DateTime endDate;
  final int daysToExpiry;

  factory RenewalItem.fromJson(Map<String, dynamic> j) => RenewalItem(
    policyId: j['policy_id'] as String,
    policyType: j['policy_type'] as String,
    insurer: j['insurer'] as String?,
    endDate: DateTime.parse(j['end_date'] as String),
    daysToExpiry: j['days_to_expiry'] as int,
  );
}

class PortfolioSummary {
  PortfolioSummary({
    required this.totalPolicies,
    required this.activePolicies,
    required this.expiringSoon,
    required this.pendingVerification,
    required this.totalAnnualPremium,
    required this.healthCover,
    required this.lifeCover,
    required this.byType,
    required this.upcomingRenewals,
  });

  final int totalPolicies;
  final int activePolicies;
  final int expiringSoon;
  final int pendingVerification;
  final double totalAnnualPremium;
  final double healthCover;
  final double lifeCover;
  final Map<String, int> byType;
  final List<RenewalItem> upcomingRenewals;

  factory PortfolioSummary.fromJson(Map<String, dynamic> j) => PortfolioSummary(
    totalPolicies: j['total_policies'] as int,
    activePolicies: j['active_policies'] as int,
    expiringSoon: j['expiring_soon'] as int,
    pendingVerification: j['pending_verification'] as int,
    totalAnnualPremium: _num(j['total_annual_premium']) ?? 0,
    healthCover: _num(j['health_cover']) ?? 0,
    lifeCover: _num(j['life_cover']) ?? 0,
    byType: Map<String, int>.from(j['by_type'] as Map),
    upcomingRenewals: (j['upcoming_renewals'] as List)
        .map((r) => RenewalItem.fromJson(r as Map<String, dynamic>))
        .toList(),
  );
}

class Nominee {
  Nominee({
    required this.id,
    required this.fullName,
    required this.relation,
    required this.sharePercent,
    this.familyMemberId,
    this.dateOfBirth,
    this.phone,
    this.appointeeName,
  });
  final String id;
  final String? familyMemberId;
  final String fullName;
  final String relation;
  final int sharePercent;
  final DateTime? dateOfBirth;
  final String? phone;
  final String? appointeeName;

  bool get isMinor {
    final dob = dateOfBirth;
    if (dob == null) return false;
    final now = DateTime.now();
    final age =
        now.year - dob.year - ((now.month < dob.month || (now.month == dob.month && now.day < dob.day)) ? 1 : 0);
    return age < 18;
  }

  factory Nominee.fromJson(Map<String, dynamic> j) => Nominee(
    id: j['id'] as String,
    familyMemberId: j['family_member_id'] as String?,
    fullName: j['full_name'] as String,
    relation: j['relation'] as String,
    sharePercent: j['share_percent'] as int,
    dateOfBirth: _date(j['date_of_birth']),
    phone: j['phone'] as String?,
    appointeeName: j['appointee_name'] as String?,
  );
}

/// A typed, citable clause from the policy wording (also used for "related clauses" under answers).
class Clause {
  Clause({required this.type, required this.title, required this.text, this.page, this.section, this.tags = const []});

  /// benefit | exclusion | waiting_period | limit | condition | definition
  final String type;
  final List<String> tags;
  final String title;
  final String text;
  final int? page;
  final String? section;

  factory Clause.fromJson(Map<String, dynamic> j) => Clause(
    type: (j['clause_type'] ?? j['type']) as String,
    tags: List<String>.from(j['tags'] as List? ?? const []),
    title: j['title'] as String,
    text: j['text'] as String,
    page: j['page'] as int?,
    section: j['section'] as String?,
  );
}

class Insight {
  Insight({
    required this.id,
    required this.severity,
    required this.category,
    required this.title,
    required this.detail,
    this.actionLabel,
    this.actionLink,
  });
  final String id;

  /// high | medium | info
  final String severity;
  final String category;
  final String title;
  final String detail;
  final String? actionLabel;
  final String? actionLink;

  factory Insight.fromJson(Map<String, dynamic> j) => Insight(
    id: j['id'] as String,
    severity: j['severity'] as String,
    category: j['category'] as String,
    title: j['title'] as String,
    detail: j['detail'] as String,
    actionLabel: j['action_label'] as String?,
    actionLink: j['action_link'] as String?,
  );
}

class Insights {
  Insights(this.items, this.disclaimer);
  final List<Insight> items;
  final String disclaimer;

  factory Insights.fromJson(Map<String, dynamic> j) => Insights(
    (j['insights'] as List).map((i) => Insight.fromJson(i as Map<String, dynamic>)).toList(),
    j['disclaimer'] as String,
  );
}

class CompareRow {
  CompareRow(this.section, this.label, this.values, this.bestIndex, [this.grades = const []]);
  final String section;
  final String label;
  final List<String?> values;
  final int? bestIndex;

  /// strong | attention | not_covered per policy, for feature rows.
  final List<String?> grades;

  factory CompareRow.fromJson(Map<String, dynamic> j) => CompareRow(
    j['section'] as String,
    j['label'] as String,
    (j['values'] as List).map((v) => v?.toString()).toList(),
    j['best_index'] as int?,
    (j['grades'] as List? ?? const []).map((g) => g as String?).toList(),
  );
}

class Comparison {
  Comparison({required this.policyType, required this.policyNames, required this.rows, required this.disclaimer});
  final String policyType;
  final List<String> policyNames;
  final List<CompareRow> rows;
  final String disclaimer;

  factory Comparison.fromJson(Map<String, dynamic> j) => Comparison(
    policyType: j['policy_type'] as String,
    policyNames: (j['policies'] as List).map((p) => ((p as Map)['insurer'] ?? 'Policy') as String).toList(),
    rows: (j['rows'] as List).map((r) => CompareRow.fromJson(r as Map<String, dynamic>)).toList(),
    disclaimer: j['disclaimer'] as String,
  );
}
