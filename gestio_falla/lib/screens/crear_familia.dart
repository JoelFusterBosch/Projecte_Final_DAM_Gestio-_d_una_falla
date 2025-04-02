import 'package:flutter/material.dart';

class CrearFamilia extends StatefulWidget{
  const CrearFamilia({super.key});

  @override
  State<CrearFamilia> createState() => CrearFamiliaState();
}
class CrearFamiliaState extends State<CrearFamilia>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Crear familia"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                labelText: 'Nom de la nova familia' 
              ),
               validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Has de posar el nom de la familia per a poder afegir-lo!";
                    }
                    return null;
               }
            ),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                labelText: "Confirmar nom de familia"
              ),
              validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Has de posar el nom de la familia per a poder comprobrar-lo!";
                    }
                    return null;
                  },
            ),
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
            }, child: Text("Enviar"))
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