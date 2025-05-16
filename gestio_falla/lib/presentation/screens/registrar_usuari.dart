import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/presentation/screens/login_screen.dart';

class RegistrarUsuari extends StatefulWidget{
  const RegistrarUsuari({super.key});

  @override
  State<RegistrarUsuari> createState() => RegistrarUsuariState();

}

class RegistrarUsuariState extends State<RegistrarUsuari>{
  final List<String> anys = List.generate(100, (index) => (2024 - index).toString());
  final List<String> rols=['Faller','Cobrador','Administrador'];
  Faller faller = Faller(nom: "", teLimit: false, rol: "Faller", valorPulsera: '0');
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar usuari"),
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
                child:Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Image.asset(
                          'lib/assets/FallaPortal.png',
                          fit: BoxFit.fill,
                        ),
                      ),
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
                      Text("Rol"),
                      DropdownButton<String>(
                            value: faller.rol,
                            onChanged: (String? newValue){
                              setState(() {
                                faller.rol=newValue!;
                              });
                            },
                            items: rols.map<DropdownMenuItem<String>>((String value){
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                      ElevatedButton(onPressed: (){
                        Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (context)=>LoginScreen()),
                        );
                      }, 
                      child: Text("Registrar-se")
                      ),
                    ],
                  ),
                ),
              )
            );
          }
        ),
      ),
    );         
  }         
}         