import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../core/firebase_init.dart';

class NotificationsHelper {
  Future<void> showPointsEarned(int points) async {
    const androidDetails = AndroidNotificationDetails(
      'rewards_channel',
      'Rewards',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(android: androidDetails);
    await flutterLocalNotificationsPlugin.show(
      1,
      'Parabens! 🎉',
      'Voce ganhou $points pontos!',
      details,
    );
  }
}
