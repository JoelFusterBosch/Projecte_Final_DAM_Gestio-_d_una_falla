import 'package:flutter/material.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  _PerfilScreenState createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  String userName = "Joel";
  String familia = "Familia de Joel";
  String rol="Cap de familia";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil"),
        centerTitle: true,
        backgroundColor: Colors.orange
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage("lib/assets/perfil.jpg"),
              ),
              SizedBox(height: 10),
              Text(
                userName,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                familia,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: rol=="Cap de familia" ? (){AgregarMembre();}:null, child: Text("Agregar membre")),
              ElevatedButton(onPressed: CrearFamilia, child: Text("Crear familia")),
              ElevatedButton.icon(
                onPressed: () {
                  AlertDialog(title: Text("Funció no implementada"),);
                },
                icon: Icon(Icons.edit),
                label: Text("Editar Perfil"),
              ),
              SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () {
                  mostrarAlerta(context);
                },
                icon: Icon(Icons.logout, color: Colors.red),
                label: Text("Tancar sessió"),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void mostrarAlerta(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmació"),
          content: Text("¿Estas segur de voler tancar sessió?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(false); // Torna fals al cerrar
              },
            ),
            TextButton(
              child: Text("Aceptar"),
              onPressed: () {
                Navigator.of(context).pop(true); // Torna vertader al cerrar
              },
            ),
          ],
        );
      },
    ).then((resultado) {
      // Aquí manejas la respuesta del usuario
      if (resultado != null && resultado) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Has acceptat l'acció")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Has cancelat l'acció")),
        );
      }
    });
  }
  void AgregarMembre(){

  }
  void CrearFamilia(){

  }
}