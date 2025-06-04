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
  Faller? _faller;
  ApiOdooProvider? _apiOdooProvider;

  NfcProvider(this._nfcRepository);

  void setFaller(Faller faller) {
    faller = faller;
    notifyListeners();
  }

  set apiOdooProvider(ApiOdooProvider? provider) {
    _apiOdooProvider = provider;
    notifyListeners();
  }

  Faller? get faller => _faller;
  ApiOdooProvider? get apiOdooProvider => _apiOdooProvider;
  
  String _nfcData = "Escaneja una etiqueta NFC";
  String get nfcData => _nfcData;
  Event? get eventActiu {
    if (apiOdooProvider!.events.isEmpty){
      return null;
    } 
    return apiOdooProvider!.events.last;
  }

  List<Producte> get productesBarra => apiOdooProvider!.productes.cast<Producte>();

  Future<void> llegirEtiqueta(BuildContext context) async {
    _nfcData = "Acosta una etiqueta NFC perfavor";
    notifyListeners();

    final valorLlegit = await _nfcRepository.llegirNfc(
      valorEsperat: faller!.valorpulsera,
        onCoincidencia: () async {
        _nfcData = "Valor llegit ${faller!.valorpulsera}";

        if (faller!.rol == "Cobrador" || faller!.rol == "SuperAdmin") {
          if (faller!.estaloguejat) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => PrincipalScreen(faller: faller)),
            );
          } else {
            switch (faller!.cobrador_id!.rolcobrador) {
              case 'Cadires':
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => DescomptaCadira(faller: faller, event: eventActiu,)),
                );
                break;

              case 'Barra':
                if (apiOdooProvider!.productes.isEmpty) {
                  await apiOdooProvider!.getProductesBarra();
                }

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Barra(
                      faller: faller,
                      totsElsProductes: apiOdooProvider!.productes.cast<Producte>(),
                    ),
                  ),
                );
                break;

              case 'Escudellar':
                await apiOdooProvider!.getEvents();
                final event = eventActiu;

                if (event == null || event.producte_id == null) {
                  _nfcData = "No s'ha trobat cap event actiu amb producte";
                  notifyListeners();
                  return;
                }

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => Escudellar(
                      faller: faller,
                      producte: event.producte_id!,
                    ),
                  ),
                );
                break;
            }
          }
        } else {
          // Per a Faller, Administrador o altres rols
          if (faller!.estaloguejat) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => PrincipalScreen(faller: faller)),
            );
          }
        }

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
    } else {
      _nfcData = "No s'ha pogut llegir l'etiqueta.";
      notifyListeners();
    }
  }
  Future<String?> llegirEtiquetaRetornantValor(BuildContext context) async {
    _nfcData = "Acosta una etiqueta NFC perfavor";
    notifyListeners();

    try {
      final valorLlegit = await _nfcRepository.llegirNfc(
        valorEsperat: "", // busquem qualsevol valor
        onCoincidencia: () {}, // no fem res aquí
        onError: () {
          _nfcData = "Error en la lectura NFC";
          notifyListeners();
        },
      );
      if (valorLlegit != null) {
        _nfcData = "Valor llegit: $valorLlegit";
        notifyListeners();
        return valorLlegit;
      }
    } catch (e) {
      _nfcData = "Error en la lectura NFC";
      notifyListeners();
    }
    return null;
  }

  Future<void> escriureNFC(String valorPulsera) async {
    _nfcData = "Acosta una etiqueta NFC perfavor";
    notifyListeners();
    final valorLlegit = await _nfcRepository.escriureNFC(valorPulsera);
    notifyListeners();
    _nfcData="Etiqueta nfc canviada amb el valor $valorLlegit";
    notifyListeners();
  }

}