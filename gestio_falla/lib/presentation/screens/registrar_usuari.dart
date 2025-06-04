import 'package:flutter/material.dart';
import 'package:gestio_falla/presentation/screens/login_screen.dart';
import 'package:gestio_falla/provider/Api-OdooProvider.dart';
import 'package:gestio_falla/provider/nfcProvider.dart';
import 'package:gestio_falla/provider/qrProvider.dart';
import 'package:provider/provider.dart';

class RegistrarUsuari extends StatefulWidget {
  const RegistrarUsuari({super.key});

  @override
  State<RegistrarUsuari> createState() => RegistrarUsuariState();
}

class RegistrarUsuariState extends State<RegistrarUsuari> {
  final List<String> rols = ['Inserta un rol', 'Faller', 'Cobrador', 'Administrador'];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();
  String _rolSeleccionat = 'Inserta un rol';

  String? _valorPulseraLlegit;

  @override
  Widget build(BuildContext context) {
    final apiOdooProvider = Provider.of<ApiOdooProvider>(context);
    final nfcProvider = Provider.of<NfcProvider>(context);
    final qrProvider = Provider.of<Qrprovider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar usuari"),
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 150,
                          child: Image.asset('lib/assets/FallaPortal.png', fit: BoxFit.contain),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Nom d'usuari"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _nomController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                              labelText: "Nom d'usuari",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "El camp Nom d'usuari és obligatori";
                              }
                              return null;
                            },
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Rol"),
                        ),
                        DropdownButton<String>(
                          value: _rolSeleccionat,
                          onChanged: (String? newValue) {
                            setState(() {
                              _rolSeleccionat = newValue!;
                            });
                          },
                          items: rols.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final valor = await nfcProvider.llegirEtiquetaRetornantValor(context);
                            if (valor != null) {
                              setState(() {
                                _valorPulseraLlegit = valor;
                              });
                            }
                          },
                          icon: const Icon(Icons.nfc),
                          label: const Text("Escaneja NFC"),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: () async {
                            final valor = await qrProvider.llegirQRRetornantValor(context);
                            if (valor != null) {
                              setState(() {
                                _valorPulseraLlegit = valor;
                              });
                            }
                          },
                          icon: const Icon(Icons.qr_code),
                          label: const Text("Escaneja QR"),
                        ),
                        if (_valorPulseraLlegit != null)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Polsera llegida: $_valorPulseraLlegit", style: const TextStyle(color: Colors.green)),
                          ),

                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (_rolSeleccionat == 'Inserta un rol') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Selecciona un rol vàlid")),
                                );
                                return;
                              }
                              if (_valorPulseraLlegit == null || _valorPulseraLlegit!.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Escaneja una polsera NFC abans de registrar")),
                                );
                                return;
                              }

                              try {
                                await apiOdooProvider.postFaller(
                                  nom: _nomController.text.trim(),
                                  rol: _rolSeleccionat,
                                  valorPulsera: _valorPulseraLlegit!,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Usuari registrat correctament!")),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: ${e.toString()}")),
                                );
                              }
                            }
                          },
                          child: const Text("Registrar-se"),
                        ),

                        if (apiOdooProvider.status.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Estat: ${apiOdooProvider.status}"),
                          ),
                      ],
                    ),
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
