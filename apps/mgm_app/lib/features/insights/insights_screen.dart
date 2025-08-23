import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'insights_service.dart';

final insightsServiceProvider =
    Provider<InsightsService>((ref) => InsightsService());

class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  final _controller = TextEditingController(
      text: 'Como estao minhas conversoes nos ultimos 7 dias?');
  String _answer = '';
  Map<String, dynamic>? _kpis;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insights')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: _controller,
                decoration:
                    const InputDecoration(labelText: 'Pergunte em PT-BR')),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _loading
                  ? null
                  : () async {
                      setState(() => _loading = true);
                      try {
                        final res = await ref
                            .read(insightsServiceProvider)
                            .askInsights(_controller.text);
                        setState(() {
                          _answer = (res['answer'] ?? '').toString();
                          _kpis = Map<String, dynamic>.from(res['kpis'] ?? {});
                        });
                      } catch (e) {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text('Erro: $e')));
                      } finally {
                        if (mounted) setState(() => _loading = false);
                      }
                    },
              child: Text(_loading ? 'Consultando...' : 'Consultar'),
            ),
            const SizedBox(height: 16),
            if (_answer.isNotEmpty) ...[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Resposta',
                      style: Theme.of(context).textTheme.titleMedium)),
              const SizedBox(height: 8),
              Text(_answer),
            ],
            const SizedBox(height: 16),
            if (_kpis != null) ...[
              Align(
                  alignment: Alignment.centerLeft,
                  child: Text('KPIs',
                      style: Theme.of(context).textTheme.titleMedium)),
              Text(_kpis.toString()),
            ],
          ],
        ),
      ),
    );
  }
}
