import 'package:gestio_falla/domain/repository/Api-Odoo_repository.dart';
import 'package:gestio_falla/infrastructure/data_source/Api-Odoo_datasource.dart';

class ApiOdooRepositoryImpl implements ApiOdooRepository{
  final ApiOdooDataSource apiOdooDataSource;

  ApiOdooRepositoryImpl(this.apiOdooDataSource);
  @override
  Future<int?> login(String email, String password) {
    return apiOdooDataSource.login(email, password);
  }

}