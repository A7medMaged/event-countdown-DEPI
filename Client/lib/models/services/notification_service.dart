import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  NotificationService(this.flutterLocalNotificationsPlugin);

  Future<void> initializeNotification() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'channel_id',
          'channel_name',
          importance: Importance.max,
          priority: Priority.high,
          enableVibration: true,
          enableLights: true,
        );

    const NotificationDetails generalNotificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'Event countdown app',
      '$title countdown has finished!',
      generalNotificationDetails,
    );
  }

  Future<void> scheduleNotificationBefore15Minutes(
    String title,
    DateTime eventTime,
    int id,
  ) async {
    final scheduledTime = eventTime.subtract(const Duration(minutes: 15));
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'reminder_channel',
          'Event Reminders',
          channelDescription: 'Notifications before events start',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('alarm'),
          enableVibration: true,
        );

    const NotificationDetails generalNotificationDetails = NotificationDetails(
      android: androidDetails,
    );
    if (scheduledTime.isAfter(DateTime.now())) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'Upcoming Event',
        '$title will start in 15 minutes.',
        tz.TZDateTime.from(scheduledTime, tz.local),
        generalNotificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  Future<void> scheduleNotificationOnFinish(
    String title,
    DateTime eventTime,
    int id,
  ) async {
    debugPrint(
      'Attempting to schedule finish notification for: $title at ${eventTime.toString()}',
    );
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'completion_channel',
          'Event Completions',
          channelDescription: 'Notifications when events finish',
          importance: Importance.max,
          sound: RawResourceAndroidNotificationSound('success'),
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        );

    const NotificationDetails generalNotificationDetails = NotificationDetails(
      android: androidDetails,
    );
    if (eventTime.isAfter(DateTime.now())) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id + 1000,
        'Event Finished',
        '$title has finished!',
        tz.TZDateTime.from(eventTime, tz.local),
        generalNotificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
      debugPrint('Successfully scheduled finish notification for: $title');
    } else {
      debugPrint(
        'Could not schedule finish notification for: $title - Event time is in the past',
      );
    }
  }

  Future<void> scheduleNotificationOnFinishRemote(
    String title,
    DateTime eventTime,
    String id,
  ) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'completion_channel',
          'Event Completions',
          channelDescription: 'Notifications when events finish',
          importance: Importance.max,
          sound: RawResourceAndroidNotificationSound('success'),
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
        );

    const NotificationDetails generalNotificationDetails = NotificationDetails(
      android: androidDetails,
    );
    if (eventTime.isAfter(DateTime.now())) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        1,
        'Event Finished',
        '$title has finished!',
        tz.TZDateTime.from(eventTime, tz.local),
        generalNotificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  Future<void> scheduleCustomReminder(
    String title,
    DateTime eventTime,
    Duration beforeDuration,
    int id,
  ) async {
    final scheduledTime = eventTime.subtract(beforeDuration);

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'custom_reminder_channel',
          'Custom Event Reminders',
          channelDescription: 'User-defined reminders before events',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('alarm'),
          enableVibration: true,
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    if (scheduledTime.isAfter(DateTime.now())) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'Event Reminder',
        '$title is coming up soon!',
        tz.TZDateTime.from(scheduledTime, tz.local),
        notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelEventNotifications(int eventId) async {
    await flutterLocalNotificationsPlugin.cancel(eventId);
    await flutterLocalNotificationsPlugin.cancel(eventId + 1000);
    debugPrint('Cancelled all notifications for event ID: $eventId');
  }
}
