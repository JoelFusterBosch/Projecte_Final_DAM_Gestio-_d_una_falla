import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/cobrador.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/presentation/screens/admin_screen.dart';
import 'package:gestio_falla/presentation/screens/escaner.dart';
import 'package:gestio_falla/presentation/screens/events_screen.dart';
import 'package:gestio_falla/presentation/screens/login_screen.dart';
import 'package:gestio_falla/presentation/screens/perfil_screen.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => PrincipalScreenState();
}

class PrincipalScreenState extends State<PrincipalScreen> {
  late int indexPantallaActual;
  late Faller faller=Faller(
    nom: "Joel",
    rol: "Administrador", 

  );
  late List<Widget> pantalles;
  late List<NavigationDestination> navegacio;
  late List<Widget> titolsAppBar;

  @override
  void initState() {
    super.initState();
    indexPantallaActual=0;
    configurarVistaPerRol();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //Usuari
      appBar: AppBar(title: titolsAppBar[indexPantallaActual] ),
      bottomNavigationBar: navegacio.length >= 2
      ? NavigationBar(
          onDestinationSelected: (int index) {
            setState(() {
              indexPantallaActual = index;
            });
          },
          selectedIndex: indexPantallaActual,
          destinations: navegacio,
      )
    : null, // no mostra barra si n'hi han menys de 2 ítems,
      body: pantalles[indexPantallaActual],
    );
  }
  
  void configurarVistaPerRol() {
    if(faller.rol=="Faller"){
      pantalles=[
        const EventsScreen(),
        const PerfilScreen(),
        const LoginScreen(),
      ];
      navegacio=[
        NavigationDestination(icon: Icon(indexPantallaActual == 0 ? Icons.event_outlined : Icons.event), label: 'Events'),
        NavigationDestination(icon: Icon(indexPantallaActual == 2 ? Icons.account_circle_outlined : Icons.account_circle), label: 'Perfil'),
        NavigationDestination(icon: Icon(indexPantallaActual == 3 ? Icons.login_outlined : Icons.login), label: 'Login'),
      ];
      titolsAppBar = const [
        Text('Events'),
        Text('Perfil'),
        Text('Login'),
      ];
    }else if(faller.rol=="Cobrador"){
      pantalles=[
        const Escaner(),
      ];
      navegacio=[
        NavigationDestination(icon: Icon(Icons.scanner), label: 'Escaner')
      ];
      titolsAppBar = const [
        Text("Escaner"),
      ];
    }else if(faller.rol=="Administrador"){
      //TO-DO
      pantalles=[
        AdminScreen(),
      ];
      navegacio=[
        NavigationDestination(icon: Icon(Icons.login), label: 'Login')
      ];
      titolsAppBar = const [
        Text("Admin"),
      ];
    }
  } 
  
}

