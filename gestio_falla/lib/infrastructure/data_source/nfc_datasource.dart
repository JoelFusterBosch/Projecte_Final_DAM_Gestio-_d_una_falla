import 'dart:async';

import 'package:nfc_manager/nfc_manager.dart';

class NfcDataSource {
  NfcDataSource();
  Future<String?> llegirNFC({
    required String valorEsperat,
    void Function()? onCoincidencia,
    void Function()? onError,
  }) async {
    String? valorLlegit;

    Completer<String?> completer = Completer();

    await NfcManager.instance.startSession(
      onDiscovered: (NfcTag tag) async {
        try {
          final ndef = Ndef.from(tag);
          if (ndef == null || ndef.cachedMessage == null) {
            await NfcManager.instance.stopSession(errorMessage: 'Etiqueta no compatible');
            onError?.call();
            completer.complete(null);
            return;
          }

          final payload = ndef.cachedMessage!.records.first.payload;
          valorLlegit = String.fromCharCodes(payload.skip(3));

          if (valorLlegit == valorEsperat) {
            onCoincidencia?.call();
          } else {
            onError?.call();
          }

          await NfcManager.instance.stopSession();
          completer.complete(valorLlegit);
        } catch (e) {
          await NfcManager.instance.stopSession(errorMessage: 'Error en la lectura');
          onError?.call();
          completer.complete(null);
        }
      },
    );

    return completer.future;
  }
  
  Future<String> escriureNFC(String valorAEscriure) async {
    bool isAvailable= await NfcManager.instance.isAvailable();
    if(!isAvailable){
      return "NFC no disponible en aquest dispositiu";
    }
    String resultat="Esperant etiqueta ...";
    await NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async{
      try{
        final ndef= Ndef.from(tag);
        if(ndef==null || !ndef.isWritable){
          resultat="Etiqueta no compatible o no es pot escriure";
          NfcManager.instance.stopSession(errorMessage: "Error");
          return;
        }
        final message= NdefMessage([
          NdefRecord.createText(valorAEscriure)
        ]);
        await ndef.write(message);
        resultat="Etiqueta escrita amb èxit";
        return;
      }catch(e){
        resultat="Error en escriure l'etiqueta";
        return;
      }
    });
    return resultat;
  }
}
