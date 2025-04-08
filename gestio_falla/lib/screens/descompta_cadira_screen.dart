import 'package:flutter/material.dart';

class DescomptaCadira extends StatefulWidget{
  const DescomptaCadira({super.key});
  
  @override
  State<DescomptaCadira> createState() => DescomptaCadiraState();
}
class DescomptaCadiraState extends State<DescomptaCadira>{
  String event="Paella";
  bool maxCadires=false;
  int cadires=1;
  int cadiresRestants=9;
  double preu=1;
  late double preuTotal;
  bool pagat=false;
  bool cancelat=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    preuTotal=preu;
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pantalla d'events"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child:Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              /*Fer la imatge ací*/
              Text(event),
              Text("Quantitat de cadires: $cadires"),
              Text("Cadires restants: $cadiresRestants"),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Quants tickets vols?"),
                  IconButton(
                    icon: Icon(Icons.remove, color: Colors.red),
                    onPressed: cadires==1 ?null :decrementarNumTickets,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Text(
                      "$cadires",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.green),
                    onPressed: cadiresRestants==0 ?null :augmentarNumTickets,
                  ),
                ],
              ),
              Text("Preu total: $preuTotal€"),
              ElevatedButton(onPressed:(){
                pagar(context);
                }, 
                child: Text("Pagar")
              ),
              Text(pagat ?"Joel":cancelat?"Cancelat":""),
              Text(pagat ?"Pagat exitosament":cancelat?"Acció cancelada":"",
                style:
                  TextStyle( color: pagat?Colors.green:cancelat?Colors.red:Colors.white
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
  void pagar(BuildContext context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirmació"),
            content: Text("Vols pagar ja?"),
            actions: <Widget>[
              TextButton(
                child: Text("Sí"),
                onPressed: () {
                  Navigator.of(context).pop(true); // Torna vertader al tancar
                },
              ),
              TextButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop(false); // Torna fals al tancar
                },
              ),
            ],
          );
        },
      ).then((resultado) {
        // Aquí manejas la respuesta del usuario
        if (resultado != null && resultado) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Has acceptat l'acció")),
          );
          notificacio();
          setState(() {
            if(cadires==1){
              cadiresRestants--;
            }
            cadires=1;
            preuTotal=cadires*preu;
            pagat=true;
            cancelat=false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Has cancelat l'acció")),
          );
          setState(() {
            cadires--;
            cadiresRestants+=cadires;
            cadires=1;
            pagat=false;
            cancelat=true;
          });
        }
      }
    );
  }
  void augmentarNumTickets(){
    setState(() {
      cadires++;
      cadiresRestants--;
      preuTotal=cadires*preu;
      if(cadiresRestants==0){
        maxCadires=true;
      } 
    });
    
  }
  void decrementarNumTickets(){
    setState(() {
      cadires--;
      cadiresRestants++;
      preuTotal=cadires*preu;
      if(cadiresRestants!=0){
        maxCadires=false;
      } 
    });
  }
  void notificacio(){
    
  }
}