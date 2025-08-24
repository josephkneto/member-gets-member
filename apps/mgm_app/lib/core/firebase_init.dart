import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeFirebaseAndPlugins() async {
  if (Firebase.apps.isEmpty) {
    if (kIsWeb) {
      final apiKey = dotenv.env['FIREBASE_API_KEY'] ?? '';
      final authDomain = dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '';
      final projectId = dotenv.env['FIREBASE_PROJECT_ID'] ?? '';
      final storageBucket = dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '';
      final messagingSenderId =
          dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '';
      final appId = dotenv.env['FIREBASE_APP_ID'] ?? '';
      if (apiKey.isNotEmpty && projectId.isNotEmpty && appId.isNotEmpty) {
        await Firebase.initializeApp(
          options: FirebaseOptions(
            apiKey: apiKey,
            authDomain: authDomain.isEmpty ? null : authDomain,
            projectId: projectId,
            storageBucket: storageBucket.isEmpty ? null : storageBucket,
            messagingSenderId: messagingSenderId,
            appId: appId,
          ),
        );
      }
    } else {
      // Android/iOS/macOS use native config files (google-services / GoogleService-Info)
      await Firebase.initializeApp();
    }
  }

  if (Firebase.apps.isNotEmpty) {
    FirebaseFirestore.instance.settings =
        const Settings(persistenceEnabled: true);
  }

  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: android);
  await flutterLocalNotificationsPlugin.initialize(initSettings);
}
