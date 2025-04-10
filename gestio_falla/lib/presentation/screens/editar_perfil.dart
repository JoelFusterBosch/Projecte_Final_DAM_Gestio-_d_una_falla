import 'package:flutter/material.dart';
import 'package:gestio_falla/presentation/screens/editar_contrasenya.dart';
import 'package:gestio_falla/presentation/screens/editar_usuari.dart';

class EditarPerfil extends StatefulWidget{
  const EditarPerfil({super.key});

  
  @override
  State<EditarPerfil> createState() =>EditarPerfilState();
}

class EditarPerfilState extends State<EditarPerfil>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar Perfil"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          children: [
            Text("Que vols fer?"),
            ElevatedButton(onPressed: (){
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => EditarUsuari())
                );
              },
              child: Text("Canviar usuari")
            ),
            ElevatedButton(onPressed: (){
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => EditarContrasenya())
                );
              },
              child: Text("Canviar contrasenya")
            ),
          ],
        ),
      ),
    );
  }

}