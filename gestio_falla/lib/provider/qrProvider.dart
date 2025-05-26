import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/event.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/domain/entities/producte.dart';
import 'package:gestio_falla/domain/repository/qr_repository.dart';
import 'package:gestio_falla/presentation/screens/barra_screen.dart';
import 'package:gestio_falla/presentation/screens/descompta_cadira_screen.dart';
import 'package:gestio_falla/presentation/screens/escudellar_screen.dart';
import 'package:gestio_falla/presentation/screens/principal_screen.dart';
import 'package:gestio_falla/provider/Api-OdooProvider.dart';

class Qrprovider with ChangeNotifier{
  final QrRepository qrRepository;
  final Faller faller;
  final ApiOdooProvider apiOdooProvider;

  Qrprovider(this.qrRepository, this.faller, this.apiOdooProvider);
  String _qrData = "Escaneja un QR";
  String get qrData => _qrData;
  List <Producte>totsElsProductes=[
    Producte(nom: "Aigua 500ml", preu: 1 ,stock: 20, eventEspecific: false),
    Producte(nom: "Cervesa 33cl", preu: 1.5, stock: 33, eventEspecific: false),
    Producte(nom: "Coca-Cola", preu: 1.30, stock: 0, eventEspecific: false),
    Producte(nom: "Pepsi", preu: 1.25, stock: 77, eventEspecific: false),  
  ];

  Event event = Event(nom: "Paella", dataInici:DateTime(2025,3,16,14,0), dataFi:DateTime(2025,3,16,17,0), numCadires: 10, prodEspecific: true, producte: Producte(nom: "Hamburguesa", preu: 2.5, stock: 10, eventEspecific: true));


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
                  MaterialPageRoute(builder: (_) => DescomptaCadira(faller: faller,)),
                );
                break;
              case 'Barra':
                //await apiOdooProvider.getProductesBarra();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Barra(faller: faller,totsElsProductes:totsElsProductes/*apiOdooProvider.productes.cast<Producte>() */,)),
                );
                break;
              case 'Escudellar':
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Escudellar(faller: faller, producte: event.producte,)),
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
          }else{
            switch (faller.cobrador!.rolCobrador) {
              case 'Cadires':
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => DescomptaCadira(faller: faller,)),
                );
                break;
              case 'Barra':
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Barra(faller: faller,totsElsProductes:totsElsProductes/*apiOdooProvider.getProductesBarra() */,)),
                );
                break;
              case 'Escudellar':
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Escudellar(faller: faller, producte: event.producte,)),
                );
                break;
            }
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