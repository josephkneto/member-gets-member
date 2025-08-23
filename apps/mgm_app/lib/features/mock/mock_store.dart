import 'dart:collection';

class MockStore {
  // userId -> referral code
  static final Map<String, String> userCodeByUserId = <String, String>{};

  // List of referral events: {referrerId, referralCode, referredUserId?, status, createdAt}
  static final List<Map<String, dynamic>> referrals = <Map<String, dynamic>>[];

  // userId -> total points
  static final Map<String, int> pointsByUserId = <String, int>{};

  // userId -> list of events
  static final Map<String, List<Map<String, dynamic>>> eventsByUserId =
      <String, List<Map<String, dynamic>>>{};

  static void addPoints(String userId, int points, String reason) {
    pointsByUserId[userId] = (pointsByUserId[userId] ?? 0) + points;
    addEvent(userId, 'points_awarded', {'points': points, 'reason': reason});
  }

  static void addEvent(String userId, String name, Map<String, Object?> props) {
    final list =
        eventsByUserId.putIfAbsent(userId, () => <Map<String, dynamic>>[]);
    list.add({
      'name': name,
      'properties': props,
      'createdAt': DateTime.now(),
    });
  }

  static Map<String, int> kpisForUser(String userId) {
    final userReferrals = referrals
        .where((r) => r['referrerId'] == userId)
        .toList(growable: false);
    final counts = <String, int>{
      'clicked': 0,
      'installed': 0,
      'registered': 0,
      'converted': 0,
    };
    for (final r in userReferrals) {
      final status = (r['status'] ?? '') as String;
      if (counts.containsKey(status)) {
        counts[status] = (counts[status] ?? 0) + 1;
      }
    }
    return UnmodifiableMapView<String, int>(counts);
  }
}
