import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/event.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/presentation/screens/event_detallat_screen.dart';


class EventsScreen extends StatefulWidget{
  const EventsScreen({super.key});
  
  @override
  State<EventsScreen> createState() => EventsScreenState();
}
class EventsScreenState extends State<EventsScreen>{
  Faller faller= Faller(nom: "Joel", rol: "Faller", valorPulsera: "8430001000017", teLimit: false);
  List<Event> totsElsEvents=[
    Event(nom: "Paella", dataInici:DateTime(2025,3,16,14,0), dataFi:DateTime(2025,3,16,17,0)),
    Event(nom: "Cremà", dataInici:DateTime(2025,3,20,20,0), dataFi:DateTime(2025,3,21,2,0)),
    Event(nom: "Jocs", dataInici:DateTime(2025,3,15,9,0), dataFi:DateTime(2025,3,16,19,0)),
    Event(nom: "Despedida", dataInici:DateTime(2025,3,19,16,0), dataFi:DateTime(2025,3,19,18,0)),
    Event(nom: "Caminata", dataInici:DateTime(2025,3,19,16,0), dataFi:DateTime(2025,3,19,18,0)),
  ];
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
    var orientation = MediaQuery.of(context).orientation;
    double aspectRatio = orientation == Orientation.portrait ? 2 / 3 : 3 / 2;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Events"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
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
                  itemCount: eventsFiltrats.isNotEmpty ? eventsFiltrats.length : totsElsEvents.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: aspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    final event = eventsFiltrats.isNotEmpty ? eventsFiltrats[index] : totsElsEvents[index];
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
                                  MaterialPageRoute(builder: (context) => EventDetallatScreen()),
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