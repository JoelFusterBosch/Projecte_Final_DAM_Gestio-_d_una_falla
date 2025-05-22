import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:gestio_falla/provider/mostraQRProvider.dart';

class MostraQrScreen extends StatefulWidget {
  final Faller faller;

  const MostraQrScreen({super.key, required this.faller});

  @override
  State<MostraQrScreen> createState() => _MostraQrScreenState();
}

class _MostraQrScreenState extends State<MostraQrScreen> {
  bool estaCarregat = false;
  

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!estaCarregat) {
      final provider = Provider.of<Mostraqrprovider>(context, listen: false);
      provider.generateQr(widget.faller.valorPulsera);
      estaCarregat = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: const Text("Mostra QR"),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Consumer<Mostraqrprovider>(
                      builder: (context, provider, child) {
                        if (provider.qrData == null) {
                          return const CircularProgressIndicator();
                        } else {
                          return Column(
                            children: [
                              Text(
                                "Qr del valor de la pulsera de l'usuari ${widget.faller.nom}",
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              QrImageView(
                                data: provider.qrData!,
                                size: 200.0,
                                eyeStyle: const QrEyeStyle(
                                  eyeShape: QrEyeShape.square,
                                  color: Colors.black,
                                ),
                                dataModuleStyle: const QrDataModuleStyle(
                                  dataModuleShape: QrDataModuleShape.square,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          );
                        }
                      },
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
