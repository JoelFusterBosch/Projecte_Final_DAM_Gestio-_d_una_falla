import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/event.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/domain/repository/qr_repository.dart';
import 'package:gestio_falla/infrastructure/data_source/qr_datasource.dart';
import 'package:gestio_falla/infrastructure/repository/qr_repository_impl.dart';
import 'package:gestio_falla/presentation/screens/descompta_cadira_screen.dart';
import 'package:gestio_falla/provider/nfcProvider.dart';
import 'package:provider/provider.dart';

class Escaner extends StatefulWidget{
  const Escaner({super.key});

  @override
  State<Escaner> createState() => EscanerState();

}
class EscanerState extends State<Escaner>{
  String? qrData;
  List pantalles=[];
  late Event event;
  late Faller faller;
  late int dia;
  late String mes;
  late int any;
  late String horaInici;
  late String horaFi;
  late int indexPantallaActual;
  late bool esFaller;
  late int cadiresPerAlFaller;
  late bool eventCorrecte;
  late final QrRepository qrRepository;
  
  @override
  void initState(){
    super.initState();
    faller=Faller(nom: "Joel", rol:"Faller");
    event=Event(nom: "Paella");
    dia=16;
    mes="de març";
    any=2025;
    horaInici="12:30";
    horaFi="15:30";
    indexPantallaActual=0;
    esFaller=true;
    cadiresPerAlFaller=1;
    eventCorrecte=false;
    qrRepository = QrRepositoryImpl(QrDataSource());
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
              Consumer<NfcProvider>(
                builder: (context, provider, child) {
                  return Text(eventCorrecte ? provider.nfcData : "");
                },
              ),
              ElevatedButton(onPressed:eventCorrecte? () => {context.read<NfcProvider>().llegirEtiqueta(context)}:null, 
              child: Text("Escàner NFC")
              ),
              ElevatedButton(onPressed: eventCorrecte? () => {qrRepository.llegirQR(
                context: context,
                valorEsperat: '8430001000017',
                onCoincidencia: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const DescomptaCadira()),
                  );
                },
                onDiferent: (valor) {
                  setState(() {
                    qrData = valor;
                  });
                },
                onError: () {
                  qrData = "Error al llegir el codi QR";
                },
              )}:null,
              child: Text("Escàner QR")
              ),
              if (qrData != null) 
                Text(
                  'QR detectat: $qrData',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                )
              else
                Text(
                  "No s'ha escanejat cap QR",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
            ]
          )
        ) 
      )
    );
  }
  void event1() {
    setState(() {
      if (event.nom == "Paella" && dia == 16 && mes == "de març" && any == 2025 && horaInici == "12:30" && horaFi == "15:30") {
        if (esFaller) {
          if (faller.nom == "Joel") {
            if (cadiresPerAlFaller >= 1) {
              eventCorrecte=true;
              pantalles = [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(event.nom),
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
                        "L'usuari ${faller.nom} no té cadires assignades!",
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
                      "L'usuari ${faller.nom} no és correcte",
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
                    "L'usuari ${faller.nom} no és un faller",
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