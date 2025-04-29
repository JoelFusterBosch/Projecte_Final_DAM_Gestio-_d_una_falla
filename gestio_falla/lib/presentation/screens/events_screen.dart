import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/event.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/presentation/screens/event_categoria_screen.dart';
import 'package:gestio_falla/presentation/screens/event_detallat_screen.dart';


class EventsScreen extends StatefulWidget{
  const EventsScreen({super.key});
  
  @override
  State<EventsScreen> createState() => EventsScreenState();
}
class EventsScreenState extends State<EventsScreen>{
  Faller faller= Faller(nom: "Joel", rol: "Faller");
  List<Event> totsElsEvents=[];
  List<Event> eventsFiltrats=[];
  int eventSeleccionat=0; 
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    
  }
  void eventsFiltratsBusqueda() {
      setState(() {
        String query = _searchController.text.toLowerCase();
        eventsFiltrats = totsElsEvents
            .where((Event) => Event.nom.toLowerCase().contains(query))
            .toList();
      });
    }
  void enEventSeleccionat(int tabIndex) {
    setState(() {
       eventSeleccionat= tabIndex;
      if (eventSeleccionat == 0) {
        // Mostrar pantalla principal
        eventsFiltrats = List.from(totsElsEvents);
      }
    });

  }
  void filterProducts() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      eventsFiltrats = totsElsEvents
          .where((Event) => Event.nom.toLowerCase().contains(query))
          .toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
          appBar: AppBar(
          title: Text("Events"),
          centerTitle: true,
          backgroundColor: Colors.orange
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Buscar events',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      prefixIcon: const Icon(Icons.search),
                    ),
                  ),
                ),
                Row(
                  children: [
                    ElevatedButton(onPressed: (){
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => EventDetallatScreen())
                      );
                    },
                    child: Text("Event detallat")
                    ),
                    ElevatedButton(onPressed: (){
                      Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => EventCategoriaScreen())
                      );
                    },
                    child: Text("Categories d'events")
                    ),
                  ],
                ),
                Text(faller.nom
              ),   
            ],
          ),
        ),
      );
  }
}