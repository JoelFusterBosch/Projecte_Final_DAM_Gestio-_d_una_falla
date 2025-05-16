import 'package:flutter/material.dart';
import 'package:gestio_falla/presentation/screens/principal_screen.dart';
import 'package:gestio_falla/presentation/screens/registrar_usuari.dart';

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
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints){
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Image.asset(
                          'lib/assets/FallaPortal.png',
                          fit: BoxFit.fill,
                        ),
                      ),
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
                      ElevatedButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => PrincipalScreen()
                          )
                        );
                      }, child: Text("Iniciar sessió")),
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
              ),
            );
          }
        ),
      ),
    );
  }  
}