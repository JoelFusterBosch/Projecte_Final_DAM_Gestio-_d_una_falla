import 'package:gestio_falla/domain/repository/Api-Odoo_repository.dart';
// import 'package:gestio_falla/infrastructure/data_source/Api-Odoo_datasource.dart';
import 'package:gestio_falla/infrastructure/data_source/Fake_Api-Odoo.datasource.dart';

class ApiOdooRepositoryImpl implements ApiOdooRepository {
  final FakeApiOdooDataSource fakeApiOdooDataSource;

  ApiOdooRepositoryImpl(this.fakeApiOdooDataSource);

  @override
  Future<int?> login(String email, String password) async {
    return fakeApiOdooDataSource.login(email, password);
  }
  
  @override
  Future<List?> getUsers(int uid, String password) {
    return fakeApiOdooDataSource.getUsers(uid, password);
  }
  
  @override
  Future<List?> getEvents(int uid, String password) {
    return fakeApiOdooDataSource.getEvents(uid, password);
  }
  
  @override
  Future<String> saluda() {
    return fakeApiOdooDataSource.saluda();
  }
}
