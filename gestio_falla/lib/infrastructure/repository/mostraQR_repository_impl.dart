import 'package:gestio_falla/domain/repository/mostraQR_repository.dart';
import 'package:gestio_falla/infrastructure/data_source/mostraQR_datasource.dart';

class MostraqrRepositoryImpl implements MostraqrRepository{
  final MostraqrDatasource mostraqrDatasource;

  MostraqrRepositoryImpl(this.mostraqrDatasource);
  @override
  Future<String> mostraQR({required String valorQRaMostrar}) async{
    return mostraqrDatasource.mostrarQR(valorQRaMostrar: valorQRaMostrar);
  }
}