import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/repository/Api-Odoo_repository.dart';
import 'package:gestio_falla/infrastructure/data_source/Api-Odoo_datasource.dart';
import 'package:gestio_falla/infrastructure/repository/Api-Odoo_repository_impl.dart';

class AdminScreen extends StatefulWidget{
  @override
  State<AdminScreen> createState() => AdminScreenState();

}
class AdminScreenState extends State<AdminScreen>{
  late String missatge;
  late final ApiOdooRepository apiOdooRepository;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    missatge="";
    apiOdooRepository=ApiOdooRepositoryImpl(ApiOdooDataSource(baseUrl: 'http://192.168.125.26:8069', db: 'Projecte_Falla'));
  }
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
              Text(missatge),
              ElevatedButton(onPressed:login, child: Text("Login")),
            ]
          )
        ) 
      )
    );
  }
void login() async {
  setState(() {
    missatge="Iniciar sessió";
  });
  final odoo = apiOdooRepository;

  final uid = await odoo.login('odoo@odoo.com', '1234');

  if (uid != null) {
    setState(() {
      missatge="Login executat correctament";
    });
  } else {
    setState(() {
      missatge="Fallo el login";
    });
  }
}
}