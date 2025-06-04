import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gestio_falla/presentation/screens/registrar_usuari.dart';
import 'package:provider/provider.dart';
import 'package:gestio_falla/presentation/screens/principal_screen.dart';
import 'package:gestio_falla/provider/nfcProvider.dart';
import 'package:gestio_falla/provider/qrProvider.dart';
import 'package:gestio_falla/provider/Api-OdooProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usuariController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Iniciar sessió"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 150,
                        child: Image.asset(
                          'lib/assets/FallaPortal.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text("Iniciar sessió"),
                      const SizedBox(height: 8),
                      const Text("Nom d'usuari"),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                        child: TextFormField(
                          controller: _usuariController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                            labelText: "Nom d'usuari",
                          ),
                        ),
                      ),
                      _isLoading
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                final usuari = _usuariController.text.trim();
                                if (usuari.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Introdueix un nom d\'usuari')),
                                  );
                                  return;
                                }
                                // Diàleg per a triar mètode de verificació
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (contextDialog) {
                                    return AlertDialog(
                                      title: const Text('Amb què vols verificar?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.of(contextDialog).pop();
                                            await _verificarUsuari(context, usuari, via: 'nfc');
                                          },
                                          child: const Text('NFC'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            Navigator.of(contextDialog).pop();
                                            await _verificarUsuari(context, usuari, via: 'qr');
                                          },
                                          child: const Text('QR'),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text("Iniciar sessió"),
                            ),
                      const SizedBox(height: 16),
                      const Text("No tens un compte?"),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => RegistrarUsuari()),
                          );
                        },
                        child: const Text(
                          "Registrat ara",
                          style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
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

  Future<void> _verificarUsuari(BuildContext context, String usuari, {required String via}) async {
    setState(() => _isLoading = true);

    String? valorEscanejat;

    if (via == 'nfc') {
      final nfcProvider = context.read<NfcProvider>();
      valorEscanejat = valorEscanejat = await nfcProvider.llegirEtiquetaRetornantValor(context);
    } else {
      final qrProvider = context.read<Qrprovider>();
      valorEscanejat = valorEscanejat = await qrProvider.llegirQRRetornantValor(context);

    }

    final apiProvider = context.read<ApiOdooProvider>();
    final faller = await apiProvider.verificarUsuari(usuari, valorEscanejat!);

    setState(() => _isLoading = false);

    if (faller != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('estaloguejat', true);
      await prefs.setString('faller', jsonEncode(faller.toJSON()));

      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => PrincipalScreen(faller: faller)),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(apiProvider.error ?? 'Error de verificació')),
      );
    }
  }
}
