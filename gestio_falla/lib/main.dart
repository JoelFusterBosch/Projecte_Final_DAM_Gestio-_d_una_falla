import 'package:flutter/material.dart';
import 'package:gestio_falla/infrastructure/data_source/Api-Odoo_datasource.dart';
import 'package:gestio_falla/infrastructure/data_source/nfc_datasource.dart';
import 'package:gestio_falla/infrastructure/data_source/notificacions_datasource.dart';
import 'package:gestio_falla/infrastructure/repository/Api-Odoo_repository_impl.dart';
import 'package:gestio_falla/infrastructure/repository/nfc_repository_impl.dart';
import 'package:gestio_falla/infrastructure/repository/notificacions_repository_impl.dart';
import 'package:gestio_falla/provider/Api-OdooProvider.dart';
import 'package:gestio_falla/provider/nfcProvider.dart';
import 'package:gestio_falla/provider/notificacionsProvider.dart';
import 'package:provider/provider.dart';
import 'package:gestio_falla/presentation/screens/principal_screen.dart';


void main(){
  final nfcDataSource = NfcDataSource();
  final nfcRepository = NfcRepositoryImpl(nfcDataSource);
  final notificacionsDataSource= NotificacionsDatasource();
  final notificacionsRepository= NotificacionsRepositoryImpl(notificacionsDataSource);
  final apiOdooDataSource=ApiOdooDataSource(baseUrl: "http://192.168.125.26:8069", db: "Projecte_Falla");
  final apiOdooRepository= ApiOdooRepositoryImpl(apiOdooDataSource);
  runApp(MyApp(
    nfcRepositoryImpl: nfcRepository,
    notificacionsRepositoryImpl: notificacionsRepository, 
    apiOdooRepositoryImpl: apiOdooRepository,
    ));
}

class MyApp extends StatelessWidget {
  final NfcRepositoryImpl nfcRepositoryImpl;
  final NotificacionsRepositoryImpl notificacionsRepositoryImpl;
  final ApiOdooRepositoryImpl apiOdooRepositoryImpl;
  const MyApp({super.key, required this.nfcRepositoryImpl, required this.notificacionsRepositoryImpl, required this.apiOdooRepositoryImpl});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers:[
      ChangeNotifierProvider(create: (context) => NfcProvider(nfcRepositoryImpl)),
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