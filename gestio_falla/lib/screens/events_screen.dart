import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/event.dart';
import 'package:gestio_falla/repository/events_repository.dart';
import 'package:gestio_falla/screens/event_categoria_screen.dart';
import 'package:gestio_falla/screens/event_detallat_screen.dart';


class EventsScreen extends StatefulWidget{
  const EventsScreen({super.key});
  
  @override
  State<EventsScreen> createState() => EventsScreenState();
}
class EventsScreenState extends State<EventsScreen>{
  //late Future<List<Event>> _futureEvents;
  List<Event> totsElsEvents=[];
  List<Event> eventsFiltrats=[];
  int eventSeleccionat=0; 
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    /*
    var EventRepository =
        EventRepositoryImpl(ProdDatasource('http://10.0.2.2:8090/api'));
    _futureEvents = EventRepository.obtenirEvents(endpoint);

    _futureEvents.then((eventss) {
      setState(() {
        totsElsEvents = events;
        eventsFiltrats = List.from(totsElsEvents);
      });
    });
  */
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
                /*
                Expanded(child: eventSeleccionat==1 
                  ?EventCategoriaScreen() 
                  :FutureBuilder(future: _futureEvents, builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return const Center(child: CircularProgressIndicator(),);
                    } else if(snapshot.hasError){
                      return Center(child: Text("Error ${snapshot.error}"),);
                    } else if(!snapshot.hasData || snapshot.data!.isEmpty){
                      return const Center(child: Text("No n'hi han events disponibles"),);
                    }
                    List<Event> events = snapshot.data!;
                    return GridView.builder(
                      padding: const EdgeInsets.all(16.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.8,
                        ),
                      itemCount: events.length, 
                      itemBuilder: (context,index){
                        final event=events[index];
                        return GestureDetector(
                          onTap: (){
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context)=> EventDetallatScreen())
                            );
                          },
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            elevation: 4,
                            child: Column(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15)
                                    ),
                                  )
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Text(event.nom,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold
                                        )
                                      ),
                                      Text(event.preu.toString(),
                                      style: const TextStyle(
                                        overflow:TextOverflow.ellipsis
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              */
            ],
          ),
        ),
      );
  }
}