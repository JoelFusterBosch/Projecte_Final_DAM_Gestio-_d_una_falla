// nfc_repository_impl.dart
import 'package:gestio_falla/domain/repository/nfc_repository.dart';
import 'package:gestio_falla/infrastructure/data_source/nfc_datasource.dart';


class NfcRepositoryImpl implements NfcRepository {
  final NfcDataSource _nfcDataSource;

  NfcRepositoryImpl(this._nfcDataSource);

  @override
  Future<String?> llegirNfc({
    required String valorEsperat,
    void Function()? onCoincidencia,
    void Function()? onError,
  }) {
    return _nfcDataSource.llegirNFC(
      valorEsperat: valorEsperat,
      onCoincidencia: onCoincidencia,
      onError: onError,
    );
  }
    
  @override
  Future<String> escriureNFC(String valorAEscriure) {
    return _nfcDataSource.escriureNFC(valorAEscriure);
  }
}
