import 'package:flutter/material.dart';

class EditarContrasenya extends StatefulWidget{
  const EditarContrasenya({super.key});

  @override
  State<EditarContrasenya> createState() => EditarContrasenyaState();

}

class EditarContrasenyaState extends State<EditarContrasenya>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Canviar Contrasenya"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Antiga contrasenya"),
            TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                labelText: 'Antiga contrasenya' 
              ),
              validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El camp Antiga contrasenya és obligatori';
                    }
                    return null;
                  },
            ),
            Text("Nova contrasenya"),
            TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                labelText: 'Nova contrasenya'
              ),
              validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El camp Nova contrasenya és obligatori';
                    }
                    return null;
                  },
            ),
            Text("Confirmar contrasenya"),
            TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20)
                ),
                labelText: 'Torna a insertar la contrasenya per a confirmar'
              ),
              validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El camp Torna a insertar la contrasenya per a confirmar és obligatori';
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

