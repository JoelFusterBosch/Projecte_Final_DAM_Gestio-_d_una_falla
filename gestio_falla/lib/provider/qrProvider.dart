import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/event.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/domain/repository/qr_repository.dart';
import 'package:gestio_falla/presentation/screens/barra_screen.dart';
import 'package:gestio_falla/presentation/screens/descompta_cadira_screen.dart';
import 'package:gestio_falla/presentation/screens/escudellar_screen.dart';
import 'package:gestio_falla/presentation/screens/principal_screen.dart';
import 'package:gestio_falla/provider/Api-OdooProvider.dart';

class Qrprovider with ChangeNotifier {
  final QrRepository qrRepository;
  Faller? _faller;
  ApiOdooProvider? _apiOdooProvider;

  Qrprovider(this.qrRepository);

  set faller(Faller? fallerNou) {
    _faller = fallerNou;
    notifyListeners();
  }
  
  void setFaller(Faller faller) {
    faller=faller;
    notifyListeners();
  }

  set apiOdooProvider(ApiOdooProvider? provider) {
    _apiOdooProvider = provider;
    notifyListeners();
  }

  Faller? get faller => _faller;
  ApiOdooProvider? get apiOdooProvider => _apiOdooProvider;



  String _qrData = "Escaneja un QR";
  String get qrData => _qrData;

  // Getter per obtenir l'event actiu
  Event? get eventActiu {
    final now = DateTime.now();
    return apiOdooProvider!.events.firstWhere(
      (e) => e.datainici.isBefore(now) && e.datafi.isAfter(now)
    );
  }

  Future<void> llegirQR(BuildContext context) async {
    _qrData = "Llegint QR...";
    notifyListeners();

    qrRepository.llegirQR(
      context: context,
      valorEsperat: faller!.valorpulsera,
      onCoincidencia: () async {
        _qrData = "Valor llegit ${faller!.valorpulsera}";

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
                    ),
                  ),
                );
                break;

              case 'Escudellar':
                await apiOdooProvider!.getEvents();
                final event = eventActiu;

                if (event == null || event.producte_id == null) {
                  _qrData = "No s'ha trobat cap event actiu amb producte";
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
        _qrData = "Error al escanejar el QR";
        notifyListeners();
      },
      onDiferent: (valorLlegit) {
        _qrData = "Valor llegit $valorLlegit";
        notifyListeners();
      },
    );
  }

  Future<String?> llegirQRRetornantValor(BuildContext context) async {
    _qrData = "Llegint QR...";
    notifyListeners();

    try {
      final valorLlegit = await qrRepository.llegirQRAmbRetorn(context);
      if (valorLlegit != null) {
        _qrData = "Valor llegit: $valorLlegit";
        notifyListeners();
        return valorLlegit;
      }
    } catch (e) {
      _qrData = "Error al escanejar el QR";
      notifyListeners();
    }

    return null;
  }
}