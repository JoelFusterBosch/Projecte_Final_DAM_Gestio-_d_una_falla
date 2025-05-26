import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/cobrador.dart';
import 'package:gestio_falla/domain/entities/event.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/provider/nfcProvider.dart';
import 'package:gestio_falla/provider/qrProvider.dart';
import 'package:provider/provider.dart';

class Escaner extends StatefulWidget{
  const Escaner({super.key});

  @override
  State<Escaner> createState() => EscanerState();

}
class EscanerState extends State<Escaner>{
  List pantalles=[];
  late Event event;
  late Faller faller;
  late int indexPantallaActual;
  late bool esFaller;
  late int cadiresPerAlFaller;
  late bool eventCorrecte;
  
  @override
  void initState(){
    super.initState();
    faller=Faller(nom: "Joel", rol:"Cobrador", cobrador: Cobrador(rolCobrador: "Cadires"),valorPulsera: "8430001000017", teLimit: false, estaLoguejat: true);
    event=Event(nom: "Paella", dataInici:DateTime(2025,3,16,14,0), dataFi:DateTime(2025,3,16,17,0),numCadires: 10, prodEspecific: false);
    indexPantallaActual=0;
    esFaller=true;
    cadiresPerAlFaller=1;
    eventCorrecte=false;
    event1();
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints){
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child:Column(
                      mainAxisAlignment:MainAxisAlignment.center,
                      children: [
                        pantalles[indexPantallaActual],
                        Consumer<NfcProvider>(
                          builder: (context, provider, child) {
                            return Text(eventCorrecte ? provider.nfcData : "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold, 
                                overflow: TextOverflow.ellipsis, 
                              ),
                              maxLines: 1,
                            );
                          },
                        ),
                        ElevatedButton.icon(onPressed:eventCorrecte? () => {context.read<NfcProvider>().llegirEtiqueta(context)}:null, 
                        icon: Icon(Icons.nfc),
                        label: Text("Escàner NFC")
                        ),
                        ElevatedButton.icon(onPressed: eventCorrecte? () => {context.read<Qrprovider>().llegirQR(context)}:null,
                        icon: Icon(Icons.qr_code),
                        label: Text("Escàner QR")
                        ),
                        Consumer<Qrprovider>(
                          builder: (context, provider, child){
                            return Text(eventCorrecte ? provider.qrData : "",
                            style: TextStyle(
                              fontWeight: FontWeight.bold, 
                              overflow: TextOverflow.ellipsis, 
                            ),
                            maxLines: 1, 
                            );
                          }
                        ),
                      ]
                    )
                  ) 
                ),
              ),
            );
          }
        ),
      ),
    );
  }
  void event1() {
    setState(() {
      if (event.nom == "Paella" && event.dataInici == DateTime(2025,3,16,14,0)) {
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
                      Text("Durada:"),
                      Text("${event.dataIniciFormatejada}-${event.dataFiFormatejada}"),
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