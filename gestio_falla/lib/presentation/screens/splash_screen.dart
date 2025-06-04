import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/presentation/screens/login_screen.dart';
import 'package:gestio_falla/presentation/screens/principal_screen.dart';
import 'package:gestio_falla/provider/Api-OdooProvider.dart';
import 'package:gestio_falla/provider/nfcProvider.dart';
import 'package:gestio_falla/provider/qrProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
    void initState() {
      super.initState();
      Future.delayed(Duration(seconds: 2), () {
        comprovarSessioAmbProvider();
      });
  }

  Future<void> comprovarSessioAmbProvider() async {
    final prefs = await SharedPreferences.getInstance();
    final estaloguejat = prefs.getBool('estaloguejat') ?? false;

    if (estaloguejat) {
      final fallerJson = prefs.getString('faller');
      try {
        final faller = Faller.fromJSON(jsonDecode(fallerJson!));
        // Actualitzar providers
        final nfcProvider = context.read<NfcProvider>();
        final qrProvider = context.read<Qrprovider>();
        final apiProvider = context.read<ApiOdooProvider>();

        nfcProvider.setFaller(faller);
        qrProvider.setFaller(faller);
        apiProvider.setFaller(faller);
        // Navegar a PrincipalScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => PrincipalScreen(faller: faller)),
        );
        return;
      } catch (e) {
         // Si no està loguejat, o no hi ha faller, va a LoginScreen
        Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }else{
      Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Image(image: AssetImage('lib/assets/FallaPortal.png')),
                      SizedBox(height: 20),
                      Text("Benvingut a l'app de la Falla Portal", style: TextStyle(fontSize: 20)),
                      SizedBox(height: 10),
                      Text("Un moment, per favor...", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 20),
                      CircularProgressIndicator(),
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
