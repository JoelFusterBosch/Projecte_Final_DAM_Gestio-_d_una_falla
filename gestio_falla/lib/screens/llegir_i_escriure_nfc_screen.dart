import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

class LlegirIEscriureNfcScreen extends StatefulWidget{
  const LlegirIEscriureNfcScreen({super.key});

  @override
  State<LlegirIEscriureNfcScreen> createState() => LlegirIEscriureNfcScreenState();
}
class LlegirIEscriureNfcScreenState extends State<LlegirIEscriureNfcScreen> {
  String _nfcData = "Escaneja una etiqueta NFC";
  String codiNFC="8430001000017";

  void _startNFC() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      setState(() {
        _nfcData = "NFC no disponible";
      });
      return;
    }
    setState(() {
      _nfcData = "Acosta una etiqueta perfavor";
    });
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      setState(() {
        _nfcData = tag.data.toString();
      });
      await NfcManager.instance.stopSession();
    });
  }

  void _writeNFC() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      setState(() {
        _nfcData = "NFC no disponible";
      });
      return;
    }
    setState(() {
      _nfcData = "Acosta una etiqueta perfavor";
    });
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
      var ndef = Ndef.from(tag);
      if (ndef == null || !ndef.isWritable) {
        setState(() {
          _nfcData = "Etiqueta no compatible";
        });
        NfcManager.instance.stopSession();
        return;
      }

      NdefMessage message = NdefMessage([
        NdefRecord.createText(codiNFC),
      ]);

      try {
        await ndef.write(message);
        setState(() {
          _nfcData = "Etiqueta escrita correctament";
        });
        NfcManager.instance.stopSession();
      } catch (e) {
        setState(() {
          _nfcData = "Error en escriure";
        });
        NfcManager.instance.stopSession(errorMessage: "Error en escriure dades");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Llegir i escriure NFC"),
        centerTitle: true,
        backgroundColor: Colors.orange
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_nfcData),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startNFC,
              child: Text("Escanejar NFC"),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              onPressed: _writeNFC,
               child: Text("Escriure NFC"),
            )
          ],
        ),
      ),
    );
  }
}