import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import '../mock/mock_store.dart';
import '../../core/env.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class InsightsService {
  FirebaseFunctions _functions() {
    const region = String.fromEnvironment('INSIGHTS_FUNCTION_REGION');
    if (region.isNotEmpty) {
      return FirebaseFunctions.instanceFor(region: region);
    }
    return FirebaseFunctions.instance;
  }

  Future<Map<String, dynamic>> askInsights(String question) async {
    final customUrl = Env.insightsEndpointUrl;
    if (customUrl != null && customUrl.isNotEmpty) {
      // Call custom HTTPS endpoint (no Blaze required)
      final uri = Uri.parse(customUrl);
      final resp = await HttpFunctionsAdapter.post(uri, {
        'question': question,
      });
      return resp;
    }

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

// Minimal adapter for posting to a custom HTTPS endpoint without adding new deps
class HttpFunctionsAdapter {
  static Future<Map<String, dynamic>> post(
      Uri url, Map<String, dynamic> body) async {
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
    if (resp.statusCode >= 200 && resp.statusCode < 300) {
      final map = jsonDecode(resp.body) as Map<String, dynamic>;
      return map;
    }
    return {
      'answer': 'Falha ao consultar endpoint (${resp.statusCode}).',
      'kpis': MockStore.kpisForUser('mock-user'),
      'charts': []
    };
  }
}
