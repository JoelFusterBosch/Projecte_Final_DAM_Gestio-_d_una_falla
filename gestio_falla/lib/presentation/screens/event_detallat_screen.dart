import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/event.dart';
import 'package:gestio_falla/domain/entities/ticket.dart';

class EventDetallatScreen extends StatefulWidget{
  const EventDetallatScreen({super.key});
  
  @override
  State<EventDetallatScreen> createState() => EventDetallatScreenState();
}
class EventDetallatScreenState extends State<EventDetallatScreen>{
  Event event=Event(nom: "Cremà de la Falla Portal", dataInici: DateTime(2025,3,16,15,0), dataFi: DateTime(2025,3,16,15,0),ticket:Ticket(id: 1, preu: 1.2, quantitat: 1, maxim: false), urlImatge: "lib/assets/perfil.jpg");
  bool maxFallers=false;
  int ticketsRestants=9;
  late double preuTotal;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    preuTotal=event.ticket!.preu;
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
                    const SizedBox(height: 80),
                    Image.network(event.urlImatge ?? ""),
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            event.nom,
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                            event.desc ?? "",
                            textAlign: TextAlign.justify,
                            style: Theme.of(context).textTheme.bodyMedium,
                          )
                        ],
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
          setState(() {
            event.ticket!.quantitat=1;
            preuTotal=event.ticket!.quantitat*event.ticket!.preu;
          });
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
      event.ticket!.quantitat++;
      ticketsRestants--;
      preuTotal=event.ticket!.quantitat*event.ticket!.preu;
      if(ticketsRestants==0){
        maxFallers=true;
      } 
    });
    
  }
  void decrementarNumTickets(){
    setState(() {
      event.ticket!.quantitat--;
      ticketsRestants++;
      preuTotal=event.ticket!.quantitat*event.ticket!.preu;
      if(ticketsRestants!=0){
        maxFallers=false;
      } 
    });
  }
}