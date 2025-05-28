import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/provider/Api-OdooProvider.dart';
import 'package:gestio_falla/provider/nfcProvider.dart';
import 'package:gestio_falla/provider/qrProvider.dart';
import 'package:provider/provider.dart';

class EditarUsuari extends StatefulWidget {
  final Faller faller;
  const EditarUsuari({super.key, required this.faller});

  @override
  State<EditarUsuari> createState() => EditarUsuariState();
}

class EditarUsuariState extends State<EditarUsuari> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomAnticController = TextEditingController();
  final TextEditingController _nomNouController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar usuari"),
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
                        const Text("Nom de faller antic"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _nomAnticController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                              labelText: 'Nom de faller antic',
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? "Introdueix el nom antic" : null,
                          ),
                        ),
                        const Text("Nom nou del faller"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _nomNouController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                              labelText: 'Nom nou del faller',
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? "Introdueix el nou nom" : null,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              verificar(context);
                            }
                          },
                          child: Text("Verificar"),
                        ),
                        const SizedBox(height: 16),
                        Consumer<NfcProvider>(
                          builder: (context, provider, child) {
                            return Text(
                              provider.nfcData.isNotEmpty ? 'NFC: ${provider.nfcData}' : '',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            );
                          },
                        ),
                        Consumer<Qrprovider>(
                          builder: (context, provider, child) {
                            return Text(
                              provider.qrData.isNotEmpty ? 'QR: ${provider.qrData}' : '',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
    final nomAntic = _nomAnticController.text.trim();
    final nomNou = _nomNouController.text.trim();
    final apiOdooProvider = Provider.of<ApiOdooProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Amb què vols verificar?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                final id = await apiOdooProvider.getFallerValorPulseraByName(nomAntic);
                if (id != null) {
                  await apiOdooProvider.canviaNom(id: id, nouNom: nomNou);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Nom canviat correctament")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("No s'ha trobat el faller amb nom $nomAntic")),
                  );
                }
              },
              child: Text("Verificar amb NFC"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                final id = await apiOdooProvider.getFallerValorPulseraByName(nomAntic);
                if (id != null) {
                  await apiOdooProvider.canviaNom(id: id, nouNom: nomNou);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Nom canviat correctament")),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("No s'ha trobat el faller amb nom $nomAntic")),
                  );
                }
              },
              child: Text("Verificar amb QR"),
            ),
          ],
        ),
      ),
    );
  }
}

