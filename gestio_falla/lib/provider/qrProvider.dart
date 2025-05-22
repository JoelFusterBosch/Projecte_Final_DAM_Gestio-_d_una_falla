import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/producte.dart';
import 'package:gestio_falla/domain/repository/qr_repository.dart';
import 'package:gestio_falla/presentation/screens/barra_screen.dart';
import 'package:gestio_falla/presentation/screens/descompta_cadira_screen.dart';
import 'package:gestio_falla/presentation/screens/escudellar_screen.dart';
import 'package:gestio_falla/presentation/screens/principal_screen.dart';

class Qrprovider with ChangeNotifier{
  final QrRepository qrRepository;
  final faller;

  Qrprovider(this.qrRepository, this.faller);
  String _qrData = "Escaneja un QR";
  String get qrData => _qrData;
  List <Producte>totsElsProductes=[
    Producte(nom: "Aigua 500ml", preu: 1 ,stock: 20),
    Producte(nom: "Cervesa 33cl", preu: 1.5, stock: 33),
    Producte(nom: "Coca-Cola", preu: 1.30, stock: 0),
    Producte(nom: "Pepsi", preu: 1.25, stock: 77),  
  ];

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
                  MaterialPageRoute(builder: (_) => Barra(faller: faller,totsElsProductes:totsElsProductes,)),
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