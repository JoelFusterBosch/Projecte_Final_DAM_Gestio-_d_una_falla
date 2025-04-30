import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/cobrador.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/presentation/screens/admin_screen.dart';
import 'package:gestio_falla/presentation/screens/escaner.dart';
import 'package:gestio_falla/presentation/screens/events_screen.dart';
import 'package:gestio_falla/presentation/screens/llegir_i_escriure_nfc_screen.dart';
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
    rol: "Cobrador", 
    cobrador: Cobrador(rolCobrador: "Cadires")
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
    : null, // no muestra barra si hay menos de 2 ítems,
      body: pantalles[indexPantallaActual],
    );
  }
  
  void configurarVistaPerRol() {
    if(faller.rol=="Faller"){
      pantalles=[
        const EventsScreen(),
        const LlegirIEscriureNfcScreen(),
        const PerfilScreen(),
        const LoginScreen(),
      ];
      navegacio=[
        NavigationDestination(icon: Icon(indexPantallaActual == 0 ? Icons.event_outlined : Icons.event), label: 'Events'),
        NavigationDestination(icon: Icon(indexPantallaActual == 1 ? Icons.nfc_outlined : Icons.nfc), label: 'Llegir NFC'),
        NavigationDestination(icon: Icon(indexPantallaActual == 2 ? Icons.account_circle_outlined : Icons.account_circle), label: 'Perfil'),
        NavigationDestination(icon: Icon(indexPantallaActual == 3 ? Icons.login_outlined : Icons.login), label: 'Login'),
      ];
      titolsAppBar = const [
        Text('Events'),
        Text('Llegir i Escriure NFC'),
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

