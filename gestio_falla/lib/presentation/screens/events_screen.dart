import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/event.dart';
import 'package:gestio_falla/presentation/screens/event_detallat_screen.dart';


class EventsScreen extends StatefulWidget{
  final List<Event> totsElsEvents;
  const EventsScreen({super.key, required this.totsElsEvents});
  
  @override
  State<EventsScreen> createState() => EventsScreenState();
}
class EventsScreenState extends State<EventsScreen>{

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
        eventsFiltrats = widget.totsElsEvents
            .where((Event) => Event.nom.toLowerCase().contains(query))
            .toList();
      });
    }
  void enEventSeleccionat(int tabIndex) {
    setState(() {
       eventSeleccionat= tabIndex;
      if (eventSeleccionat == 0) {
        // Mostrar pantalla principal
        eventsFiltrats = List.from(widget.totsElsEvents);
      }
    });

  }
  void filtrarEvents() {
    setState(() {
      String query = _searchController.text.toLowerCase();
      eventsFiltrats = widget.totsElsEvents
          .where((Event) => Event.nom.toLowerCase().contains(query))
          .toList();
    });
  }
  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    double aspectRatio = orientation == Orientation.portrait ? 2 / 3 : 3 / 2;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Buscar events',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: (_) => eventsFiltratsBusqueda(),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: eventsFiltrats.isNotEmpty ? eventsFiltrats.length : widget.totsElsEvents.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: aspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    final event = eventsFiltrats.isNotEmpty ? eventsFiltrats[index] : widget.totsElsEvents[index];
                    return Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(event.nom, style: const TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 10),
                            Text("Data d'inici:"),
                            Text(event.dataIniciFormatejada),
                            Text("Data de fi:"),
                            Text(event.dataFiFormatejada),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => EventDetallatScreen(event: event,)),
                                );
                              },
                              child: const Text("Més detalls"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}