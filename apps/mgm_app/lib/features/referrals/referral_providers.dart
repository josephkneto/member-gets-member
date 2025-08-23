import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'referral_service.dart';

final referralServiceProvider = Provider<ReferralService>((ref) {
  if (kIsWeb) {
    // Provide a mock service for web
    return ReferralService(FirebaseFirestore.instance, FirebaseAuth.instance);
  }
  return ReferralService(FirebaseFirestore.instance, FirebaseAuth.instance);
});
