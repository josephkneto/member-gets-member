import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../mock/mock_store.dart';
import '../../auth/auth_providers.dart';

class PointsProgress extends ConsumerWidget {
  const PointsProgress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kIsWeb) return const SizedBox.shrink();
    final user = ref.watch(mockAuthStateProvider);
    if (user == null) return const SizedBox.shrink();
    final total = MockStore.pointsByUserId[user.uid] ?? 0;
    final goal = 100;
    final pct = (total / goal).clamp(0.0, 1.0);
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Progresso de pontos',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: pct),
            const SizedBox(height: 8),
            Text('$total / $goal pts'),
          ],
        ),
      ),
    );
  }
}
