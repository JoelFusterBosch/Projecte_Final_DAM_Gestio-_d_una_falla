import 'package:flutter/material.dart';
import 'package:gestio_falla/infrastructure/data_source/Fake_Api-Odoo.datasource.dart';
import 'package:gestio_falla/infrastructure/repository/Api-Odoo_repository_impl.dart';
import 'package:gestio_falla/provider/Api-OdooProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gestio_falla/presentation/screens/login_screen.dart';
import 'package:gestio_falla/presentation/screens/principal_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final FakeApiOdooDataSource fakeApiOdooDataSource;
  late final ApiOdooRepositoryImpl apiOdooRepository;
  late final ApiOdooProvider apiProvider;

  @override
  void initState() {
    super.initState();
    fakeApiOdooDataSource = FakeApiOdooDataSource(baseUrl: "http://192.168.1.15:3000", db: "Projecte_Falla");
    apiOdooRepository = ApiOdooRepositoryImpl(fakeApiOdooDataSource);
    apiProvider = ApiOdooProvider(apiOdooRepository);

    // Esperem 1 segon abans de continuar
    Future.delayed(const Duration(seconds: 1), () {
      _comprovarSessio();
    });
  }

  Future<void> _comprovarSessio() async {
    final prefs = await SharedPreferences.getInstance();
    final nom = prefs.getString('nom');
    final valorPulsera = prefs.getString('valorPulsera');

    if (nom != null && valorPulsera != null) {
      try {
        final faller = await apiProvider.verificarUsuari(nom, valorPulsera);
        if (faller != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PrincipalScreen(faller: faller)),
          );
          return;
        }
      } catch (e) {
        print('Error verificació usuari: $e');
      }
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints){
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight
                ),
                child:Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 150,
                        child: Image.asset(
                          'lib/assets/FallaPortal.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const CircularProgressIndicator(),
                    ],
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
