import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/presentation/screens/afegir_membre.dart';
import 'package:gestio_falla/presentation/screens/crear_familia.dart';
import 'package:gestio_falla/presentation/screens/editar_perfil.dart';
import 'package:gestio_falla/presentation/screens/login_screen.dart';
import 'package:gestio_falla/presentation/screens/mostra_QR_screen.dart';
import 'package:gestio_falla/provider/Api-OdooProvider.dart';
import 'package:provider/provider.dart';

class PerfilScreen extends StatefulWidget {
  final Faller? faller;
  const PerfilScreen({super.key, required this.faller});

  @override
  State<PerfilScreen> createState() => PerfilScreenState();
}

class PerfilScreenState extends State<PerfilScreen> {
  late ApiOdooProvider apiProvider;
  bool _isApiProviderInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isApiProviderInitialized) {
      apiProvider = Provider.of<ApiOdooProvider>(context);
      _isApiProviderInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    String? fotoPerfil = widget.faller!.imatgeurl;
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
                          backgroundImage: AssetImage(fotoPerfil ?? ""),
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.faller!.nom,
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.faller!.rol,
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          widget.faller!.familia_id != null ? widget.faller!.familia_id!.nom : "Familia no assignada",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        SizedBox(height: 20),
                        Offstage(
                          offstage: widget.faller!.rol != "Cap de familia" && widget.faller!.familia_id == null,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AfegirMembre(faller: widget.faller)));
                            },
                            child: Text("Agregar membre"),
                          ),
                        ),
                        Offstage(
                          offstage: widget.faller!.familia_id != null,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CrearFamilia()));
                            },
                            child: Text("Crear familia"),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => EditarPerfil(faller: widget.faller,)),
                            );
                          },
                          icon: Icon(Icons.edit),
                          label: Text("Editar Perfil"),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MostraQrScreen(faller: widget.faller)),
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
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("No has tancat la sessió"),
                    duration: Duration(seconds: 2),
                  ),
                );

                Navigator.of(context).pop();
              },
              child: const Text('Cancel·lar'),
            ),
            TextButton(
              onPressed: () async {
                await apiProvider.tancaSessio();

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sessió tancada correctament'),
                    duration: Duration(seconds: 2),
                  ),
                );

                await Future.delayed(const Duration(milliseconds: 600));

                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: const Text('Tancar sessió'),
            ),
          ],
        );
      },
    );
  }
}
