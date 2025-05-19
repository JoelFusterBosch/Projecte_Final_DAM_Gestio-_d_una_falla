import 'package:flutter/material.dart';
import 'package:gestio_falla/provider/nfcProvider.dart';
import 'package:gestio_falla/provider/qrProvider.dart';
import 'package:provider/provider.dart';

class AfegirMembre extends StatefulWidget {
  const AfegirMembre({super.key});

  @override
  State<AfegirMembre> createState() => AfegirMembreState();
}

class AfegirMembreState extends State<AfegirMembre> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _confirmacioController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _confirmacioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Afegir membre"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Nom del membre"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _nomController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              labelText: 'Nom del membre a afegir',
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Has de posar el nom d'un membre per a poder afegir-lo!";
                              }
                              return null;
                            },
                          ),
                        ),
                        Text("Confirmar"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _confirmacioController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              labelText: "Confirmar membre",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Has de posar el nom del membre per a poder comprovar-lo!";
                              }
                              if (value != _nomController.text) {
                                return "Els noms no coincideixen!";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              verificar(context);
                            }
                          },
                          child: Text("Verificar"),
                        ),
                        SizedBox(height: 16),
                        Consumer<NfcProvider>(
                          builder: (context, provider, child) {
                            return Text(
                              provider.nfcData.isNotEmpty
                                  ? 'NFC: ${provider.nfcData}'
                                  : '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            );
                          },
                        ),
                        Consumer<Qrprovider>(
                          builder: (context, provider, child) {
                            return Text(
                              provider.qrData.isNotEmpty
                                  ? 'QR: ${provider.qrData}'
                                  : '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            );
                          },
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

  void verificar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Amb què vols verificar?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<NfcProvider>().llegirEtiqueta(context);
                },
                child: Text("Verificar amb NFC"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.read<Qrprovider>().llegirQR(context);
                },
                child: Text("Verificar amb QR"),
              ),
            ],
          ),
        );
      },
    );
  }
}