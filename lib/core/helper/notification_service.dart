import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  // نسخة واحدة (Singleton Pattern)
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // الكائن الرئيسي
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // تهيئة
  Future<void> init() async {
    const android = AndroidInitializationSettings('splash');
    const iOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(android: android, iOS: iOS);

    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    // طلب الأذونات
    await _requestPermissions();
  }

  // معالجة النقر على الإشعار
  void _onNotificationTap(NotificationResponse response) {
    debugPrint('تم النقر على الإشعار: ${response.payload}');
    // يمكنك إضافة التنقل هنا
  }

  // طلب الأذونات
  Future<void> _requestPermissions() async {
    // iOS
    await _plugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Android 13+
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (androidPlugin != null) {
      await androidPlugin.requestNotificationsPermission();
      await androidPlugin.requestExactAlarmsPermission();
    }
  }

  // إشعار يومي
  Future<void> scheduleDailyAt(int hour, int minute) async {
    await _plugin.zonedSchedule(
      id: 3,
      title: 'تذكير يومي',
      body: 'وقت المذاكرة!',
      scheduledDate: _nextInstanceOfTime(hour, minute),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Daily Notifications',
          channelDescription: 'قناة الإشعارات اليومية',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time, // ✅ صحيح للتكرار اليومي
    );
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  // ✅ إشعار بتاريخ ووقت محددين (محسّن)
  Future<void> scheduleAtDateTime(
      DateTime scheduledDateTime, int id, String title) async {
    const androidDetails = AndroidNotificationDetails(
      'custom_date_channel',
      'Custom Date Notifications',
      channelDescription: 'Notifications scheduled for specific date/time',
      importance: Importance.max,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails();
    const details =
        NotificationDetails(android: androidDetails, iOS: iosDetails);

    // استخدام timestamp كـ ID

    await _plugin.zonedSchedule(
      id: id,
      notificationDetails: details,
      scheduledDate: tz.TZDateTime.from(scheduledDateTime, tz.local),
      title: '📅  $title',
      body:
          'تم جدولة هذا الإشعار ليوم ${scheduledDateTime.day}/${scheduledDateTime.month}',
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      // ❌ تم حذف matchDateTimeComponents لأنه إشعار لمرة واحدة
    );
  }

  // الحصول على الإشعارات المعلقة
  Future<List<String>> getPendingNotifications() async {
    final pending = await _plugin.pendingNotificationRequests();
    return pending.map((n) => '${n.id}: ${n.title}').toList();
  }

  // إلغاء إشعار معين
  Future<void> cancel(int id) async {
    await _plugin.cancel(
      id: id,
    );
  }

  // إلغاء الكل
  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}
