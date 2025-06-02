import 'package:flutter/material.dart';
//import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/presentation/screens/login_screen.dart';
import 'package:gestio_falla/provider/Api-OdooProvider.dart';
import 'package:provider/provider.dart';


class RegistrarUsuari extends StatefulWidget{
  const RegistrarUsuari({super.key});

  @override
  State<RegistrarUsuari> createState() => RegistrarUsuariState();

}

class RegistrarUsuariState extends State<RegistrarUsuari> {
  final List<String> rols = ['Inserta un rol', 'Faller', 'Cobrador', 'Administrador'];
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomController = TextEditingController();

  String _rolSeleccionat = 'Inserta un rol';

  @override
  Widget build(BuildContext context) {
    final apiOdooProvider = Provider.of<ApiOdooProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar usuari"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 150,
                          child: Image.asset('lib/assets/FallaPortal.png', fit: BoxFit.contain),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Nom d'usuari"),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _nomController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                              labelText: "Nom d'usuari",
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "El camp Nom d'usuari és obligatori";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Rol"),
                        ),
                        DropdownButton<String>(
                          value: _rolSeleccionat,
                          onChanged: (String? newValue) {
                            setState(() {
                              _rolSeleccionat = newValue!;
                            });
                          },
                          items: rols.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (_rolSeleccionat == 'Inserta un rol') {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Selecciona un rol vàlid")),
                                );
                                return;
                              }

                              final nomUsuari = _nomController.text.trim();
                              final rolUsuari = _rolSeleccionat;

                              try {
                                await apiOdooProvider.postFaller(
                                  nom: nomUsuari,
                                  rol: rolUsuari,
                                  valorPulsera: '0', // o el valor que correspongui per defecte
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Usuari registrat correctament!")),
                                );
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen()),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: ${e.toString()}")),
                                );
                              }
                            }
                          },
                          child: Text("Registrar-se"),
                        ),
                        if (apiOdooProvider.status.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Estat: ${apiOdooProvider.status}"),
                          ),
                      ],
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
