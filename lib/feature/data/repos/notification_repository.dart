abstract class NotificationRepository {
  Future<void> init();
  Future<void> scheduleDailyAt(int hour, int minute);
  Future<void> scheduleAtDateTime(
      DateTime scheduledDateTime, int id, String title);
  Future<List<String>> getPendingNotifications();
  Future<void> cancel(int id);
  Future<void> cancelAll();
}
