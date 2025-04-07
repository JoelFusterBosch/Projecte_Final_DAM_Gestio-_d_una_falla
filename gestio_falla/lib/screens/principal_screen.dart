import 'package:flutter/material.dart';
import 'package:gestio_falla/screens/events_screen.dart';
import 'package:gestio_falla/screens/llegir_i_escriure_nfc_screen.dart';
import 'package:gestio_falla/screens/perfil_screen.dart';

class PrincipalScreen extends StatefulWidget {
  const PrincipalScreen({super.key});

  @override
  State<PrincipalScreen> createState() => PrincipalScreenState();
}

class PrincipalScreenState extends State<PrincipalScreen> {
  late int indexPantallaActual;

  @override
  void initState() {
    super.initState();
    indexPantallaActual=0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:[
        const Text('Events'),
        const Text('Llegir i Escriure NFC'),
        const Text('Perfil'),
        ][indexPantallaActual] ),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
            setState(() {
              indexPantallaActual = index;
            });
        },
        selectedIndex: indexPantallaActual,
        destinations: <Widget>[
          NavigationDestination(
            icon: Icon(indexPantallaActual == 0 ? Icons.event : Icons.event_outlined),
            label: 'Events',
          ),
           NavigationDestination(
            icon: Icon(indexPantallaActual == 1 ? Icons.nfc : Icons.nfc_outlined),
            label: 'Llegir NFC',
          ),
          NavigationDestination(
            label: 'Perfil',
            icon: Icon(indexPantallaActual == 2 ? Icons.account_circle : Icons.account_circle_outlined,),
          ),
        ],
      ),
      body: <Widget>[
              const EventsScreen(),
              const LlegirIEscriureNfcScreen(),
              const PerfilScreen(),
              ][indexPantallaActual],
    );
  } 
}

