import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeFirebaseAndPlugins() async {
  // Firebase is already initialized via JavaScript in web/index.html for web platform
  // For other platforms, uncomment the line below when Firebase is properly configured
  // await Firebase.initializeApp();

  // Note: Firestore settings should only be set after Firebase is initialized
  // FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: true);

  const android = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: android);
  await flutterLocalNotificationsPlugin.initialize(initSettings);
}
