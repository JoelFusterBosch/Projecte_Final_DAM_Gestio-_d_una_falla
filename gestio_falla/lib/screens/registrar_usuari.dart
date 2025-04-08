import 'package:flutter/material.dart';
import 'package:gestio_falla/screens/login_screen.dart';

class RegistrarUsuari extends StatefulWidget{
  const RegistrarUsuari({super.key});

  @override
  State<RegistrarUsuari> createState() => RegistrarUsuariState();

}

class RegistrarUsuariState extends State<RegistrarUsuari>{
  String diaSeleccionat="1";
  String mesSeleccionat="Gener";
  String anySeleccionat="2000";
  final List<String> dies = List.generate(31, (index) => (index + 1).toString());
  final List<String> mesos = [
    'Gener', 'Febrer', 'Març', 'Abril', 'Maig', 'Juny', 'Juliol', 'Agost',
    'Septembre', 'Octubre', 'Novembre', 'Decembre'
  ];
  final List<String> anys = List.generate(100, (index) => (2024 - index).toString());
  String rol="Usuari";
  final List<String> rols=['Usuari','Cobrador','Administrador'];
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Registrar usuari"),
        centerTitle: true,
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                DropdownButton<String>(
                  value: diaSeleccionat,
                  onChanged: (String? newValue){
                    setState(() {
                      diaSeleccionat=newValue!;
                    });
                  },
                  items: dies.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(), 
                ),
                DropdownButton<String>(
                  value: mesSeleccionat,
                  onChanged: (String? newValue){
                    setState(() {
                      mesSeleccionat=newValue!;
                    });
                  },
                  items: mesos.map<DropdownMenuItem<String>>((String value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                ),
                SizedBox(
                  width: 10,
                ),
                DropdownButton<String>(
                  value: anySeleccionat,
                  onChanged: (String? newValue){
                    setState(() {
                      anySeleccionat=newValue!;
                    });
                  },
                  items: anys.map<DropdownMenuItem<String>>((String value){
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                )
              ],
            ),
            Text("Contrasenya"),
            TextFormField(
              keyboardType: TextInputType.text,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15)
                ),
                labelText:"Contrasenya", 
              ),
              validator: (value) {
                if(value==null || value.isEmpty){
                  return "El camp Contrasenya és obligatori";
                }
                return null;
              },
            ),
            DropdownButton<String>(
                  value: rol,
                  onChanged: (String? newValue){
                    setState(() {
                      rol=newValue!;
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
    );
  }
  
}