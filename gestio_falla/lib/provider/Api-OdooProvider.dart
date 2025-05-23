import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/entities/event.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/domain/repository/Api-Odoo_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiOdooProvider with ChangeNotifier {
  final ApiOdooRepository _apiOdooRepository;

  ApiOdooProvider(this._apiOdooRepository);

  // Estat general
  String _message = "";
  int? _uid;
  bool _loading = false;
  String? _error;
  String _status = "";
  Faller? _usuariActual;

  // Datos cargados
  List<dynamic> fallers = [];
  List<Event> events = [];
  List<dynamic> families = [];
  List<dynamic> productes = [];
  List<dynamic> tickets = [];
  List<dynamic> cobradors = [];

  // Getters
  String get message => _message;
  int? get uid => _uid;
  bool get loading => _loading;
  String? get error => _error;
  String get status => _status;
  Faller? get usuariActual => _usuariActual;

  // Funcions internes per al estat
  void _setStatus(String status) {
    _status = status;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _message = 'Error: $error';
    _error = error;
    notifyListeners();
  }

  Future<void> saluda() async {
    _setLoading(true);
    try {
      final result = await _apiOdooRepository.saluda();
      _setStatus(result['missatge']);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getFallers() async {
    _setLoading(true);
    _setStatus("Carregant fallers...");
    try {
      final result = await _apiOdooRepository.getFallers();
      fallers = result ?? [];
      _setStatus("Usuaris carregats: ${fallers.length}");
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getPerfil(String id) async {
    _setLoading(true);
    _setStatus("Carregant perfil...");
    try {
      await _apiOdooRepository.getPerfil(id: id);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getMostraQR(String id) async {
    _setLoading(true);
    _setStatus("Carregant QR...");
    try {
      await _apiOdooRepository.getMostraQR(id: id);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getMostraMembres(String idFamilia) async {
    _setLoading(true);
    _setStatus("Carregant membres...");
    try {
      await _apiOdooRepository.getMostraMembres(idFamilia: idFamilia);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> postFaller({
    required String nom,
    required String rol,
    required String valorPulsera,
  }) async {
    _setLoading(true);
    _setStatus("Creant faller...");
    try {
      await _apiOdooRepository.postFaller(nom: nom, rol: rol, valorPulsera: valorPulsera);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> canviaNom({required String id, required String nouNom}) async {
    _setLoading(true);
    _setStatus("Canviant nom...");
    try {
      await _apiOdooRepository.canviaNom(id: id, nouNom: nouNom);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
  Future<String?> getFallerValorPulseraByName(String nom) async {
    try {
      final fallers = await _apiOdooRepository.getFallers();
      final faller = fallers!.firstWhere((f) => f.nom.toLowerCase() == nom.toLowerCase(), orElse: () => null);
      return faller?.id?.toString();
    } catch (e) {
      _setError("Error buscant faller: $e");
      return null;
    }
  }


  Future<void> canviaRol({required String id, required String rol}) async {
    _setLoading(true);
    _setStatus("Canviant rol...");
    try {
      await _apiOdooRepository.canviaRol(id: id, rol: rol);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> assignarFamilia({required String id, required String idFamilia}) async {
    _setLoading(true);
    _setStatus("Assignant familia...");
    try {
      await _apiOdooRepository.assignarFamilia(id: id, idFamilia: idFamilia);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> borrarFaller(String valorPulsera) async {
    _setLoading(true);
    _setStatus("Borrant faller...");
    try {
      await _apiOdooRepository.borrarFaller(valorPulsera: valorPulsera);
      _setStatus("Faller borrat");
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }


  Future<void> getEvents() async{
    _setLoading(true);
    _setStatus("Carregant events...");

    try {
      final result = await _apiOdooRepository.getEvents();
      events = (result ?? []).cast<Event>();
      _setStatus("Events carregats: ${events.length}");
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> getEventsDetallats(String id) async{
    _setLoading(true);
    _setStatus("Carregant l'event detallat...");
    try{
      await _apiOdooRepository.getEventsDetallats(id: id);
      _setStatus("Event carregat");
    }catch (e){
      _setError(e.toString());
    }finally{
      _setLoading(false);
    }
  }

  Future<void> getLlistaEvents() async{
    _setLoading(true);
    _setStatus("Carregant la llista d'events...");

    try {
      final result = await _apiOdooRepository.getEvents();
      events = (result ?? []).cast<Event>();
      _setStatus("Events carregats: ${events.length}");
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> postEvents({ required String nom, required DateTime dataInici, required DateTime dataFi, String? desc}) async{
    _setLoading(true);
    _setStatus("Creant event...");
    try{
      await _apiOdooRepository.postEvents(nom: nom, dataInici: dataInici, dataFi: dataFi, desc: desc);
      _setStatus("Event creat");
      //Pendent
    } catch(e){
      _setError(e.toString());
    }finally{
      _setLoading(false);
    }
  }

  Future<void> borrarEvent(String nom) async{
    _setLoading(true);
    _setStatus("Borrant event...");
    try{
      await _apiOdooRepository.borrarEvent(nom: nom);
      _setStatus("Event borrat");
    }catch (e){
      _setError(e.toString());
    }finally{
      _setLoading(false);
    }
  }

  Future<void> getFamilies() async{
    _setLoading(true);
    _setStatus("Carregant families...");
    try{
      final result = await _apiOdooRepository.getFamilies();
      families = result ?? [];
      _setStatus("Families carregades:${families.length}");
    }catch (e){
      _setError(e.toString());
    }finally{
      _setLoading(false);
    }
  }

  Future<void> postFamilies(String nom) async{
    _setLoading(true);
    _setStatus("Creant familia");

    try{
      await _apiOdooRepository.postFamilies(nom: nom);
      _setStatus("Familia creada");
    } catch(e){
      _setError(e.toString());
    }finally{
      _setLoading(false);
    }
  }

  Future<void> borrarFamilia(String nom) async{
    _setLoading(true);
    _setStatus("Borrant familia...");
    try{
      await _apiOdooRepository.borrarFamilia(nom: nom);
      _setStatus("Familia borrada");
    }catch (e){
      _setError(e.toString());
    }finally{
      _setLoading(false);
    }
  }

  Future<void> getProductes() async{
    _setLoading(true);
    _setStatus("Carregant productes");
    
    try{
      final result = await _apiOdooRepository.getProductes();
      productes = result ?? [];
      _setStatus("Productes carregats:${productes.length}");
    }catch(e){
      _setError(e.toString());
    }finally{
      _setLoading(false);
    }
  }

  Future<void> getProductesBarra() async{
    _setLoading(true);
    _setStatus("Carregant els productes de la barra");
    try{
      final result = await _apiOdooRepository.getProductes();
      productes = result ?? [];
      _setStatus("Productes carregats:${productes.length}");
    }catch(e){
      _setError(e.toString());
    }finally{
      _setLoading(false);
    }
  }

  Future<void> postProducte(String nom, double preu, int stock, String imatgeUrl) async{
    _setStatus("Creant producte...");
    try{
      await _apiOdooRepository.postProducte(nom: nom, preu: preu, stock: stock, imatgeUrl: imatgeUrl);
      _setStatus("Producte creat");
    } catch(e){
      _setError(e.toString());
    }finally{
      _setLoading(false);
    }
  }

  Future<void> borrarProducte(String nom) async{
    _setLoading(true);
    _setStatus("Borrant producte...");
    try{
      await _apiOdooRepository.borrarProducte(nom: nom);
      _setStatus("Producte borrat");
    } catch (e){
      _setError(e.toString());
    }finally{
      _setLoading(false);
    }
  }

  Future<void> getTickets() async{
    _setLoading(true);
    _setStatus("Carregant Tickets...");
    
    try{
      final result= await _apiOdooRepository.getTickets();
      tickets = result ?? [];
      _setStatus("Tickets carregats:${tickets.length}");
    }catch(e){
      _setError(e.toString());
    }finally{
      _setLoading(false);
    }
  }

  Future<void> postTickets(int quantitat, double preu, bool maxim) async{
    _setLoading(true);
    _setStatus("Creant ticket...");
    try{
      await _apiOdooRepository.postTickets(quantitat: quantitat, preu: preu, maxim: maxim);
      _setStatus("Tickets creats");
    }catch (e){
      _setError(e.toString());
    }finally{
      _setLoading(false);
    }
  }
  Future<void> borrarTicket(String id) async{
    _setLoading(true);
    _setStatus("Borrant ticket...");
    try{
      await _apiOdooRepository.borrarTicket(id: id);
      _setStatus("Ticket borrat");
    }catch (e){
      _setError(e.toString());
    }finally{
      _setLoading(false);
    }
  }

  Future<void> getCobradors() async{
    _setLoading(true);
    _setStatus("Carregant cobradors");
    try{
      final result = await _apiOdooRepository.getCobradors();
      cobradors = result ?? [];
      _setStatus("Cobradors carregats:${cobradors.length}");
    }catch(e){
      _setError(e.toString());
    }finally{
      _setLoading(false);
    }
  }

  Future<void> postCobrador(String rolCobrador) async{
    _setLoading(true);
    _setStatus("Afegint cobrador...");
    try{
      await _apiOdooRepository.postCobrador(rolCobrador: rolCobrador);
      _setStatus("Cobrador afegit");
    }catch (e){
      _setError(e.toString());
    }finally{
      _setLoading(false);
    }
  }

  Future<void> borrarCobrador(String rolCobrador) async{
    _setLoading(true);
    _setStatus("Borrant cobrador");
    try{
      await _apiOdooRepository.borrarCobrador(rolCobrador: rolCobrador);
      _setStatus("Cobrador borrat");
    }catch (e){
      _setError(e.toString());
    }finally{
      _setLoading(false);
    }
  }

  Future<Faller?> verificarUsuari(String nom, String valorPulsera) async {
    _setLoading(true);
    _setStatus("loguejant...");

    try {
      final faller = await _apiOdooRepository.verificarUsuari(nom: nom, valorPulsera: valorPulsera);
      
      if (faller != null) {
        _usuariActual = faller as Faller?;
        _setStatus("loguejat");

        //Guarda les dades a SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('estaLoguejat', true);
        await prefs.setString('nom', faller.nom);
        await prefs.setString('rol', faller.rol);
        await prefs.setString('pulsera', faller.valorPulsera);
        await prefs.setBool('teLimit', faller.teLimit);

        notifyListeners();
        return _usuariActual;
      }

      return null;
    } catch (e) {
      _error = e.toString();
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> tancaSessio() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('nom');
    await prefs.remove('valorPulsera');
    _usuariActual = null;
    notifyListeners();
  }

Future<void> guardarFaller(Faller faller) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setString('usuariLoguejat', jsonEncode(faller.toJSON()));
}

}