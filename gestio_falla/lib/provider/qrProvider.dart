import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/cobrador.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/domain/repository/qr_repository.dart';
import 'package:gestio_falla/presentation/screens/barra_screen.dart';
import 'package:gestio_falla/presentation/screens/descompta_cadira_screen.dart';
import 'package:gestio_falla/presentation/screens/escudellar_screen.dart';
import 'package:gestio_falla/presentation/screens/principal_screen.dart';

class Qrprovider with ChangeNotifier{
  final QrRepository qrRepository;

  Qrprovider(this.qrRepository);
  String _qrData = "Escaneja un QR";
  String get qrData => _qrData;

  Faller faller = Faller(nom: "Joel", rol: "SuperAdmin", cobrador: Cobrador(rolCobrador: "Barra"), valorPulsera: '8430001000017', teLimit: false, estaLoguejat: false);

  Future<void> llegirQR(BuildContext context) async {
    _qrData = "Llegint QR...";
    notifyListeners();

    qrRepository.llegirQR(
      context: context,
      valorEsperat: faller.valorPulsera,
      onCoincidencia: () {
        _qrData = "Valor llegit ${faller.valorPulsera}";

        if (faller.rol == "Cobrador") {
          if(!faller.estaLoguejat){
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => PrincipalScreen(faller: faller)),
            );
          }else{
            switch (faller.cobrador!.rolCobrador) {
              case 'Cadires':
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DescomptaCadira()),
                );
                break;
              case 'Barra':
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Barra()),
                );
                break;
              case 'Escudellar':
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Escudellar()),
                );
                break;
            }
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

}