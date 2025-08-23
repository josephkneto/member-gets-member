import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../../mock/mock_store.dart';
import '../../auth/auth_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RecentActivity extends ConsumerWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kIsWeb) {
      return const SizedBox.shrink();
    }
    final user = ref.watch(mockAuthStateProvider);
    if (user == null) return const SizedBox.shrink();
    final events = MockStore.eventsByUserId[user.uid] ?? const [];
    if (events.isEmpty) {
      return const SizedBox.shrink();
    }
    return Card(
      margin: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text('Atividades recentes',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          const Divider(height: 1),
          ...events.reversed.take(5).map((e) => ListTile(
                dense: true,
                title: Text(e['name'] as String),
                subtitle: Text('${e['createdAt']}'),
              )),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
