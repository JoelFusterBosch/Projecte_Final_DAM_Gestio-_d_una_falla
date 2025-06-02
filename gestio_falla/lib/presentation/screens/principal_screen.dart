import 'package:flutter/material.dart';
//import 'package:gestio_falla/domain/entities/event.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/presentation/screens/admin_screen.dart';
import 'package:gestio_falla/presentation/screens/escaner.dart';
import 'package:gestio_falla/presentation/screens/events_screen.dart';
import 'package:gestio_falla/presentation/screens/login_screen.dart';
import 'package:gestio_falla/presentation/screens/perfil_screen.dart';


import 'package:gestio_falla/provider/Api-OdooProvider.dart';
import 'package:provider/provider.dart';

class PrincipalScreen extends StatefulWidget {
  final Faller? faller;

  const PrincipalScreen({super.key, required this.faller});

  @override
  State<PrincipalScreen> createState() => PrincipalScreenState();
}

class PrincipalScreenState extends State<PrincipalScreen> {
  int indexPantallaActual = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<ApiOdooProvider>(context, listen: false);
      provider.getLlistaEvents();  // Carrega la llista d'events del servidor
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiOdooProvider = Provider.of<ApiOdooProvider>(context);
    final config = _getConfiguracioPerRol(widget.faller!.rol, indexPantallaActual, apiOdooProvider);

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

  _ConfiguracioVista _getConfiguracioPerRol(String rol, int index, ApiOdooProvider apiOdooProvider) {
    if (rol == "Faller" || rol == "Cap de familia") {
      return _ConfiguracioVista(
        pantalles: [
          EventsScreen(totsElsEvents: apiOdooProvider.events),
          PerfilScreen(faller: widget.faller),
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
        ],
        titolsAppBar: const [
          Text('Events'),
          Text('Perfil'),
        ],
      );
    } else if (rol == "Cobrador") {
      return _ConfiguracioVista(
        pantalles: [
          Escaner(),
          PerfilScreen(faller: widget.faller),
        ],
        navegacio: [
          NavigationDestination(
            icon: Icon(index == 0 ? Icons.scanner : Icons.scanner_outlined),
            label: 'Escaner',
          ),
          NavigationDestination(
            icon: Icon(index == 1 ? Icons.account_circle : Icons.account_circle_outlined),
            label: 'Perfil',
          ),
        ],
        titolsAppBar: const [
          Text("Escaner"),
          Text("Perfil"),
        ],
      );
    } else if (rol == "Administrador") {
      return _ConfiguracioVista(
        pantalles: [
          EventsScreen(totsElsEvents: apiOdooProvider.events),
          AdminScreen(),
          PerfilScreen(faller: widget.faller),
        ],
        navegacio: [
          NavigationDestination(
            icon: Icon(index == 0 ? Icons.event : Icons.event_outlined),
            label: 'Events',
          ),
          NavigationDestination(
            icon: Icon(index == 1 ? Icons.admin_panel_settings : Icons.admin_panel_settings_outlined),
            label: 'Administrador',
          ),
          NavigationDestination(
            icon: Icon(index == 2 ? Icons.account_circle : Icons.account_circle_outlined),
            label: 'Perfil',
          ),
        ],
        titolsAppBar: const [
          Text("Events"),
          Text("Admin"),
          Text("Perfil"),
        ],
      );
    } else if (rol == "SuperAdmin") {
      return _ConfiguracioVista(
        pantalles: [
          EventsScreen(totsElsEvents: apiOdooProvider.events),
          PerfilScreen(faller: widget.faller),
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
