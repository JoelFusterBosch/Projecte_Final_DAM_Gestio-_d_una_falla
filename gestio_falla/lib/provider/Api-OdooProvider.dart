import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/repository/Api-Odoo_repository.dart';

class  ApiOdooProvider with ChangeNotifier{
  final ApiOdooRepository _apiOdooRepository;

  ApiOdooProvider(this._apiOdooRepository);

  String _message="";
  int? _uid;
  bool _loading = false;
  String? _error;
  String status="";

  String get message => _message;
  int? get uid => _uid;
  bool get loading => _loading;
  String? get error => _error;

  List<dynamic>? users;
  List<dynamic>? events;

  Future<void> login(String email, String password) async {
    _message = "Iniciant sessió...";
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final result = await _apiOdooRepository.login(email, password);

      if (result != null) {
        _uid = result; 
        _message = "Login conseguit de forma exitosa. UID: $_uid";
      } else {
        _error = 'Credencials incorrectes';
        _message = _error!;
      }
    } catch (e) {
      _error = 'Error de connexió: $e';
      _message = _error!;
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> fetchUsers(String password) async {
    if (uid == null) {
      status = "UID no disponible. Fes login primer.";
      notifyListeners();
      return;
    }

    status = "Carregant usuaris...";
    notifyListeners();

    final result = await _apiOdooRepository.getUsers(uid!, password);
    if (result != null) {
      users = result;
      status = "Usuaris carregats: ${users!.length}";
    } else {
      status = "Error a l'hora d'obtindre usuaris.";
    }

    notifyListeners();
  }
  Future<void> getEvents(String password) async{
    if (uid == null) {
      status = "UID no disponible. Fes login primer.";
      notifyListeners();
      return;
    }

    status = "Carregant events...";
    notifyListeners();

    final result = await _apiOdooRepository.getEvents(uid!, password);
    if (result != null) {
      events = result;
      status = "Events carregats: ${events!.length}";
    } else {
      status = "Error a l'hora d'obtindre els events.";
    }

    notifyListeners();
  }
}