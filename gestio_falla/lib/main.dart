import 'package:flutter/material.dart';
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
import 'package:gestio_falla/provider/Api-OdooProvider.dart';
import 'package:gestio_falla/provider/mostraQRProvider.dart';
import 'package:gestio_falla/provider/nfcProvider.dart';
import 'package:gestio_falla/provider/notificacionsProvider.dart';
import 'package:gestio_falla/provider/qrProvider.dart';
import 'package:provider/provider.dart';
import 'package:gestio_falla/presentation/screens/principal_screen.dart';


void main(){
  final nfcDataSource = NfcDataSource();
  final nfcRepository = NfcRepositoryImpl(nfcDataSource);
  final qrDataSource = QrDataSource();
  final qrRepository = QrRepositoryImpl(qrDataSource);
  final mostraqrDatasource= MostraqrDatasource();
  final mostraqrRepository= MostraqrRepositoryImpl(mostraqrDatasource);
  final notificacionsDataSource= NotificacionsDatasource();
  final notificacionsRepository= NotificacionsRepositoryImpl(notificacionsDataSource);
  final fakeApiOdooDataSource=FakeApiOdooDataSource(baseUrl: "http://10.0.2.15:3000", db: "Projecte_Falla");
  final apiOdooRepository= ApiOdooRepositoryImpl(fakeApiOdooDataSource);
  runApp(MyApp(
    nfcRepositoryImpl: nfcRepository,
    qrRepositoryImpl: qrRepository,
    mostraqrRepositoryImpl: mostraqrRepository, 
    notificacionsRepositoryImpl: notificacionsRepository, 
    apiOdooRepositoryImpl: apiOdooRepository, 
    ));
}

class MyApp extends StatelessWidget {
  final NfcRepositoryImpl nfcRepositoryImpl;
  final QrRepositoryImpl qrRepositoryImpl;
  final MostraqrRepositoryImpl mostraqrRepositoryImpl;
  final NotificacionsRepositoryImpl notificacionsRepositoryImpl;
  final ApiOdooRepositoryImpl apiOdooRepositoryImpl;
  const MyApp({
    super.key, 
    required this.nfcRepositoryImpl, 
    required this.notificacionsRepositoryImpl, 
    required this.mostraqrRepositoryImpl,
    required this.apiOdooRepositoryImpl, 
    required this.qrRepositoryImpl, 
    
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers:[
      ChangeNotifierProvider(create: (context) => NfcProvider(nfcRepositoryImpl)),
      ChangeNotifierProvider(create: (context) => Qrprovider(qrRepositoryImpl)),
      ChangeNotifierProvider(create: (context) => Mostraqrprovider(mostraqrRepositoryImpl)),
      ChangeNotifierProvider(create: (context) => NotificacionsProvider(notificacionsRepositoryImpl)),
      ChangeNotifierProvider(create: (context) => ApiOdooProvider(apiOdooRepositoryImpl))
    ],
      child: MaterialApp(
        title: 'Falla Portal',
        debugShowCheckedModeBanner: true,
        home: PrincipalScreen(),
      ),
    ); 
  }
}