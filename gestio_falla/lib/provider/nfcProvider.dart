import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/cobrador.dart';
import 'package:gestio_falla/domain/repository/nfc_repository.dart';
import 'package:gestio_falla/presentation/screens/barra_screen.dart';
import 'package:gestio_falla/presentation/screens/descompta_cadira_screen.dart';
import 'package:gestio_falla/presentation/screens/escudellar_screen.dart';

class NfcProvider with ChangeNotifier {
  final NfcRepository _nfcRepository;

  NfcProvider(this._nfcRepository);

  String _nfcData = "Escaneja una etiqueta NFC";
  String get nfcData => _nfcData;

  Cobrador cobrador = Cobrador(rolCobrador: "Escudellar");

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

        switch (cobrador.rolCobrador) {
          case 'Cadires':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DescomptaCadira()),
            );
            break;
          case 'Barra':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Barra()),
            );
            break;
          case 'Escudellar':
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Escudellar()),
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