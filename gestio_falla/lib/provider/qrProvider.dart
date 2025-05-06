import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/cobrador.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/domain/repository/qr_repository.dart';
import 'package:gestio_falla/presentation/screens/barra_screen.dart';
import 'package:gestio_falla/presentation/screens/descompta_cadira_screen.dart';
import 'package:gestio_falla/presentation/screens/escudellar_screen.dart';

class Qrprovider with ChangeNotifier{
  final QrRepository qrRepository;

  Qrprovider(this.qrRepository);
  String _qrData = "Escaneja un QR";
  String get qrData => _qrData;

  Faller faller = Faller(nom: "Joel", rol: "Cobrador", cobrador: Cobrador(rolCobrador: "Barra"));

  Future<void> llegirQR(BuildContext context) async {
    _qrData="Llegint QR...";
    notifyListeners();
    qrRepository.llegirQR(
      context: context, 
      valorEsperat: "8430001000017", 
      onCoincidencia: (){
        _qrData="Valor llegit 8430001000017";
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
      },
      onError: () {
        _qrData="Error al escanetjar el QR";
        notifyListeners();
      },
      onDiferent: (valorLlegit) {
        _qrData= "Valor llegit $valorLlegit";
        notifyListeners();
      },
    );
    }
}