import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../mock/mock_store.dart';
import '../auth/auth_providers.dart';
import 'referral_providers.dart';

class ShareLinkScreen extends ConsumerWidget {
  const ShareLinkScreen({super.key});

  Future<String?> _getCode(WidgetRef ref) async {
    if (kIsWeb) {
      final user = ref.read(mockAuthStateProvider);
      if (user == null) return null;
      return MockStore.userCodeByUserId[user.uid];
    }
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return null;
    final codes = await FirebaseFirestore.instance
        .collection('referralCodes')
        .where('userId', isEqualTo: uid)
        .limit(1)
        .get();
    if (codes.docs.isNotEmpty) {
      return codes.docs.first.data()['code'] as String;
    }
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compartilhar Indicação')),
      body: FutureBuilder<String?>(
        future: _getCode(ref),
        builder: (context, snapshot) {
          final code = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Seu código: ${code ?? '-'}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (kIsWeb) {
                      final user = ref.read(mockAuthStateProvider);
                      if (user == null) return;
                      final existing = MockStore.userCodeByUserId[user.uid];
                      final userCode =
                          existing ?? 'WEB${user.uid.hashCode.abs()}';
                      MockStore.userCodeByUserId[user.uid] = userCode;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'Link copiado: myapp://referral?code=$userCode')));
                      return;
                    }
                    await ref.read(referralServiceProvider).shareInvite();
                  },
                  child: const Text('Compartilhar Link'),
                ),
                if (kIsWeb) ...[
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Simular conversão no web: adiciona pontos e atividade
                      final user = ref.read(mockAuthStateProvider);
                      if (user == null) return;
                      MockStore.addPoints(user.uid, 50, 'indicação convertida');
                      MockStore.addEvent(
                          user.uid, 'conversion', {'source': 'web-mock'});
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Conversão simulada (+50 pts)')));
                    },
                    child: const Text('Simular Conversão (+50 pts)'),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
