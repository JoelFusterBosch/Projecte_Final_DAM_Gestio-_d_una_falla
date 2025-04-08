import 'package:flutter/material.dart';
import 'package:gestio_falla/screens/descompta_cadira_screen.dart';
import 'package:nfc_manager/nfc_manager.dart';

class EscanerNfc extends StatefulWidget{
  const EscanerNfc({super.key});

  @override
  State<EscanerNfc> createState() => EscanerNfcState();

}
class EscanerNfcState extends State<EscanerNfc>{
  String _nfcData = "Escaneja una etiqueta NFC";
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escaner"),
      centerTitle: true,
      backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          children: [
            Text(_nfcData),
            ElevatedButton(onPressed: _startNFC, child: Text("Escaner"))
          ],
        ),
      ),
    );
  }
  void _startNFC() async {
    bool isAvailable = await NfcManager.instance.isAvailable();
    if (!isAvailable) {
      setState(() {
        _nfcData = "NFC no disponible";
      });
      return;
    }
    setState(() {
      _nfcData = "Acosta una etiqueta NFC perfavor";
    });
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async {
    // Llegim el contingut NDEF de l'etiqueta NFC
    Ndef? ndef = Ndef.from(tag);
    if (ndef == null) {
      setState(() {
        _nfcData = "Etiqueta NFC no compatible";
      });
      return;
    }

    // Obtenim el missatge NDEF
    NdefMessage message = await ndef.read();
    String value = "";

    // Busquem el primer registre NDEF i agafem el seu contingut com a text
    for (NdefRecord record in message.records) {
      if (record.typeNameFormat == NdefTypeNameFormat.nfcWellknown) {
        if (record.payload.isNotEmpty) {
          value = String.fromCharCodes(record.payload.sublist(3)); // Extraiem el text
          break;
        }
      }
    }

    // Mostrem el valor llegit
    setState(() {
      _nfcData = "Valor llegit: $value";
    });

    // Comprovem si el valor NFC coincideix amb el que volem
    if (value == '8430001000017') {
      // Aquí pots realitzar l'acció que desitges
      setState(() {
        _nfcData = "Acció realitzada per valor NFC: $value";
      });
      Navigator.push(context, MaterialPageRoute(builder: (context)=> DescomptaCadira()));
    }

    await NfcManager.instance.stopSession();
  });
  }
  void _startN2FC() async {
  bool isAvailable = await NfcManager.instance.isAvailable();
  if (!isAvailable) {
    setState(() {
      _nfcData = "NFC no disponible";
    });
    return;
  }

  
}
}
