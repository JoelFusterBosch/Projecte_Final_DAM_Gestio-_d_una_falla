import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/cobrador.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/domain/repository/nfc_repository.dart';
import 'package:gestio_falla/presentation/screens/barra_screen.dart';
import 'package:gestio_falla/presentation/screens/descompta_cadira_screen.dart';
import 'package:gestio_falla/presentation/screens/escudellar_screen.dart';
import 'package:gestio_falla/presentation/screens/principal_screen.dart';

class NfcProvider with ChangeNotifier {
  final NfcRepository _nfcRepository;

  NfcProvider(this._nfcRepository);

  String _nfcData = "Escaneja una etiqueta NFC";
  String get nfcData => _nfcData;

  Faller faller = Faller(nom: "Joel", rol: "Faller", cobrador: Cobrador(rolCobrador: "Cadires"), valorPulsera: "8430001000017", teLimit: false, estaLoguejat: true);

  Future<void> llegirEtiqueta(BuildContext context) async {
    _nfcData = "Acosta una etiqueta NFC perfavor";
    notifyListeners();

    final valorLlegit = await _nfcRepository.llegirNfc(
      valorEsperat: faller.valorPulsera,
      onCoincidencia: () {
        _nfcData = "Acció realitzada per valor NFC: ${faller.valorPulsera}";
        
        if(faller.rol=="Cobrador"){
          switch (faller.cobrador!.rolCobrador) {
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
        notifyListeners();
        } else if(faller.rol == "Faller") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PrincipalScreen()),
          );
          notifyListeners();
        }
        
      },
      onError: () {
        _nfcData = "Valor llegit no coincideix o error";
        notifyListeners();
      },
    );

    if (valorLlegit != null) {
      _nfcData = "Valor llegit: $valorLlegit";
      notifyListeners();
    } else {
      _nfcData = "No s'ha pogut llegir l'etiqueta.";
      notifyListeners();
    }
  }
  Future<void> escriureNFC(BuildContext context) async {
    _nfcData = "Acosta una etiqueta NFC perfavor";
    notifyListeners();
    final valorLlegit = await _nfcRepository.escriureNFC("8430001000017");
    notifyListeners();
    _nfcData="Etiqueta nfc canviada amb el valor $valorLlegit";
    notifyListeners();
  }
}