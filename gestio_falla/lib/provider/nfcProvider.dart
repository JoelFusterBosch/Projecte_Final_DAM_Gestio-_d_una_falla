import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/producte.dart';
import 'package:gestio_falla/domain/repository/nfc_repository.dart';
import 'package:gestio_falla/presentation/screens/barra_screen.dart';
import 'package:gestio_falla/presentation/screens/descompta_cadira_screen.dart';
import 'package:gestio_falla/presentation/screens/escudellar_screen.dart';
import 'package:gestio_falla/presentation/screens/principal_screen.dart';

class NfcProvider with ChangeNotifier {
  final NfcRepository _nfcRepository;
  final faller;
  NfcProvider(this._nfcRepository, this.faller);

  String _nfcData = "Escaneja una etiqueta NFC";
  String get nfcData => _nfcData;
  List <Producte>totsElsProductes=[
    Producte(nom: "Aigua 500ml", preu: 1 ,stock: 20),
    Producte(nom: "Cervesa 33cl", preu: 1.5, stock: 33),
    Producte(nom: "Coca-Cola", preu: 1.30, stock: 0),
    Producte(nom: "Pepsi", preu: 1.25, stock: 77),  
  ];

  Future<void> llegirEtiqueta(BuildContext context) async {
    _nfcData = "Acosta una etiqueta NFC perfavor";
    notifyListeners();

    final valorLlegit = await _nfcRepository.llegirNfc(
      valorEsperat: faller.valorPulsera,
        onCoincidencia: () {
          _nfcData = "Acció realitzada per valor NFC: ${faller.valorPulsera}";
          
          if(faller.rol=="Cobrador"){
            if(!faller.estaLoguejat){
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
                MaterialPageRoute(builder: (context) => Barra(faller: faller,totsElsProductes: totsElsProductes,)),
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
          }
        } else if (faller.rol == "Faller") {
          if(!faller.estaLoguejat){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => PrincipalScreen(faller: faller)),
            );
          }
        }else if (faller.rol == "Admin") {
          if(!faller.estaLoguejat){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => PrincipalScreen(faller: faller)),
            );
          }
        }else if (faller.rol == "SuperAdmin") {
          if(!faller.estaLoguejat){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => PrincipalScreen(faller: faller)),
            );
          }
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