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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(apiOdooProvider.message),
              Text(
                apiOdooProvider.status,
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),
              // Botón de login
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
                label: const Text("Obtener Usuarios"),
                onPressed: () {
                  apiOdooProvider.fetchUsers('1234');
                },
              ),
              const SizedBox(height: 30),
              // Lista de usuarios
              if (apiOdooProvider.events != null &&
                  apiOdooProvider.events!.isNotEmpty)
                Expanded(
                  child: Column(
                    children: [
                      const Text(
                        "Llista d'usuaris:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: apiOdooProvider.events!.length,
                          itemBuilder: (context, index) {
                            final user = apiOdooProvider.events![index];
                            return ListTile(
                              leading: const Icon(Icons.person),
                              title: Text(user['name'] ?? 'Sense nom'),
                              subtitle: Text(user['login'] ?? ''),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                )
              else if (apiOdooProvider.events != null)
                const Text("No n'hi han usuaris per a mostrar."),
            ],
          ),
        ),
      ),
    );
  }
}
