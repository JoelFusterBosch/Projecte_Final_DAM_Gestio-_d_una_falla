import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/event.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/domain/entities/producte.dart';
import 'package:gestio_falla/domain/repository/nfc_repository.dart';
import 'package:gestio_falla/presentation/screens/barra_screen.dart';
import 'package:gestio_falla/presentation/screens/descompta_cadira_screen.dart';
import 'package:gestio_falla/presentation/screens/escudellar_screen.dart';
import 'package:gestio_falla/presentation/screens/principal_screen.dart';
import 'package:gestio_falla/provider/Api-OdooProvider.dart';

class NfcProvider with ChangeNotifier {
  final NfcRepository _nfcRepository;
  final Faller faller;
  final ApiOdooProvider apiOdooProvider;
  NfcProvider(this._nfcRepository, this.faller, this.apiOdooProvider);

  String _nfcData = "Escaneja una etiqueta NFC";
  String get nfcData => _nfcData;
  List <Producte>totsElsProductes=[
    Producte(nom: "Aigua 500ml", preu: 1 ,stock: 20, eventEspecific: false),
    Producte(nom: "Cervesa 33cl", preu: 1.5, stock: 33, eventEspecific: false),
    Producte(nom: "Coca-Cola", preu: 1.30, stock: 0, eventEspecific: false),
    Producte(nom: "Pepsi", preu: 1.25, stock: 77, eventEspecific: false),  
  ];
  Event event = Event(nom: "Paella", dataInici:DateTime(2025,3,16,14,0), dataFi:DateTime(2025,3,16,17,0), numCadires: 10, prodEspecific: true, producte: Producte(nom: "Hamburguesa", preu: 2.5, stock: 10, eventEspecific: true));
  List<Producte> get productesBarra {
    return apiOdooProvider.productes.cast<Producte>();
  }

  Future<void> llegirEtiqueta(BuildContext context) async {
    _nfcData = "Acosta una etiqueta NFC perfavor";
    notifyListeners();

    final valorLlegit = await _nfcRepository.llegirNfc(
      valorEsperat: faller.valorPulsera,
        onCoincidencia: () async{
          _nfcData = "Acció realitzada per valor NFC: ${faller.valorPulsera}";
          
          if(faller.rol=="Cobrador"){
            if(!faller.estaLoguejat){
              switch (faller.cobrador!.rolCobrador) {
            case 'Cadires':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DescomptaCadira(faller: faller,)),
              );
              break;
            case 'Barra':
              await apiOdooProvider.getProductesBarra();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Barra(faller: faller,totsElsProductes: totsElsProductes,/*apiOdooProvider.productes.cast<Producte>() */)),
              );
              break;
            case 'Escudellar':
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Escudellar(faller: faller, producte: event.producte,)),
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
        }else if (faller.rol == "Administrador") {
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