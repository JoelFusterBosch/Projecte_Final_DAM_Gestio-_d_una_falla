import 'package:flutter/material.dart';
import 'package:gestio_falla/infrastructure/data_source/Api-Odoo_datasource.dart';

class AdminScreen extends StatefulWidget{
  @override
  State<AdminScreen> createState() => AdminScreenState();

}
class AdminScreenState extends State<AdminScreen>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Escaner"),
      centerTitle: true,
      backgroundColor: Colors.orange,
      ),
      body: Center(child: Padding(
          padding: EdgeInsets.all(20.0),
          child:Column(
            mainAxisAlignment:MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed:login, child: Text("Login")),
            ]
          )
        ) 
      )
    );
  }
void login() async {
  final odoo = ApiOdooDataSource(
    baseUrl: 'http://localhost:8069',
    db: 'Projecte_Falla',
  );

  final uid = await odoo.login('odoo@odoo.com', '1234');

  if (uid != null) {
    Text("Login executat correctament");
  } else {
    Text("Fallo el login");
  }
}
}