import 'package:flutter/material.dart';
import 'package:gestio_falla/provider/Api-OdooProvider.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apiOdooProvider = Provider.of<ApiOdooProvider>(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 600),
                      child: IntrinsicHeight(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 20),
                            Text(apiOdooProvider.message),
                            Text(
                              apiOdooProvider.status,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 30),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.cookie),
                              label: const Text("Saluda"),
                              onPressed: apiOdooProvider.saluda, 
                              ),
                              /*
                            ElevatedButton.icon(
                              icon: const Icon(Icons.login),
                              label: const Text("Login"),
                              onPressed: () {
                                apiOdooProvider.login('odoo@odoo.com', '1234');
                              },
                            ),
                            */
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.download),
                              label: const Text("Obtindre Fallers"),
                              onPressed: () {
                                apiOdooProvider.getFallers();
                              },
                            ),
                            const SizedBox(height: 30),
                            if (apiOdooProvider.fallers != null &&
                                apiOdooProvider.fallers!.isNotEmpty) ...[
                              const Text(
                                "Llista de fallers:",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: apiOdooProvider.fallers!.length,
                                itemBuilder: (context, index) {
                                  final user = apiOdooProvider.fallers![index];
                                  return ListTile(
                                    leading: const Icon(Icons.person),
                                    title: Text(user['nom'] ?? 'Sense nom'),
                                  );
                                },
                              ),
                            ] else if (apiOdooProvider.fallers == null)
                              const Text("No n'hi han fallers per a mostrar."),
                            const SizedBox(height: 30),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.event),
                              label: const Text("Obtindre events"),
                              onPressed: () {
                                apiOdooProvider.getEvents();
                              },
                            ),
                            if (apiOdooProvider.events != null &&
                                apiOdooProvider.events!.isNotEmpty) ...[
                              const Text(
                                "Llista d'events:",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: apiOdooProvider.events!.length,
                                itemBuilder: (context, index) {
                                  final event = apiOdooProvider.events![index];
                                  return ListTile(
                                    leading:
                                        const Icon(Icons.event_available),
                                    title:
                                        Text(event['nom'] ?? 'Sense nom'),
                                  );
                                },
                              ),
                            ] else if (apiOdooProvider.events == null)
                              const Text("No n'hi han events per a mostrar."),
                            ElevatedButton.icon(
                              icon: Icon(Icons.family_restroom),
                              label:  const Text("Obtindre families"),
                              onPressed: (){
                                apiOdooProvider.getFamilies();
                              }
                            ),
                            
                            if (apiOdooProvider.families != null &&
                                apiOdooProvider.families!.isNotEmpty) ...[
                              const Text(
                                "Llista de families:",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 30),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: apiOdooProvider.families!.length,
                                itemBuilder: (context, index) {
                                  final familia = apiOdooProvider.families![index];
                                  return ListTile(
                                    leading:
                                        const Icon(Icons.event_available),
                                    title:
                                        Text(familia['nom'] ?? 'Sense nom'),
                                  );
                                },
                              ),
                            ] else if (apiOdooProvider.families == null)
                              const Text("No n'hi han families per a mostrar."),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
