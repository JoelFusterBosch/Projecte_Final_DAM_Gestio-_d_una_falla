import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MostraQrScreen extends StatefulWidget {
  const MostraQrScreen({super.key});

  @override
  State<MostraQrScreen> createState() => MostraQRScreenState();
}

class MostraQRScreenState extends State<MostraQrScreen> {
  Faller faller= Faller(nom: "Joel", teLimit: false, rol: "Faller", valorPulsera: "8430001000017");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text("Mostra QR"),
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
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        Text(
                          "Qr del valor de la pulsera de l'usuari ${faller.nom}",
                          style: TextStyle(fontSize: 16, color: Colors.grey,fontWeight: FontWeight.bold),
                        ),
                        QrImageView(
                          data: faller.valorPulsera,
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
