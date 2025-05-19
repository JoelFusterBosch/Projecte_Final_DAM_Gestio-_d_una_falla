import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/presentation/screens/principal_screen.dart';
import 'package:gestio_falla/provider/nfcProvider.dart';
import 'package:gestio_falla/provider/qrProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usuariController = TextEditingController();

  // Lista simulada de fallers
  final List<Faller> fallers = [
    Faller(nom: 'joel', teLimit: false, rol: 'Faller', valorPulsera: '8430001000017'),
    Faller(nom: 'maria', teLimit: false, rol: 'Faller', valorPulsera: '8430001000018'),
    // Añade más usuarios aquí
  ];

  Faller? buscarFallerPerNom(String nom) {
    try {
      return fallers.firstWhere((faller) => faller.nom.toLowerCase() == nom.toLowerCase());
    } catch (e) {
      return null;
    }
  }

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
                      ElevatedButton(
                        onPressed: () async {
                          final usuari = _usuariController.text.trim();
                          if (usuari.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Introdueix un nom d\'usuari')),
                            );
                            return;
                          }

                          final faller = buscarFallerPerNom(usuari);
                          if (faller == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Usuari no trobat')),
                            );
                            return;
                          }

                          // Mostrar diálogo para elegir NFC o QR
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext contextDialog) {
                              return AlertDialog(
                                title: const Text('Amb què vols verificar?'),
                                actions: [
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(contextDialog).pop();
                                      final nfcProvider = context.read<NfcProvider>();
                                      await nfcProvider.llegirEtiqueta(context);

                                      final valorEscanejat = nfcProvider.nfcData;
                                      if (valorEscanejat.contains(faller.valorPulsera)) {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(builder: (_) => const PrincipalScreen()),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Valor NFC incorrecte per a l\'usuari')),
                                        );
                                      }
                                    },
                                    child: const Text('NFC'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.of(contextDialog).pop();
                                      final qrProvider = context.read<Qrprovider>();
                                      await qrProvider.llegirQR(context);

                                      final valorEscanejat = qrProvider.qrData;
                                      if (valorEscanejat.contains(faller.valorPulsera)) {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(builder: (_) => const PrincipalScreen()),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Valor QR incorrecte per a l\'usuari')),
                                        );
                                      }
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
                          Navigator.pushNamed(context, '/registrarUsuari'); // O como tengas la ruta
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
}