import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/cobrador.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/domain/entities/familia.dart';
// import 'package:gestio_falla/infrastructure/data_source/Api-Odoo_datasource.dart';
import 'package:gestio_falla/infrastructure/data_source/Fake_Api-Odoo.datasource.dart';
import 'package:gestio_falla/infrastructure/data_source/mostraQR_datasource.dart';
import 'package:gestio_falla/infrastructure/data_source/nfc_datasource.dart';
import 'package:gestio_falla/infrastructure/data_source/notificacions_datasource.dart';
import 'package:gestio_falla/infrastructure/data_source/qr_datasource.dart';
import 'package:gestio_falla/infrastructure/repository/Api-Odoo_repository_impl.dart';
import 'package:gestio_falla/infrastructure/repository/mostraQR_repository_impl.dart';
import 'package:gestio_falla/infrastructure/repository/nfc_repository_impl.dart';
import 'package:gestio_falla/infrastructure/repository/notificacions_repository_impl.dart';
import 'package:gestio_falla/infrastructure/repository/qr_repository_impl.dart';
import 'package:gestio_falla/presentation/screens/splash_screen.dart';
import 'package:gestio_falla/provider/Api-OdooProvider.dart';
import 'package:gestio_falla/provider/mostraQRProvider.dart';
import 'package:gestio_falla/provider/nfcProvider.dart';
import 'package:gestio_falla/provider/notificacionsProvider.dart';
import 'package:gestio_falla/provider/qrProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  final fakeApiOdooDataSource=FakeApiOdooDataSource(baseUrl: "http://192.168.236.2:3000", db: "Projecte_Falla");
  final apiOdooRepository= ApiOdooRepositoryImpl(fakeApiOdooDataSource);
  final nfcDataSource = NfcDataSource();
  final nfcRepository = NfcRepositoryImpl(nfcDataSource);
  final qrDataSource = QrDataSource();
  final qrRepository = QrRepositoryImpl(qrDataSource);
  final mostraqrDatasource= MostraqrDatasource();
  final mostraqrRepository= MostraqrRepositoryImpl(mostraqrDatasource);
  final notificacionsDataSource= NotificacionsDatasource();
  final notificacionsRepository= NotificacionsRepositoryImpl(notificacionsDataSource);
  runApp(MyApp(
    apiOdooRepositoryImpl: apiOdooRepository, 
    nfcRepositoryImpl: nfcRepository,
    qrRepositoryImpl: qrRepository,
    mostraqrRepositoryImpl: mostraqrRepository, 
    notificacionsRepositoryImpl: notificacionsRepository, 
    isLoggedIn: isLoggedIn, 
    ));
}

class MyApp extends StatelessWidget {
  final faller = Faller(nom: "Joel", telimit: false, rol: "SuperAdmin", cobrador_id: Cobrador(rolCobrador: "Cadires"),familia_id:Familia(nom: "Familia de Joel"), valorpulsera: "8430001000017", estaloguejat: false);
  final bool isLoggedIn;
    final ApiOdooRepositoryImpl apiOdooRepositoryImpl;
  final NfcRepositoryImpl nfcRepositoryImpl;
  final QrRepositoryImpl qrRepositoryImpl;
  final MostraqrRepositoryImpl mostraqrRepositoryImpl;
  final NotificacionsRepositoryImpl notificacionsRepositoryImpl;

  MyApp({
    super.key, 
    required this.apiOdooRepositoryImpl,
    required this.nfcRepositoryImpl, 
    required this.notificacionsRepositoryImpl, 
    required this.mostraqrRepositoryImpl,
    required this.qrRepositoryImpl, 
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers:[
      ChangeNotifierProvider(create: (context) => ApiOdooProvider(apiOdooRepositoryImpl)),
      ChangeNotifierProvider(create: (context) => NfcProvider(nfcRepositoryImpl,faller,Provider.of<ApiOdooProvider>(context, listen: false))),
      ChangeNotifierProvider(create: (context) => Qrprovider(qrRepositoryImpl,faller,Provider.of<ApiOdooProvider>(context, listen: false))),
      ChangeNotifierProvider(create: (context) => Mostraqrprovider(mostraqrRepositoryImpl)),
      ChangeNotifierProvider(create: (context) => NotificacionsProvider(notificacionsRepositoryImpl)),
    ],
      child: MaterialApp(
        title: 'Falla Portal',
        debugShowCheckedModeBanner: true,
        home: const SplashScreen(),
      ),
    ); 
  }
}