// nfc_repository.dart
abstract class NfcRepository {
  Future<String?> llegirNfc({
    required String valorEsperat,
    void Function()? onCoincidencia,
    void Function()? onError,
  });

  Future<String> escriureNFC(String valorAEscriure);
}
