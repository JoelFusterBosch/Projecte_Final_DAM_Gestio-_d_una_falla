import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/repository/Api-Odoo_repository.dart';

class ApiOdooProvider with ChangeNotifier {
  final ApiOdooRepository _apiOdooRepository;

  ApiOdooProvider(this._apiOdooRepository);

  // Estado general
  String _message = "";
  int? _uid;
  bool _loading = false;
  String? _error;
  String _status = "";

  // Datos cargados
  List<dynamic> fallers = [];
  List<dynamic> events = [];
  List<dynamic> families = [];
  List<dynamic> productes = [];
  List<dynamic> tickets = [];

  // Getters
  String get message => _message;
  int? get uid => _uid;
  bool get loading => _loading;
  String? get error => _error;
  String get status => _status;

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
      _message = await _apiOdooRepository.saluda();
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
      await getFallers();
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
      await getFallers();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> canviaRol({required String id, required String rol}) async {
    _setLoading(true);
    _setStatus("Canviant rol...");
    try {
      await _apiOdooRepository.canviaRol(id: id, rol: rol);
      await getFallers();
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
      await getFallers();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> borrarFaller(String id) async {
    _setLoading(true);
    _setStatus("Borrant faller...");
    try {
      await _apiOdooRepository.borrarFaller(id: id);
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
      events = result ?? [];
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
      events = result ?? [];
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

  Future<void> borrarEvent(String id) async{
    _setLoading(true);
    _setStatus("Borrant event...");
    try{
      await _apiOdooRepository.borrarEvent(id: id);
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

  Future<void> borrarFamilia(String id) async{
    _setLoading(true);
    _setStatus("Borrant familia...");
    try{
      await _apiOdooRepository.borrarFamilia(id: id);
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

  Future<void> borrarProducte(String id) async{
    _setLoading(true);
    _setStatus("Borrant producte...");
    try{
      await _apiOdooRepository.borrarProducte(id: id);
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
}