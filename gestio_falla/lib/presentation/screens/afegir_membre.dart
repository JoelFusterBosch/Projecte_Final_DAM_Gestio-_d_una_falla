import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/provider/Api-OdooProvider.dart';
import 'package:gestio_falla/provider/nfcProvider.dart';
import 'package:gestio_falla/provider/qrProvider.dart';
import 'package:provider/provider.dart';

class AfegirMembre extends StatefulWidget {
  final Faller? faller;
  const AfegirMembre({super.key, required this.faller});

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
    final apiProvider = Provider.of<ApiOdooProvider>(context, listen: false);
    final nfcProvider = Provider.of<NfcProvider>(context, listen: false);
    final qrProvider = Provider.of<Qrprovider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Amb què vols verificar?"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  // Llegir NFC i obtenir valor polsera
                  try {
                    final valorPolsera = await nfcProvider.llegirEtiquetaRetornantValor(context);
                    if (valorPolsera == null || valorPolsera.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("No s'ha llegit cap valor NFC.")),
                      );
                      return;
                    }

                    // Consultar l'API per obtenir faller per valor polsera
                    final fallerNou = await apiProvider.getMembrePerValorPolsera(valorPolsera);
                    if (fallerNou == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Faller no trobat per la polsera NFC!")),
                      );
                      return;
                    }

                    // Assignar família si cal
                    final familiaPerfil = widget.faller!.familia_id?.id;
                    if (familiaPerfil == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("El faller perfil no té família assignada!")),
                      );
                      return;
                    }

                    if (fallerNou.familia_id == null || fallerNou.familia_id!.id == null) {
                      await apiProvider.assignarFamilia(
                        id: fallerNou.id.toString(),
                        idFamilia: familiaPerfil.toString(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Família assignada correctament al nou faller!")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("El faller ja té família assignada.")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: ${e.toString()}")),
                    );
                  }
                },
                child: Text("Verificar amb NFC"),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.pop(context);
                  // Llegir QR i obtenir valor polsera
                  try {
                    final valorPolsera = await qrProvider.llegirQRRetornantValor(context);
                    if (valorPolsera == null || valorPolsera.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("No s'ha llegit cap valor QR.")),
                      );
                      return;
                    }

                    // Consultar l'API per obtenir faller per valor polsera
                    final fallerNou = await apiProvider.getMembrePerValorPolsera(valorPolsera);
                    if (fallerNou == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Faller no trobat per la polsera QR!")),
                      );
                      return;
                    }

                    // Assignar família si cal
                    final familiaPerfil = widget.faller!.familia_id?.id;
                    if (familiaPerfil == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("El faller perfil no té família assignada!")),
                      );
                      return;
                    }

                    if (fallerNou.familia_id == null || fallerNou.familia_id!.id == null) {
                      await apiProvider.assignarFamilia(
                        id: fallerNou.id.toString(),
                        idFamilia: familiaPerfil.toString(),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Família assignada correctament al nou faller!")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("El faller ja té família assignada.")),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error: ${e.toString()}")),
                    );
                  }
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