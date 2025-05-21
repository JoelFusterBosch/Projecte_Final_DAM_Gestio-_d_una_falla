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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20),
                          Text(apiOdooProvider.message),
                          Text(
                            apiOdooProvider.status,
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text("Fallers"),
                          const SizedBox(height: 30),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.post_add),
                            label: const Text("Afegir faller"),
                            onPressed:(){
                              apiOdooProvider.postFaller(nom: "",rol: "",valorPulsera: "");
                            },
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: (){
                              apiOdooProvider.borrarFaller("");
                            },
                            icon: const Icon(Icons.delete),
                            label: const Text("Borrar faller"),
                          ),
                          Text("Events"),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: (){
                              apiOdooProvider.postEvents(nom: "",dataFi: DateTime(2), dataInici: DateTime(2));
                            }, 
                            icon: Icon(Icons.post_add), 
                            label: const Text("Afegir event"),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: (){
                             apiOdooProvider.borrarEvent(""); 
                            }, 
                            icon: const Icon(Icons.delete), 
                            label: const Text("Borrar event"),
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
                          Text("Families"),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: (){
                              apiOdooProvider.postFamilies("");
                            },
                            icon: const Icon(Icons.post_add),
                            label: const Text("Afegir familia"),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: (){
                              apiOdooProvider.borrarFamilia("");
                            },
                            icon: const Icon(Icons.delete), 
                            label: const Text("Borrar familia"),
                          ),
                          Text("Productes"),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: (){
                              apiOdooProvider.postProducte("", 1, 1, "");
                            }, 
                            icon: const Icon(Icons.post_add), 
                            label: const Text("Afegir producte"),
                          ),
                          const SizedBox(height: 20,),
                          ElevatedButton.icon(
                            onPressed: (){
                              apiOdooProvider.borrarProducte("");
                            }, 
                            icon: const Icon(Icons.delete), 
                            label: const Text("Borrar producte"),
                          ),
                          Text("Cobradors"),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: (){
                              apiOdooProvider.postCobrador("");
                            },
                            icon:const Icon(Icons.post_add),
                            label: const Text("Afegir cobrador"),
                          ),
                          const SizedBox(height: 20,),
                          ElevatedButton.icon(
                            onPressed: (){
                              apiOdooProvider.borrarCobrador("");
                            }, 
                            icon: Icon(Icons.delete),
                            label: Text("Borrar cobrador"),
                          ),
                          Text("Tickets"),
                          const SizedBox(height: 20),
                          ElevatedButton.icon(
                            onPressed: (){
                              apiOdooProvider.postTickets(2, 2, false);
                            },
                            icon: Icon(Icons.post_add),
                            label: const Text("Afegir ticket"),
                          ),
                          const SizedBox(height: 20,),
                          ElevatedButton.icon(
                            onPressed: (){
                              apiOdooProvider.borrarTicket("");
                            }, 
                            icon: const Icon(Icons.delete),
                            label: const Text("Borrar ticket"),
                          ),
                          //borrar?
                          ElevatedButton.icon(
                            icon: const Icon(Icons.download),
                            label: const Text("Obtindre Fallers"),
                            onPressed: () {
                              apiOdooProvider.getFallers();
                            },
                          ),
                          const SizedBox(height: 30),
                          if (apiOdooProvider.fallers.isNotEmpty) ...[
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
                              itemCount: apiOdooProvider.fallers.length,
                              itemBuilder: (context, index) {
                                final user = apiOdooProvider.fallers[index];
                                return ListTile(
                                  leading: const Icon(Icons.person),
                                  title: Text(user['nom'] ?? 'Sense nom'),
                                );
                              },
                            ),
                          ],
                          ElevatedButton.icon(
                            icon: const Icon(Icons.event),
                            label: const Text("Obtindre events"),
                            onPressed: () {
                              apiOdooProvider.getEvents();
                            },
                          ),
                          if (apiOdooProvider.events.isNotEmpty) ...[
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
                              itemCount: apiOdooProvider.events.length,
                              itemBuilder: (context, index) {
                                final event = apiOdooProvider.events[index];
                                return ListTile(
                                  leading:
                                      const Icon(Icons.event_available),
                                  title: Text(event['nom'] ?? 'Sense nom'),
                                );
                              },
                            ),
                          ],
                          ElevatedButton.icon(
                            icon: const Icon(Icons.family_restroom),
                            label: const Text("Obtindre families"),
                            onPressed: () {
                              apiOdooProvider.getFamilies();
                            },
                          ),
                          if (apiOdooProvider.families.isNotEmpty) ...[
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
                              itemCount: apiOdooProvider.families.length,
                              itemBuilder: (context, index) {
                                final familia = apiOdooProvider.families[index];
                                return ListTile(
                                  leading: const Icon(Icons.event_available),
                                  title: Text(familia['nom'] ?? 'Sense nom'),
                                );
                              },
                            ),
                          ],
                        ],
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
