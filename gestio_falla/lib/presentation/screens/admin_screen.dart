import 'package:flutter/material.dart';
import 'package:gestio_falla/provider/Api-OdooProvider.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final apiOdooProvider = Provider.of<ApiOdooProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pantalla de login"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
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
                            ElevatedButton.icon(
                              icon: const Icon(Icons.login),
                              label: const Text("Login"),
                              onPressed: () {
                                apiOdooProvider.login('odoo@odoo.com', '1234');
                              },
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.download),
                              label: const Text("Obtindre Usuaris"),
                              onPressed: () {
                                apiOdooProvider.fetchUsers('1234');
                              },
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.event),
                              label: const Text("Obtindre events"),
                              onPressed: () {
                                apiOdooProvider.getEvents('1234');
                              },
                            ),
                            const SizedBox(height: 30),
                            if (apiOdooProvider.users != null &&
                                apiOdooProvider.users!.isNotEmpty) ...[
                              const Text(
                                "Llista d'usuaris:",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: apiOdooProvider.users!.length,
                                itemBuilder: (context, index) {
                                  final user = apiOdooProvider.users![index];
                                  return ListTile(
                                    leading: const Icon(Icons.person),
                                    title: Text(user['name'] ?? 'Sense nom'),
                                    subtitle: Text(user['login'] ?? ''),
                                  );
                                },
                              ),
                            ] else if (apiOdooProvider.events != null)
                              const Text("No n'hi han events per a mostrar."),
                            const SizedBox(height: 30),
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
                                        Text(event['name'] ?? 'Sense nom'),
                                  );
                                },
                              ),
                            ] else if (apiOdooProvider.events != null)
                              const Text("No n'hi han events per a mostrar."),
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
