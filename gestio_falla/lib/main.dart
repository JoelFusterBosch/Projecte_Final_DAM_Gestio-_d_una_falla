import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
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


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('estaloguejat') ?? false;

  final fakeApiOdooDataSource = FakeApiOdooDataSource(
    baseUrl: "http://192.168.236.2:3000", 
    db: "Projecte_Falla"
  );
  final apiOdooRepository = ApiOdooRepositoryImpl(fakeApiOdooDataSource);
  final nfcRepository = NfcRepositoryImpl(NfcDataSource());
  final qrRepository = QrRepositoryImpl(QrDataSource());
  final mostraqrRepository = MostraqrRepositoryImpl(MostraqrDatasource());
  final notificacionsRepository = NotificacionsRepositoryImpl(NotificacionsDatasource());

  runApp(MyApp(
    isLoggedIn: isLoggedIn,
    apiOdooRepositoryImpl: apiOdooRepository,
    nfcRepositoryImpl: nfcRepository,
    qrRepositoryImpl: qrRepository,
    mostraqrRepositoryImpl: mostraqrRepository,
    notificacionsRepositoryImpl: notificacionsRepository,
  ));
}


class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  final Faller? faller;
  final ApiOdooRepositoryImpl apiOdooRepositoryImpl;
  final NfcRepositoryImpl nfcRepositoryImpl;
  final QrRepositoryImpl qrRepositoryImpl;
  final MostraqrRepositoryImpl mostraqrRepositoryImpl;
  final NotificacionsRepositoryImpl notificacionsRepositoryImpl;

  const MyApp({
    super.key,
    this.faller,
    required this.isLoggedIn,
    required this.apiOdooRepositoryImpl,
    required this.nfcRepositoryImpl,
    required this.qrRepositoryImpl,
    required this.mostraqrRepositoryImpl,
    required this.notificacionsRepositoryImpl, 
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApiOdooProvider(apiOdooRepositoryImpl)),
        ChangeNotifierProvider(
          create: (context) => NfcProvider(nfcRepositoryImpl),
        ),
        ChangeNotifierProvider(
          create: (context) => Qrprovider(qrRepositoryImpl),
        ),
        ChangeNotifierProvider(create: (_) => Mostraqrprovider(mostraqrRepositoryImpl)),
        ChangeNotifierProvider(create: (_) => NotificacionsProvider(notificacionsRepositoryImpl)),
      ],
      child: MaterialApp(
        title: 'Falla Portal',
        home: const SplashScreen(),
      ),
    );
  }
}
