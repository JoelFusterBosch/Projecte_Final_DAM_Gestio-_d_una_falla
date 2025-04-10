import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/event.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/presentation/screens/descompta_cadira_screen.dart';
import 'package:nfc_manager/nfc_manager.dart';

class EscanerNfc extends StatefulWidget{
  const EscanerNfc({super.key});
  

  @override
  State<EscanerNfc> createState() => EscanerNfcState();

}
class EscanerNfcState extends State<EscanerNfc>{
  late String _nfcData;
  List pantalles=[];
  late Event event;
  late Faller faller;
  late int dia;
  late String mes;
  late int any;
  late String horaInici;
  late String horaFi;
  late int indexPantallaActual;
  late String nomEvent;
  late bool esFaller;
  late int cadiresPerAlFaller;
  late String nomFaller;
  late bool eventCorrecte;
  @override
  void initState(){
    super.initState();
    _nfcData="Escaneja una etiqueta NFC";
    faller=Faller(nom: "Joel");
    event=Event(nom: "Paella");
    dia=16;
    mes="de març";
    any=2025;
    horaInici="12:30";
    horaFi="15:30";
    indexPantallaActual=0;
    nomEvent= event.nom;
    esFaller=true;
    cadiresPerAlFaller=1;
    nomFaller=faller.nom;
    eventCorrecte=false;
    event1();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escaner"),
      centerTitle: true,
      backgroundColor: Colors.orange,
      ),
      body: Center(child: Padding(
          padding: EdgeInsets.all(20.0),
          child:Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              pantalles[indexPantallaActual],
              Text(eventCorrecte? _nfcData:""),
              ElevatedButton(onPressed:eventCorrecte? _startNFC:null, child: Text("Escaner")),
            ]
          )
        ) 
      )
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
      setState(() {
        _nfcData = "Acció realitzada per valor NFC: $value";
      });
      Navigator.push(context, MaterialPageRoute(builder: (context)=> DescomptaCadira()));
    }
    await NfcManager.instance.stopSession();
  });
  }
  void event1() {
    setState(() {
      if (nomEvent == "Paella" && dia == 16 && mes == "de març" && any == 2025 && horaInici == "12:30" && horaFi == "15:30") {
        if (esFaller) {
          if (nomFaller == "Joel") {
            if (cadiresPerAlFaller >= 1) {
              eventCorrecte=true;
              pantalles = [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(nomEvent),
                      Text("Data: $dia $mes $any"),
                      Text("Durada: $horaInici-$horaFi"),
                    ],
                  ),
                )
              ];
            } else {
              pantalles = [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "L'usuari $nomFaller no té cadires assignades!",
                        style: TextStyle(color: Colors.red),
                      ),
                      Text("Cadires assignades: $cadiresPerAlFaller")
                    ],
                  ),
                )
              ];
            }
          } else {
            pantalles = [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "L'usuari $nomFaller no és correcte",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              )
            ];
          }
        } else {
          pantalles = [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "L'usuari $nomFaller no és un faller",
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
            )
          ];
        }
      } else {
        pantalles = [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hui no n'hi han events per a demanar cadires",
                  style: TextStyle(color: Colors.red),
                ),
              ],
            ),
          )
        ];
      }
    });
  }
}