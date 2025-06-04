import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/event.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/provider/Api-OdooProvider.dart';
import 'package:gestio_falla/provider/nfcProvider.dart';
import 'package:gestio_falla/provider/qrProvider.dart';
import 'package:provider/provider.dart';

class Escaner extends StatefulWidget {
  const Escaner({super.key});

  @override
  State<Escaner> createState() => EscanerState();
}

class EscanerState extends State<Escaner> {
  Event? event; 
  late Faller faller;
  late int cadiresPerAlFaller;
  late bool eventCorrecte;
  bool carregat = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!carregat) {
      final apiProvider = Provider.of<ApiOdooProvider>(context);
      //apiProvider.getEvent(); 
      if (apiProvider.event != null) {
        setState(() {
          event = apiProvider.event;
          print(event);
          cadiresPerAlFaller = 1;
          eventCorrecte = true;
          carregat = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!carregat) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (event == null) {
      return const Scaffold(
        body: Center(child: Text("No s'ha pogut carregar cap event.")),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(event!.nom, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        const Text("Durada:"),
                        Text("${event!.dataIniciFormatejada} - ${event!.dataFiFormatejada}"),
                        const SizedBox(height: 30),

                        Consumer<NfcProvider>(
                          builder: (context, provider, child) {
                            return Text(
                              eventCorrecte ? provider.nfcData : "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
                              maxLines: 1,
                            );
                          },
                        ),

                        ElevatedButton.icon(
                          onPressed: eventCorrecte
                              ? () => context.read<NfcProvider>().llegirEtiqueta(context)
                              : null,
                          icon: const Icon(Icons.nfc),
                          label: const Text("Escàner NFC"),
                        ),

                        ElevatedButton.icon(
                          onPressed: eventCorrecte
                              ? () => context.read<Qrprovider>().llegirQR(context)
                              : null,
                          icon: const Icon(Icons.qr_code),
                          label: const Text("Escàner QR"),
                        ),

                        Consumer<Qrprovider>(
                          builder: (context, provider, child) {
                            return Text(
                              eventCorrecte ? provider.qrData : "",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  overflow: TextOverflow.ellipsis),
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

}
