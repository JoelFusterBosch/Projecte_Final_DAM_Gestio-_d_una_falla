import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/repository/notificacions_repository.dart';

class NotificacionsProvider with ChangeNotifier {
  final NotificacionsRepository _notificacionsRepository;

  NotificacionsProvider(this._notificacionsRepository);

  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    await _notificacionsRepository.showNotification(title: title, body: body);
    notifyListeners(); 
  }
}
