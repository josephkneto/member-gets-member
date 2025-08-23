class Referral {
  Referral({
    required this.id,
    required this.referrerId,
    this.referredUserId,
    required this.referralCode,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });
  final String id;
  final String referrerId;
  final String? referredUserId;
  final String referralCode;
  final String status; // clicked | installed | registered | converted
  final DateTime createdAt;
  final DateTime updatedAt;
}
