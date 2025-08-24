import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_providers.dart';

class RewardsScreen extends ConsumerWidget {
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? uid;
    if (kIsWeb) {
      uid = ref.watch(mockAuthStateProvider)?.uid;
    } else {
      uid = FirebaseAuth.instance.currentUser?.uid;
    }
    if (uid == null) {
      return const Scaffold(body: Center(child: Text('Nao autenticado')));
    }

    if (kIsWeb) {
      return _buildMockRewards();
    }

    final query = FirebaseFirestore.instance
        .collection('rewards')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true);

    return Scaffold(
      appBar: AppBar(title: const Text('Recompensas')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          final docs = snapshot.data?.docs ?? [];
          final total =
              docs.fold<num>(0, (acc, d) => acc + (d.data()['points'] ?? 0));
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Saldo', style: TextStyle(fontSize: 18)),
                    Text('$total pts',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (c, i) {
                    final d = docs[i].data();
                    return ListTile(
                      title: Text(
                          '${d['type'] ?? 'pontos'}: +${d['points'] ?? 0}'),
                      subtitle: Text('${d['createdAt']?.toDate() ?? ''}'),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMockRewards() {
    final mock = [
      {'type': 'indicação convertida', 'points': 50, 'createdAt': DateTime.now()},
      {'type': 'bônus semanal', 'points': 10, 'createdAt': DateTime.now()},
    ];
    final total = mock.fold<num>(0, (acc, d) => acc + (d['points'] as int));
    return Scaffold(
      appBar: AppBar(title: const Text('Recompensas')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Saldo', style: TextStyle(fontSize: 18)),
                Text('$total pts',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: mock.length,
              itemBuilder: (c, i) {
                final d = mock[i];
                return ListTile(
                  title: Text('${d['type']}: +${d['points']}'),
                  subtitle: Text('${d['createdAt']}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
