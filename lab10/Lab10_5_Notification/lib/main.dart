import 'package:flutter/material.dart';

import 'notification_service.dart';

void main() => runApp(const NotificationApp());

class NotificationApp extends StatelessWidget {
  const NotificationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 10.5 · Notifications',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const _NotificationScreen(),
    );
  }
}

class _NotificationScreen extends StatefulWidget {
  const _NotificationScreen();

  @override
  State<_NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<_NotificationScreen> {
  final _notifications = NotificationService();
  String? _status;
  bool _sending = false;

  Future<void> _send() async {
    setState(() {
      _sending = true;
      _status = null;
    });
    try {
      final sent = await _notifications.show(
        'Lab 10.5 test notification',
        'Your local notification is ready.',
      );
      if (mounted) {
        setState(
          () => _status = sent
              ? 'Notification sent. Open the Android notification shade.'
              : 'Allow notifications in Android settings and try again.',
        );
      }
    } catch (_) {
      if (mounted) {
        setState(() => _status = 'Could not send the notification. Try again.');
      }
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Lab 10.5 · Notifications')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Icon(Icons.notifications_active_outlined, size: 44),
            const SizedBox(height: 20),
            const Text(
              'Local notifications',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Send a test notification from this device.'),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _sending ? null : _send,
              icon: const Icon(Icons.notifications_outlined),
              label: const Text('Send notification'),
            ),
            if (_sending) const LinearProgressIndicator(),
            if (_status != null)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(_status!),
              ),
          ],
        ),
      ),
    );
  }
}
