import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final _plugin = FlutterLocalNotificationsPlugin();
  Future<bool?>? _initialization;

  Future<bool> show(String title, String body) async {
    final initialized = await (_initialization ??= _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('ic_lab_notification'),
      ),
    ));
    if (initialized != true) return false;
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android == null) return false;

    if (await android.areNotificationsEnabled() != true) {
      final granted = await android.requestNotificationsPermission();
      if (granted != true || await android.areNotificationsEnabled() != true) {
        return false;
      }
    }

    await _plugin.show(
      id: 1,
      title: title,
      body: body,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'lab10_activity',
          'Lab 10 activity',
          channelDescription: 'Notifications for actions in Lab 10.',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
    return true;
  }
}
