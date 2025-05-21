import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/domain/entities/familia.dart';
import 'package:gestio_falla/infrastructure/data_source/Fake_Api-Odoo.datasource.dart';
import 'package:gestio_falla/infrastructure/repository/Api-Odoo_repository_impl.dart';
import 'package:gestio_falla/presentation/screens/afegir_membre.dart';
import 'package:gestio_falla/presentation/screens/crear_familia.dart';
import 'package:gestio_falla/presentation/screens/editar_perfil.dart';
import 'package:gestio_falla/presentation/screens/login_screen.dart';
import 'package:gestio_falla/presentation/screens/mostra_QR_screen.dart';
import 'package:gestio_falla/provider/Api-OdooProvider.dart';


class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => PerfilScreenState();
}

class PerfilScreenState extends State<PerfilScreen> {
  late final FakeApiOdooDataSource fakeApiOdooDataSource;
  late final ApiOdooRepositoryImpl apiOdooRepository;
  late final ApiOdooProvider apiProvider;
  Faller faller = Faller(
    nom: "Joel",
    familia: Familia(nom: "Família de Joel"), 
    rol: "Cap de familia",
    valorPulsera: "8430001000017",
    teLimit: false,
    estaLoguejat: true,
  );

  @override
  void initState(){
    super.initState();
    fakeApiOdooDataSource = FakeApiOdooDataSource(baseUrl: "http://192.168.1.15:3000", db: "Projecte_Falla");
    apiOdooRepository = ApiOdooRepositoryImpl(fakeApiOdooDataSource);
    apiProvider = ApiOdooProvider(apiOdooRepository);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("lib/assets/perfil.jpg"),
                        ),
                        SizedBox(height: 10),
                        Text(
                          faller.nom,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          faller.rol,
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          faller.familia!=null ? faller.familia!.nom : "Familia no assignada",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 20),
                        Offstage(
                          offstage: faller.rol!="Cap de familia" && faller.familia==null,
                          child: ElevatedButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>AfegirMembre()));
                          }, 
                          child: Text("Agregar membre")
                          ),
                        ),
                        Offstage(
                          offstage: faller.rol=="Cap de familia" && faller.familia!=null,
                          child: ElevatedButton(onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>CrearFamilia()));
                          }, 
                          child: Text("Crear familia")
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => EditarPerfil())
                          );
                        },
                          icon: Icon(Icons.edit),
                          label: Text("Editar Perfil"),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context, 
                              MaterialPageRoute(builder: (context) => MostraQrScreen(faller:faller))
                            );
                          },
                          icon: Icon(Icons.qr_code),
                          label: Text("Mostrar QR"),
                        ),
                        SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: () {
                          tancarSessio(context);
                          },
                          icon: Icon(Icons.logout, color: Colors.red),
                          label: Text("Tancar sessió"),
                          style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
  void tancarSessio(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Vols tancar sessió?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel·lar'),
          ),
          TextButton(
            onPressed: () async {
              // Crida al logout i després redirigeix
              final provider = ApiOdooProvider(apiOdooRepository); 
              await provider.tancaSessio();

              if (context.mounted) {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              }
            },
            child: const Text('Tancar sessió'),
          ),
        ],
      );
    },
  );
}

}