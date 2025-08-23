import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/auth_providers.dart';
import 'widgets/kpi_card.dart';
import 'widgets/points_progress.dart';
import 'widgets/recent_activity.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    String? uid;
    if (kIsWeb) {
      uid = ref.watch(mockAuthStateProvider)?.uid;
    } else {
      uid = FirebaseAuth.instance.currentUser?.uid;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Compartilhar',
            icon: const Icon(Icons.share),
            onPressed: () => context.go('/share'),
          ),
          IconButton(
            tooltip: 'Recompensas',
            icon: const Icon(Icons.card_giftcard),
            onPressed: () => context.go('/rewards'),
          ),
          IconButton(
            tooltip: 'Insights',
            icon: const Icon(Icons.lightbulb),
            onPressed: () => context.go('/insights'),
          ),
        ],
      ),
      body: uid == null
          ? const Center(child: Text('Faca login para ver seus KPIs'))
          : kIsWeb
              ? _buildMockDashboard()
              : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('referrals')
                      .where('referrerId', isEqualTo: uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    final docs = snapshot.data?.docs ?? [];
                    int clicked = 0, registered = 0, converted = 0;
                    for (final d in docs) {
                      final s = d.data()['status'];
                      if (s == 'clicked') clicked++;
                      // installed omitted in mock/mobile metrics
                      if (s == 'registered') registered++;
                      if (s == 'converted') converted++;
                    }
                    final convRate = clicked > 0
                        ? (converted / clicked * 100).toStringAsFixed(1)
                        : '0.0';
                    return SingleChildScrollView(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: KpiCard(
                                      title: 'Clicados', value: '$clicked')),
                              Expanded(
                                  child: KpiCard(
                                      title: 'Registrados',
                                      value: '$registered')),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: KpiCard(
                                      title: 'Convertidos',
                                      value: '$converted')),
                              Expanded(
                                  child: KpiCard(
                                      title: 'Taxa %', value: convRate)),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => context.go('/share'),
                                  icon: const Icon(Icons.share),
                                  label: const Text('Compartilhar convite'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton.icon(
                                  onPressed: () => context.go('/insights'),
                                  icon: const Icon(Icons.lightbulb),
                                  label: const Text('Perguntar insights'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.share), label: 'Share'),
          BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard), label: 'Rewards'),
          BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb), label: 'Insights'),
        ],
        onTap: (i) {
          if (i == 1) context.go('/share');
          if (i == 2) context.go('/rewards');
          if (i == 3) context.go('/insights');
        },
      ),
    );
  }

  Widget _buildMockDashboard() {
    const clicked = 12;
    const registered = 5;
    const converted = 3;
    const convRate = '25.0';
    return SingleChildScrollView(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: const [
          Row(
            children: [
              Expanded(child: KpiCard(title: 'Clicados', value: '$clicked')),
              Expanded(
                  child: KpiCard(title: 'Registrados', value: '$registered')),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: KpiCard(title: 'Convertidos', value: '$converted')),
              Expanded(child: KpiCard(title: 'Taxa %', value: convRate)),
            ],
          ),
          SizedBox(height: 8),
          PointsProgress(),
          RecentActivity(),
          SizedBox(height: 8),
        ],
      ),
    );
  }
}
