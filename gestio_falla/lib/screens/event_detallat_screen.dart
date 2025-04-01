import 'package:flutter/material.dart';

class EventDetallatScreen extends StatefulWidget{
  const EventDetallatScreen({super.key});
  
  @override
  State<EventDetallatScreen> createState() => EventDetallatScreenState();
}
class EventDetallatScreenState extends State<EventDetallatScreen>{
  String event="Cremà de la falla Portal";
  bool maxFallers=false;
  int tickets=0;
  int ticketsRestants=9;
  double preu=1.20;
  double preuTotal=0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
              Text("Quantitat de tickets: $tickets"),
              Text("Tickets restants: $ticketsRestants"),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Quants tickets vols?"),
                  IconButton(
                    icon: Icon(Icons.remove, color: Colors.red),
                    onPressed: tickets==0 ?null :decrementarNumTickets,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: Colors.black, width: 1),
                    ),
                    child: Text(
                      "$tickets",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.green),
                    onPressed: ticketsRestants==0 ?null :augmentarNumTickets,
                  ),
                ],
              ),
              Text("Preu total: $preu€"),
              ElevatedButton(onPressed:(){
                pagar(context);
                }, 
                child: Text("Pagar")
                )
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
                  Navigator.of(context).pop(true); // Torna vertader al cerrar
                },
              ),
              TextButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop(false); // Torna fals al cerrar
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
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Has cancelat l'acció")),
          );
        }
      }
    );
  }
  void augmentarNumTickets(){
    setState(() {
      tickets++;
      ticketsRestants--;
      preuTotal=(tickets*preu);
      if(ticketsRestants==0){
        maxFallers=true;
      } 
    });
    
  }
  void decrementarNumTickets(){
    setState(() {
      tickets--;
      ticketsRestants++;
      preuTotal=(tickets*preu);
      if(ticketsRestants!=0){
        maxFallers=true;
      } 
    });
  }
}