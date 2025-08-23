import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:mgm_app/features/dashboard/dashboard_screen.dart';

void main() {
  testWidgets('Dashboard smoke test', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DashboardScreen()));
    expect(find.text('Dashboard'), findsOneWidget);
  });
}
