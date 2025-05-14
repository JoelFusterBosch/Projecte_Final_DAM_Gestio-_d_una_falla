import 'package:flutter/material.dart';
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
  int indexPantallaActual = 0;

  final Faller faller = Faller(
    nom: "Joel",
    rol: "SuperAdmin",
    valorPulsera: "8430001000017",
    teLimit: false
  );

  @override
  Widget build(BuildContext context) {
    final config = _getConfiguracioPerRol(faller.rol, indexPantallaActual);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: config.titolsAppBar[indexPantallaActual],
      ),
      bottomNavigationBar: config.navegacio.length >= 2
          ? NavigationBar(
              selectedIndex: indexPantallaActual,
              onDestinationSelected: (index) {
                setState(() {
                  indexPantallaActual = index;
                });
              },
              destinations: config.navegacio,
            )
          : null,
      body: config.pantalles[indexPantallaActual],
    );
  }

  _ConfiguracioVista _getConfiguracioPerRol(String rol, int index) {
    if (rol == "Faller" || rol == "Cap de familia") {
      return _ConfiguracioVista(
        pantalles: const [
          EventsScreen(),
          PerfilScreen(),
          LoginScreen(),
        ],
        navegacio: [
          NavigationDestination(
            icon: Icon(index == 0 ? Icons.event : Icons.event_outlined),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(index == 1 ? Icons.account_circle : Icons.account_circle_outlined),
            label: 'Perfil',
          ),
          NavigationDestination(
            icon: Icon(index == 2 ? Icons.login : Icons.login_outlined),
            label: 'Login',
          ),
        ],
        titolsAppBar: const [
          Text('Events'),
          Text('Perfil'),
          Text('Login'),
        ],
      );
    } else if (rol == "Cobrador") {
      return _ConfiguracioVista(
        pantalles: const [Escaner()],
        navegacio: [
          const NavigationDestination(
            icon: Icon(Icons.scanner),
            label: 'Escaner',
          )
        ],
        titolsAppBar: const [Text("Escaner")],
      );
    } else if (rol == "Administrador") {
      return _ConfiguracioVista(
        pantalles: const [AdminScreen()],
        navegacio: [
          const NavigationDestination(
            icon: Icon(Icons.admin_panel_settings),
            label: 'Administrador',
          )
        ],
        titolsAppBar: const [Text("Admin")],
      );
    } else if (rol == "SuperAdmin") {
      return _ConfiguracioVista(
        pantalles: const [
          EventsScreen(),
          PerfilScreen(),
          Escaner(),
          AdminScreen(),
        ],
        navegacio: [
          NavigationDestination(
            icon: Icon(index == 0 ? Icons.event : Icons.event_outlined),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(index == 1 ? Icons.account_circle : Icons.account_circle_outlined),
            label: 'Perfil',
          ),
          NavigationDestination(
            icon: Icon(index == 2 ? Icons.scanner : Icons.scanner_outlined),
            label: 'Escaner',
          ),
          NavigationDestination(
            icon: Icon(index == 3 ? Icons.admin_panel_settings : Icons.admin_panel_settings_outlined),
            label: 'Admin',
          ),
        ],
        titolsAppBar: const [
          Text('Events'),
          Text('Perfil'),
          Text('Escaner'),
          Text('Admin'),
        ],
      );
    } else {
      return _ConfiguracioVista(
        pantalles: const [LoginScreen()],
        navegacio: [
          const NavigationDestination(
            icon: Icon(Icons.login),
            label: 'Login',
          )
        ],
        titolsAppBar: const [Text("Login")],
      );
    }
  }
}

class _ConfiguracioVista {
  final List<Widget> pantalles;
  final List<NavigationDestination> navegacio;
  final List<Widget> titolsAppBar;

  _ConfiguracioVista({
    required this.pantalles,
    required this.navegacio,
    required this.titolsAppBar,
  });
}
