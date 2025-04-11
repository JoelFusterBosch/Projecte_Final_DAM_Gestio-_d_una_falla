import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/event.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/domain/repository/nfc_repository.dart';
import 'package:gestio_falla/infrastructure/data_source/nfc_datasource.dart';
import 'package:gestio_falla/infrastructure/repository/nfc_repository_impl.dart';
import 'package:gestio_falla/presentation/screens/descompta_cadira_screen.dart';

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
  late final NfcRepository nfcRepository;
  
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
    nfcRepository = NfcRepositoryImpl(NfcDataSource());
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
    setState(() {
      _nfcData = "Acosta una etiqueta NFC perfavor";
    });

    final resultat = await nfcRepository.llegirNfc(
      valorEsperat: '8430001000017',
      onCoincidencia: () {
        setState(() {
          _nfcData = "Acció realitzada per valor NFC: 8430001000017";
        });

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DescomptaCadira()),
        );
      },
      onError: () {
        setState(() {
          _nfcData = "Error en llegir etiqueta NFC";
        });
      },
    );

    // Mostra resultat llegit si no coincideix
    if (resultat != null && resultat != '8430001000017') {
      setState(() {
        _nfcData = "Valor llegit: $resultat no coincideix";
      });
    }
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