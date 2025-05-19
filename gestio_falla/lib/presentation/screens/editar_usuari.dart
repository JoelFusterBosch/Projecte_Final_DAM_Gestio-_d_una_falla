import 'package:flutter/material.dart';
import 'package:gestio_falla/provider/nfcProvider.dart';
import 'package:gestio_falla/provider/qrProvider.dart';
import 'package:provider/provider.dart';

class EditarUsuari extends StatefulWidget{
  const EditarUsuari({super.key});

  @override
  State<EditarUsuari> createState() => EditarUsuariState();
}
class EditarUsuariState extends State<EditarUsuari>{
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Nom de faller antic"),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'Nom de faller antic'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Has de posar el nom antic per a poder cambiar-lo!";
                          }
                          return null;
                        },
                      ),
                      Text("Nom nou del faller"),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'Nom nou del faller'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Has de posar el nou nom per a poder cambiar-lo!";
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
