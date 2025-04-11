import 'package:gestio_falla/domain/repository/notificacions_repository.dart';
import 'package:gestio_falla/infrastructure/data_source/notificacions_datasource.dart';

class NotificacionsRepositoryImpl implements NotificacionsRepository{
  final NotificacionsDatasource _notificacionsDatasource;

  NotificacionsRepositoryImpl(this._notificacionsDatasource);
  @override
  Future<void> initialize() async{
    await _notificacionsDatasource.init();
  }

  @override
  Future<void> showNotification({required String title, required String body}) async{
    await _notificacionsDatasource.showNotification(title: title, body: body);
  }

}