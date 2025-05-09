import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/event.dart';
import 'package:gestio_falla/presentation/screens/event_detallat_screen.dart';

class EventCategoriaDetallatScreen extends StatefulWidget{
  final String categoria; 
  const EventCategoriaDetallatScreen({super.key, required this.categoria});

  @override
  State<EventCategoriaDetallatScreen> createState() => EventCategoriaDetallatScreenState();
}
class EventCategoriaDetallatScreenState extends State<EventCategoriaDetallatScreen>{
  late Future<List<Event>> _futureEvents;
  final endpoint = "";

  @override
  void initState() {
    super.initState();
    /*
    var prodRepository =
        EventRepositoryImpl(EventDatasource('http://192.168.152.26:8069/api'));
    _futureEvents =
        prodRepository.obtenirProductsByCategory(endpoint, widget.categoria);
        */
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Events de categoria ${widget.categoria}")),
      body: FutureBuilder<List<Event>>(
        future: _futureEvents,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hi han events disponibles.'));
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
            itemBuilder: (context, index) {
              final event = events[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EventDetallatScreen()
                    ),
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
                            borderRadius: BorderRadius.circular(15),
                            image: DecorationImage(
                              image: NetworkImage(
                                  "http://192.168.152.26:8069/api"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
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
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

}