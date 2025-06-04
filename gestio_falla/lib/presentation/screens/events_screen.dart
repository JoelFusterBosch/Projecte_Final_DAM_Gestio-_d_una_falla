import 'package:flutter/material.dart';
import 'package:gestio_falla/provider/Api-OdooProvider.dart';
import 'package:provider/provider.dart';
import 'package:gestio_falla/domain/entities/event.dart';
import 'package:gestio_falla/presentation/screens/event_detallat_screen.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Event> eventsFiltrats = [];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<ApiOdooProvider>(context, listen: false);
    provider.getEvents();
  }

  void _filtrarEvents(String query, List<Event> events) {
    final lowerQuery = query.toLowerCase();
    setState(() {
      eventsFiltrats = events
          .where((e) => e.nom.toLowerCase().contains(lowerQuery))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ApiOdooProvider>(context);
    final totsElsEvents = provider.events;

    var orientation = MediaQuery.of(context).orientation;
    double aspectRatio = orientation == Orientation.portrait ? 2 / 3 : 3 / 2;

    final mostra = eventsFiltrats.isNotEmpty || _searchController.text.isNotEmpty
        ? eventsFiltrats
        : totsElsEvents;

    return Scaffold(
      body: SafeArea(
        child: provider.loading
            ? const Center(child: CircularProgressIndicator())
            :  (provider.error ?? '').isNotEmpty
                ? Center(child: Text("Error: ${provider.error}"))
                : Padding(
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
                          onChanged: (query) =>
                              _filtrarEvents(query, totsElsEvents),
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: GridView.builder(
                            itemCount: mostra.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: aspectRatio,
                            ),
                            itemBuilder: (context, index) {
                              final event = mostra[index];
                              return Card(
                                color: Colors.white,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(event.nom,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 10),
                                      const Text("Data d'inici:"),
                                      Text(event.dataIniciFormatejada),
                                      const Text("Data de fi:"),
                                      Text(event.dataFiFormatejada),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  EventDetallatScreen(
                                                      event: event),
                                            ),
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
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
