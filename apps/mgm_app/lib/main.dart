import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/firebase_init.dart';
import 'core/theme.dart';
import 'app_router.dart';
import 'utils/deep_links.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await initializeFirebaseAndPlugins();
  await capturePendingReferralCodeOnce();
  runApp(const ProviderScope(child: MGMApp()));
}

class MGMApp extends ConsumerWidget {
  const MGMApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = createRouter(ref);
    return MaterialApp.router(
      title: 'MGM',
      theme: buildAppTheme(),
      routerConfig: router,
    );
  }
}
