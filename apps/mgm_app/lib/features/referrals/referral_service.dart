import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_plus/share_plus.dart';

Uri buildReferralUri(String code) => Uri.parse('myapp://referral?code=$code');

class ReferralService {
  ReferralService(this._db, this._auth);
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  Future<String> _ensureUserCode(String userId) async {
    final codes = await _db
        .collection('referralCodes')
        .where('userId', isEqualTo: userId)
        .limit(1)
        .get();
    if (codes.docs.isNotEmpty) {
      return codes.docs.first.data()['code'] as String;
    }
    final code = _generateCode();
    await _db.collection('referralCodes').add({
      'userId': userId,
      'code': code,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return code;
  }

  String _generateCode() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final rnd = Random.secure();
    return List.generate(8, (_) => chars[rnd.nextInt(chars.length)]).join();
  }

  Future<Uri> buildShareLink(String code) async {
    return buildReferralUri(code);
  }

  Future<void> shareInvite() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('Nao autenticado');
    final code = await _ensureUserCode(uid);
    final link = await buildShareLink(code);
    await Share.share('Junte-se a mim! Use meu link: $link');
  }

  Future<void> trackClick(String code) async {
    await _db.collection('referrals').add({
      'referrerId': await _resolveReferrerId(code),
      'referralCode': code,
      'status': 'clicked',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String> _resolveReferrerId(String code) async {
    final snapshot = await _db
        .collection('referralCodes')
        .where('code', isEqualTo: code)
        .limit(1)
        .get();
    if (snapshot.docs.isEmpty) throw Exception('Codigo invalido');
    return snapshot.docs.first.data()['userId'] as String;
  }

  Future<void> markRegisteredIfPending(String code, String newUserId) async {
    final query = await _db
        .collection('referrals')
        .where('referralCode', isEqualTo: code)
        .where('status', isEqualTo: 'clicked')
        .orderBy('createdAt', descending: true)
        .limit(1)
        .get();
    if (query.docs.isEmpty) {
      // cria diretamente como registered para que o referido seja parte do documento
      await _db.collection('referrals').add({
        'referrerId': await _resolveReferrerId(code),
        'referralCode': code,
        'referredUserId': newUserId,
        'status': 'registered',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return;
    }
    final doc = query.docs.first;
    await doc.reference.update({
      'status': 'registered',
      'referredUserId': newUserId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> recordEvent(
      String userId, String name, Map<String, Object?> properties) async {
    await _db.collection('events').add({
      'userId': userId,
      'name': name,
      'properties': properties,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }
}
