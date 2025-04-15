import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/repository/nfc_repository.dart';
import 'package:gestio_falla/presentation/screens/descompta_cadira_screen.dart';

class NfcProvider with ChangeNotifier {
  final NfcRepository _nfcRepository;

  NfcProvider(this._nfcRepository);

  String _nfcData = "Escaneja una etiqueta NFC";
  String get nfcData => _nfcData;

  String rol = "Cobrador"; // Esto puedes modificarlo desde fuera

  Future<void> llegirEtiqueta(BuildContext context) async {
    _nfcData = "Acosta una etiqueta NFC perfavor";
    notifyListeners();

    final valorLlegit = await _nfcRepository.llegirNfc(
      valorEsperat: '8430001000017',
      onCoincidencia: () {
        _nfcData = "Acció realitzada per valor NFC: 8430001000017";
        notifyListeners();
      },
      onError: () {
        _nfcData = "Valor llegit no coincideix o error";
        notifyListeners();
      },
    );

    if (valorLlegit != null) {
      _nfcData = "Valor llegit: $valorLlegit";
      notifyListeners();

      if (valorLlegit == '8430001000017') {
        _nfcData = "Acció realitzada per valor NFC: $valorLlegit";
        notifyListeners();

        switch (rol) {
          case 'Cobrador':
          case 'Barra':
          case 'Escudellar':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DescomptaCadira()),
            );
            break;
        }
      }
    } else {
      _nfcData = "No s'ha pogut llegir l'etiqueta.";
      notifyListeners();
    }
  }
}