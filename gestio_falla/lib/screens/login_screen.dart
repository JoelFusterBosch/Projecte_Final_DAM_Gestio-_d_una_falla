import 'package:flutter/material.dart';
import 'package:gestio_falla/screens/registrar_usuari.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => LoginScreenState();

}
class LoginScreenState extends State<LoginScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Iniciar sessió"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Iniciar sessió"),
            Text("Nom d'usuari"),
            TextFormField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
                labelText: "Nom d'usuari",
              ),
              validator: (value) {
                if(value==null || value.isEmpty){
                  return "El camp Nom d'usuari és obligatori";
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
                  borderRadius: BorderRadius.circular(15)
                ),
                labelText: "Contrasenya"
              ),
              validator: (value) {
                if(value==null || value.isEmpty){
                  return "El camp contrasenya es obligatori";
                }
                return null;
              },
            ),
            ElevatedButton(onPressed: iniciasesio, child: Text("Iniciar sessió")),
            Text("No tens un compte?"),
            GestureDetector(
              onTap: () {
                Navigator.push(context, 
                MaterialPageRoute(
                  builder: (context)=> RegistrarUsuari()
                  ),
                );
              },
              child: const Text(
                "Registrat ara",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
  void iniciasesio(){
    print("Has iniciat sessió");
  }
}