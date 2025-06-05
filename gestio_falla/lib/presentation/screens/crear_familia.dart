import 'package:flutter/material.dart';
import 'package:gestio_falla/provider/Api-OdooProvider.dart';
import 'package:gestio_falla/provider/nfcProvider.dart';
import 'package:gestio_falla/provider/qrProvider.dart';
import 'package:provider/provider.dart';

class CrearFamilia extends StatefulWidget{
  const CrearFamilia({super.key});

  @override
  State<CrearFamilia> createState() => CrearFamiliaState();
}

class CrearFamiliaState extends State<CrearFamilia> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomFamiliaController = TextEditingController();
  final TextEditingController _confirmarNomController = TextEditingController();

  String? idFamiliaCreada;

  @override
  Widget build(BuildContext context) {
    final apiOdooProvider = Provider.of<ApiOdooProvider>(context);
    final nfcProvider = Provider.of<NfcProvider>(context);
    final qrProvider = Provider.of<Qrprovider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Crear família"),
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
                        Text("Nom de la família"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _nomFamiliaController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                              labelText: 'Nom de la família',
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? "Posa un nom per a la família" : null,
                          ),
                        ),
                        Text("Confirmar nom"),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _confirmarNomController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                              labelText: 'Confirmar nom',
                            ),
                            validator: (value) =>
                                value == null || value.isEmpty ? "Confirma el nom" : null,
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_nomFamiliaController.text.trim() !=
                                  _confirmarNomController.text.trim()) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Els noms no coincideixen")),
                                );
                                return;
                              }
                              _crearFamilia(context);
                            }
                          },
                          child: Text("Crear família"),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () => _mostrarOpcionsVerificacio(context),
                          child: Text("Verificar i assignar"),
                        ),
                        SizedBox(height: 16),
                        if (nfcProvider.nfcData.isNotEmpty)
                          Text('NFC: ${nfcProvider.nfcData}'),
                        if (qrProvider.qrData.isNotEmpty)
                          Text('QR: ${qrProvider.qrData}'),
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

  Future<void> _crearFamilia(BuildContext context) async {
    final nom = _nomFamiliaController.text.trim();
    final apiOdooProvider = Provider.of<ApiOdooProvider>(context, listen: false);

    try {
      await apiOdooProvider.postFamilies(nom);
      // opcional: refrescar families si cal
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Família creada correctament!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  void _mostrarOpcionsVerificacio(BuildContext context) {
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
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _assignarFamilia(context);
                },
                child: Text("Assignar família"),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _assignarFamilia(BuildContext context) async {
    final nfcProvider = context.read<NfcProvider>();
    final qrProvider = context.read<Qrprovider>();
    final apiOdooProvider = context.read<ApiOdooProvider>();

    final pulseraFaller = nfcProvider.nfcData.isNotEmpty
        ? nfcProvider.nfcData
        : qrProvider.qrData;

    if (pulseraFaller.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Verifica un faller primer")),
      );
      return;
    }

    try {
      // Aquest mètode assumix que la família creada és l’última en el backend
      final familiaCreada = apiOdooProvider.families.last;
      final idFamilia = familiaCreada['id'].toString();

      await apiOdooProvider.assignarFamilia(valorPulsera: pulseraFaller, idFamilia: idFamilia);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Família assignada correctament al faller!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error a l’assignar família: ${e.toString()}")),
      );
    }
  }
}
 