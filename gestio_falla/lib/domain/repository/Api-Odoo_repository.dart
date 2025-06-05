import 'package:gestio_falla/domain/entities/event.dart';
import 'package:gestio_falla/domain/entities/faller.dart';

abstract class ApiOdooRepository {
  /* Descomentar quan vaja a fer peticions per l'API de Odoo
  Future<int?> login(String email, String password);
  Future<List<dynamic>?> getUsers(int uid, String password);
  
  Future<List<dynamic>?> getEvents(int uid, String password);
  */
  //Fallers
  Future<List<dynamic>?> getFallers();
  Future<List<dynamic>?> getMostraMembres({required String idFamilia});
  Future<Faller?> getMembrePerValorPolsera(String valorPolsera);
  Future<Map<String,dynamic>> postFaller({required String nom, required String rol, required String valorPulsera});
  Future<Map<String,dynamic>> canviaNom({required String id, required String nouNom});
  Future<Map<String,dynamic>> assignarFamilia({required String valorPulsera, required String idFamilia});
  Future<Map<String,dynamic>> canviaRol({required String id, required String rol});
  Future<void> borrarFaller({required String valorPulsera});
  //Events
  Future<List<dynamic>?> getEvents();
  Future<Event?> getEvent(String nom);
  Future<Map<String,dynamic>> postEvents({required String nom, required DateTime dataInici, required DateTime dataFi, String? desc});
  Future<void> borrarEvent({required String nom});
  //Families
  Future<List<dynamic>?> getFamilies();
  Future<Map<String,dynamic>> postFamilies({required String nom});
  Future<void> borrarFamilia({required String nom});
  //Tickets
  Future<List<dynamic>?> getTickets();
  Future<Map<String,dynamic>> postTickets({required int quantitat,required double preu});
  Future<void> borrarTicket({required String id});
  //Productes
  Future<List<dynamic>?> getProductes();
  Future<List<dynamic>?> getProductesBarra();
  Future<Map<String,dynamic>> postProducte({required String nom, required double preu, required int stock, required String imatgeUrl});
  Future<void> borrarProducte({required String nom});
  //Cobrador
  Future<List<dynamic>?> getCobradors();
  Future<Map<String,dynamic>> postCobrador({required String rolCobrador});
  Future<void> borrarCobrador({required String rolCobrador});
  //Verificar usuari
  Future<Faller?> verificarUsuari({required nom, required valorPulsera});
}