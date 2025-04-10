import 'package:flutter/material.dart';

class EditarUsuari extends StatefulWidget{
  const EditarUsuari({super.key});

  @override
  State<EditarUsuari> createState() => EditarUsuariState();
}
class EditarUsuariState extends State<EditarUsuari>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Canviar usuari"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Nom antic de l'usuari"),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                labelText: "Nom antic de l'usuari" 
              ),
               validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "El camp Nou nom d'usuari és obligatori";
                    }
                    return null;
               }
            ),
            Text("Nou nom d'usuari"),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                labelText: "Nou nom d'usuari"
              ),
              validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "El camp Nou nom d'usuari és obligatori";
                    }
                    return null;
                  },
            ),
            Text("Contrasenya"),
            TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                labelText: 'Contrasenya'
              ),
              validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El camp Contrasenya és obligatori';
                    }
                    return null;
                  },
            ),
            ElevatedButton(onPressed: (){
              mostrarAlerta(context);
            }, child: Text("Canviar"))
          ],
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
          content: Text("¿Estas segur dels canvis?"),
          actions: <Widget>[
            TextButton(
              child: Text("Sí"),
              onPressed: () {
                Navigator.of(context).pop(true); // Torna vertader al tancar
              },
            ),
            TextButton(
              child: Text("No"),
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
}