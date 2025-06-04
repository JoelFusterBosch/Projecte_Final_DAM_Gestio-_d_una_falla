import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/event.dart';

class EventDetallatScreen extends StatefulWidget{
  final Event event;
  const EventDetallatScreen({super.key, required this.event});
  
  @override
  State<EventDetallatScreen> createState() => EventDetallatScreenState();
}
class EventDetallatScreenState extends State<EventDetallatScreen>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    final event = widget.event;
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
              Image.network(event.urlimatge ?? "No n'hi ha imatge disponible"),
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
                      event.descripcio ?? "No n'hi ha descripció per a este event",
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
}