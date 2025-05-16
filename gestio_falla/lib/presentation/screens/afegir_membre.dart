import 'package:flutter/material.dart';
import 'package:gestio_falla/provider/nfcProvider.dart';
import 'package:gestio_falla/provider/qrProvider.dart';
import 'package:provider/provider.dart';

class AfegirMembre extends StatefulWidget{
  const AfegirMembre({super.key});

  @override
  State<AfegirMembre> createState() => AfegirMembreState();
}
class AfegirMembreState extends State<AfegirMembre>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Afegir membre"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints){
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Nom del membre"),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          labelText: 'Nom del membre a afegir' 
                        ),
                        validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Has de posar el nom d'un membre per a poder afegir-lo!";
                              }
                              return null;
                        }
                      ),
                      Text("Confirmar"),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20)
                          ),
                          labelText: "Confirmar membre"
                        ),
                        validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Has de posar el nom del membre per a poder comprobrar-lo!";
                              }
                              return null;
                            },
                      ),
                      ElevatedButton(onPressed: (){
                        verificar(context);
                      }, child: Text("Verificar"))
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  void verificar(BuildContext context) {
    Text("Amb que vols verificar?");
    ElevatedButton(onPressed: () =>context.read<NfcProvider>().llegirEtiqueta(context) ,child: Text("NFC"),);
        Consumer<NfcProvider>(
      builder: (context, provider, child) {
        return Text( provider.nfcData ,
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            overflow: TextOverflow.ellipsis, 
          ),
          maxLines: 1,
        );
      },
    );
    ElevatedButton(onPressed: () =>context.read<Qrprovider>().llegirQR(context) ,child: Text("NFC"),);
    Consumer<Qrprovider>(
      builder: (context, provider, child){
        return Text(provider.qrData,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            overflow: TextOverflow.ellipsis,
          ),
          maxLines: 1,
        );
      },
    );
  }
}