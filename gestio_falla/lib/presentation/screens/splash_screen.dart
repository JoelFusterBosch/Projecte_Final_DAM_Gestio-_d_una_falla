import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/presentation/screens/login_screen.dart';
import 'package:gestio_falla/presentation/screens/principal_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Esperem 1 segon abans de continuar
    Future.delayed(const Duration(seconds: 5), () {
      _comprovarSessio();
    });
  }

  void _comprovarSessio() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (isLoggedIn) {
      final jsonFaller = prefs.getString('faller');
      if (jsonFaller != null) {
        final faller = Faller.fromJSON(jsonDecode(jsonFaller));
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => PrincipalScreen(faller: faller)),
          );
          return;
        }
      }
    }

    // Si no està loguejat o no hi ha dades
    if (mounted) {
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
                    children: [
                      Image.asset(
                        'lib/assets/FallaPortal.png',
                        fit: BoxFit.fill,
                      ),
                      Text(
                        "Benvingut a l'app de la Falla Portal",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        "Un moment perfavor...",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      CircularProgressIndicator(),
                    ],
                  ), 
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
