import 'dart:async';

import 'package:nfc_manager/nfc_manager.dart';

class NfcDataSource {
  NfcDataSource();
  Future<String?> llegirNFC({
    required String valorEsperat,
    void Function()? onCoincidencia,
    void Function()? onError,
  })async{
    bool isAvailable=await NfcManager.instance.isAvailable();
    if(!isAvailable){
      onError?.call();
      return "NFC no disponible en aquest dispositiu";
    }
    Completer<String?> completer= Completer();
    NfcManager.instance.startSession(onDiscovered: (NfcTag tag) async{
      try{
        final ndef= Ndef.from(tag);
        if(ndef==null){
          completer.complete("Etiqueta no compatible");
          NfcManager.instance.stopSession();
          return;
        }
        final message= await ndef.read();
        String valorLlegit="";
        for (var record in message.records){
          if(record.typeNameFormat == NdefTypeNameFormat.nfcWellknown && record.payload.isNotEmpty){
            valorLlegit=String.fromCharCodes(record.payload.sublist(3));
            break;
          }
        }
        completer.complete(valorEsperat);
        NfcManager.instance.stopSession();
        if (valorLlegit==valorEsperat){
          onCoincidencia?.call();
        }
      }catch(e){
        completer.complete("Error a l'hora de llegir el NFC");
        onError?.call();
        NfcManager.instance.stopSession(errorMessage: "Error");
      }
    });
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
