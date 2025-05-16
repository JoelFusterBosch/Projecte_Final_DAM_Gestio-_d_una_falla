import 'package:gestio_falla/domain/repository/Api-Odoo_repository.dart';
// import 'package:gestio_falla/infrastructure/data_source/Api-Odoo_datasource.dart';
import 'package:gestio_falla/infrastructure/data_source/Fake_Api-Odoo.datasource.dart';

class ApiOdooRepositoryImpl implements ApiOdooRepository {
  final FakeApiOdooDataSource fakeApiOdooDataSource;

  ApiOdooRepositoryImpl(this.fakeApiOdooDataSource);

/*Descomentar quan vaja a fer peticions per l'API de Odoo
  @override
  Future<int?> login(String email, String password) async {
    return fakeApiOdooDataSource.login(email, password);
  }
  
  @override
  Future<List?> getUsers(int uid, String password) {
    return fakeApiOdooDataSource.getFallers(uid, password);
  }
  
   
  @override
  Future<List?> getEvents(int uid, String password) {
    return fakeApiOdooDataSource.getEvents(uid, password);
  }
*/
  @override
  Future<List?> getFallers() {
    return fakeApiOdooDataSource.getFallers();
  }

  @override
  Future<List?> getEvents() async {
    return fakeApiOdooDataSource.getEvents();
  }
  
  @override
  Future<String> saluda() {
    return fakeApiOdooDataSource.saluda();
  }
  
  @override
  Future<List?> getFamilies() {
    return fakeApiOdooDataSource.getFamilies();
  }
  
  @override
  Future<List?> getCobradors() {
    return fakeApiOdooDataSource.getCobradors();
  }
  
  @override
  Future<List?> getProductes() {
    return fakeApiOdooDataSource.getProductes();
  }
  
  @override
  Future<List?> getTickets() {
    return fakeApiOdooDataSource.getTickets();
  }
  
}
