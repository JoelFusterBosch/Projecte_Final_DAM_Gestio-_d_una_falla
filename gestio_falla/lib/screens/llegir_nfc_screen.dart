import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class LlegirNFCScreen extends StatefulWidget{
  const LlegirNFCScreen({super.key});

  @override
  LlegirNFCScreenState createState() => LlegirNFCScreenState();
}
class LlegirNFCScreenState extends State<LlegirNFCScreen> {
  String _nfcData = "Escanea una etiqueta NFC";

  void _startNFC() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      setState(() {
        _nfcData = "NFC no disponible";
      });
      return;
    }

    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      setState(() {
        _nfcData = tag.data.toString();
      });
      await NfcManager.instance.stopSession();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Lector NFC")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_nfcData),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startNFC,
              child: Text("Escanear NFC"),
            ),
          ],
        ),
      ),
    );
  }
}