import 'package:flutter/material.dart';
import 'package:gestio_falla/provider/nfcProvider.dart';
import 'package:gestio_falla/provider/qrProvider.dart';
import 'package:provider/provider.dart';

class CrearFamilia extends StatefulWidget{
  const CrearFamilia({super.key});

  @override
  State<CrearFamilia> createState() => CrearFamiliaState();
}
class CrearFamiliaState extends State<CrearFamilia>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear familia"),
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Nom de la familia"),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'Nom de la familia'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Has de posar el nom de la familia per a crear-la!";
                          }
                          return null;
                        },
                      ),
                      Text("Confirmar nom"),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'Confirmar nom'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Has de posar confirmar el nom per a poder crear-lo!";
                          }
                          return null;
                        },
                      ),
                      ElevatedButton(
                        onPressed: () {
                          verificar(context);
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