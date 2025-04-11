abstract class NotificacionsRepository {
  Future<void> initialize();
  Future<void> showNotification({
    required String title,
    required String body,
  });
}