import 'package:flutter_test/flutter_test.dart';
import 'package:mgm_app/features/referrals/referral_service.dart';

// This test focuses on link building format (no Firebase interaction).

void main() {
  test('Build referral uri uses myapp scheme', () {
    final uri = buildReferralUri('ABCD1234');
    expect(uri.toString(), 'myapp://referral?code=ABCD1234');
  });
}
