import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/domain/entities/familia.dart';
import 'package:gestio_falla/presentation/screens/afegir_membre.dart';
import 'package:gestio_falla/presentation/screens/crear_familia.dart';
import 'package:gestio_falla/presentation/screens/editar_perfil.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => PerfilScreenState();
}

class PerfilScreenState extends State<PerfilScreen> {
  Faller faller = Faller(nom: "Joel",familia: Familia(nom: "Família de Joel"), rol: "Cap de familia");

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
                faller.nom,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                faller.familia!.nom,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 20),
              ElevatedButton(onPressed: faller.rol=="Cap de familia" ? (){afgMembre();}:null, child: Text("Agregar membre")),
              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>CrearFamilia()));
              }, child: Text("Crear familia")),
              ElevatedButton.icon(
                onPressed: () {
                Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context) => EditarPerfil())
                );
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
              child: Text("Acceptar"),
              onPressed: () {
                Navigator.of(context).pop(true); // Torna vertader al tancar
              },
            ),
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(false); // Torna fals al tancar
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
  void afgMembre(){
    if(faller.rol=="Cap de familia"){
      Navigator.push(context,MaterialPageRoute(builder: (context)=> AfegirMembre()));
    }
  }
}