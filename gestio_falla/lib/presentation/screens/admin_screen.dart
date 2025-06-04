import 'package:flutter/material.dart';
import 'package:gestio_falla/provider/Api-OdooProvider.dart';
import 'package:gestio_falla/provider/nfcProvider.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  Widget buildMenuButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color color = Colors.blue,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void mostrarFormulari({
    required BuildContext context,
    required String title,
    required List<Widget> fields,
    required VoidCallback onSubmit,
  }) {
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(child: Column(mainAxisSize: MainAxisSize.min, children: fields)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel·la'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                onSubmit();
                Navigator.of(context).pop();
              }
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final api = Provider.of<ApiOdooProvider>(context);
    final nfcapi= Provider.of<NfcProvider>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            buildMenuButton(
              icon: Icons.person_add,
              label: 'Afegir faller',
              onTap: () {
                String nom = '', rol = '', valor = '';
                mostrarFormulari(
                  context: context,
                  title: 'Afegir Faller',
                  fields: [
                    TextFormField(decoration: InputDecoration(labelText: 'Nom'), onChanged: (v) => nom = v, validator: (v) => v!.isEmpty ? 'Obligatori' : null),
                    TextFormField(decoration: InputDecoration(labelText: 'Rol'), onChanged: (v) => rol = v, validator: (v) => v!.isEmpty ? 'Obligatori' : null),
                    TextFormField(decoration: InputDecoration(labelText: 'Valor Pulsera'), onChanged: (v) => valor = v, validator: (v) => v!.isEmpty ? 'Obligatori' : null),
                  ],
                  onSubmit: () => api.postFaller(nom: nom, rol: rol, valorPulsera: valor),
                );
              },
            ),
            buildMenuButton(
              icon: Icons.person_remove,
              label: 'Borrar faller',
              color: Colors.red,
              onTap: () {
                String valorPolsera = '';
                mostrarFormulari(
                  context: context,
                  title: 'Borrar Faller',
                  fields: [
                    TextFormField(decoration: InputDecoration(labelText: 'Valor de la polsera'), onChanged: (v) => valorPolsera = v, validator: (v) => v!.isEmpty ? 'Obligatori' : null),
                  ],
                  onSubmit: () => api.borrarFaller(valorPolsera),
                );
              },
            ),
            buildMenuButton(
              icon: Icons.event,
              label: 'Afegir event',
              onTap: () {
                String nomEvent = '';
                DateTime dataInici = DateTime.now();
                DateTime dataFi = DateTime.now();
                mostrarFormulari(
                  context: context,
                  title: 'Afegir Event',
                  fields: [
                    TextFormField(decoration: InputDecoration(labelText: 'Nom'), onChanged: (v) => nomEvent = v, validator: (v) => v!.isEmpty ? 'Obligatori' : null),
                  ],
                  onSubmit: () => api.postEvents(nom: nomEvent, dataFi: dataFi, dataInici: dataInici),
                );
              },
            ),
            buildMenuButton(
              icon: Icons.event_busy,
              label: 'Borrar event',
              color: Colors.red,
              onTap: () {
                String nomEventBorrar = '';
                mostrarFormulari(
                  context: context,
                  title: 'Borrar Event',
                  fields: [
                    TextFormField(decoration: InputDecoration(labelText: "Nom de l'event a borrar"), onChanged: (v) => nomEventBorrar = v, validator: (v) => v!.isEmpty ? 'Obligatori' : null),
                  ],
                  onSubmit: () => api.borrarEvent(nomEventBorrar),
                );
              },
            ),
            buildMenuButton(
              icon: Icons.family_restroom,
              label: 'Afegir família',
              onTap: () {
                String nom = '';
                mostrarFormulari(
                  context: context,
                  title: 'Afegir Família',
                  fields: [
                    TextFormField(decoration: InputDecoration(labelText: 'Nom'), onChanged: (v) => nom = v, validator: (v) => v!.isEmpty ? 'Obligatori' : null),
                  ],
                  onSubmit: () => api.postFamilies(nom),
                );
              },
            ),
            buildMenuButton(
              icon: Icons.delete_forever,
              label: 'Borrar família',
              color: Colors.red,
              onTap: () {
                String nomFamilia = '';
                mostrarFormulari(
                  context: context,
                  title: 'Borrar Família',
                  fields: [
                    TextFormField(decoration: InputDecoration(labelText: 'Nom de la familia a borrar'), onChanged: (v) => nomFamilia = v, validator: (v) => v!.isEmpty ? 'Obligatori' : null),
                  ],
                  onSubmit: () => api.borrarFamilia(nomFamilia),
                );
              },
            ),
            buildMenuButton(
              icon: Icons.shopping_cart,
              label: 'Afegir producte',
              onTap: () {
                String nom = '', unitat = '', preu = '';
                mostrarFormulari(
                  context: context,
                  title: 'Afegir Producte',
                  fields: [
                    TextFormField(decoration: InputDecoration(labelText: 'Nom'), onChanged: (v) => nom = v, validator: (v) => v!.isEmpty ? 'Obligatori' : null),
                    TextFormField(decoration: InputDecoration(labelText: 'Unitat'), onChanged: (v) => unitat = v, validator: (v) => v!.isEmpty ? 'Obligatori' : null),
                    TextFormField(decoration: InputDecoration(labelText: 'Preu'), onChanged: (v) => preu = v, validator: (v) => v!.isEmpty ? 'Obligatori' : null),
                  ],
                  onSubmit: () => api.postProducte(nom, double.tryParse(unitat) ?? 0, int.tryParse(preu) ?? 0, ''),
                );
              },
            ),
            buildMenuButton(
              icon: Icons.delete_sweep,
              label: 'Borrar producte',
              color: Colors.red,
              onTap: () {
                String nomProducte = '';
                mostrarFormulari(
                  context: context,
                  title: 'Borrar Producte',
                  fields: [
                    TextFormField(decoration: InputDecoration(labelText: 'Nom del producte'), onChanged: (v) => nomProducte = v, validator: (v) => v!.isEmpty ? 'Obligatori' : null),
                  ],
                  onSubmit: () => api.borrarProducte(nomProducte),
                );
              },
            ),
            buildMenuButton(
              icon: Icons.badge,
              label: 'Afegir cobrador',
              onTap: () {
                String rolCobrador = '';
                mostrarFormulari(
                  context: context,
                  title: 'Afegir Cobrador',
                  fields: [
                    TextFormField(decoration: InputDecoration(labelText: 'Rol del cobrador'), onChanged: (v) => rolCobrador = v, validator: (v) => v!.isEmpty ? 'Obligatori' : null),
                  ],
                  onSubmit: () => api.postCobrador(rolCobrador),
                );
              },
            ),
            buildMenuButton(
              icon: Icons.delete,
              label: 'Borrar cobrador',
              color: Colors.red,
              onTap: () {
                String rolCobrador = '';
                mostrarFormulari(
                  context: context,
                  title: 'Borrar Cobrador',
                  fields: [
                    TextFormField(decoration: InputDecoration(labelText: 'Rol del cobrador'), onChanged: (v) => rolCobrador = v, validator: (v) => v!.isEmpty ? 'Obligatori' : null),
                  ],
                  onSubmit: () => api.borrarCobrador(rolCobrador),
                );
              },
            ),
            buildMenuButton(
              icon: Icons.confirmation_num,
              label: 'Afegir ticket',
              onTap: () {
                String fallerId = '', eventId = '';
                mostrarFormulari(
                  context: context,
                  title: 'Afegir Ticket',
                  fields: [
                    TextFormField(decoration: InputDecoration(labelText: 'ID Faller'), onChanged: (v) => fallerId = v, validator: (v) => v!.isEmpty ? 'Obligatori' : null),
                    TextFormField(decoration: InputDecoration(labelText: 'ID Event'), onChanged: (v) => eventId = v, validator: (v) => v!.isEmpty ? 'Obligatori' : null),
                  ],
                  onSubmit: () => api.postTickets(int.tryParse(fallerId) ?? 0, double.tryParse(eventId) ?? 0, false),
                );
              },
            ),
            buildMenuButton(
              icon: Icons.clear,
              label: 'Borrar ticket',
              color: Colors.red,
              onTap: () {
                String id = '';
                mostrarFormulari(
                  context: context,
                  title: 'Borrar Ticket',
                  fields: [
                    TextFormField(decoration: InputDecoration(labelText: 'ID'), onChanged: (v) => id = v, validator: (v) => v!.isEmpty ? 'Obligatori' : null),
                  ],
                  onSubmit: () => api.borrarTicket(id),
                );
              },
            ),
            buildMenuButton(icon: Icons.edit, label: "Escriure NFC", onTap: (){
              String valorpulsera='';
              mostrarFormulari(
                context: context,
                title: "Escriure NFC", 
                fields: [
                  TextFormField(decoration: InputDecoration(labelText: 'Escriure NFC'), onChanged: (v) => valorpulsera = v ,validator:(v) => v!.isEmpty ? 'Obligatori':null),
                ], 
                onSubmit: () => nfcapi.escriureNFC(valorpulsera)); 
              }
            )
          ],
        ),
      ),
    );
  }
}
