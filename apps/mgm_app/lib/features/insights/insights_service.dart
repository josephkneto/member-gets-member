import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import '../mock/mock_store.dart';

class InsightsService {
  FirebaseFunctions _functions() {
    const region = String.fromEnvironment('INSIGHTS_FUNCTION_REGION');
    if (region.isNotEmpty) {
      return FirebaseFunctions.instanceFor(region: region);
    }
    return FirebaseFunctions.instance;
  }

  Future<Map<String, dynamic>> askInsights(String question) async {
    if (kIsWeb) {
      // Mock response for web demo using mock KPIs
      final kpis = MockStore.kpisForUser('mock-user');
      return {
        'answer':
            'Nos ultimos 7 dias, tivemos ${kpis['clicked']} cliques e ${kpis['converted']} conversoes (taxa ~25%).',
        'kpis': kpis,
        'charts': [
          {
            'type': 'bar',
            'series': [12, 5, 3]
          },
        ]
      };
    }

    final callable = _functions().httpsCallable('insights');
    final result = await callable.call({'question': question});
    return Map<String, dynamic>.from(result.data as Map);
  }
}
