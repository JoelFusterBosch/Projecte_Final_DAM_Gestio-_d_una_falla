import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:gestio_falla/domain/repository/Api-Odoo_repository.dart';
// import 'package:gestio_falla/infrastructure/data_source/Api-Odoo_datasource.dart';
import 'package:gestio_falla/infrastructure/data_source/Fake_Api-Odoo.datasource.dart';

class ApiOdooRepositoryImpl implements ApiOdooRepository {
  final FakeApiOdooDataSource fakeApiOdooDataSource;

  ApiOdooRepositoryImpl(this.fakeApiOdooDataSource);

/*Descomentar quan vaja a fer peticions per l'API de Odoo
  @override
  Future<int?> login(String email, String password) async {
    return fakeApiOdooDataSource.login(email, password);
  }
  
  @override
  Future<List?> getUsers(int uid, String password) {
    return fakeApiOdooDataSource.getFallers(uid, password);
  }
  
   
  @override
  Future<List?> getEvents(int uid, String password) {
    return fakeApiOdooDataSource.getEvents(uid, password);
  }
*/
  @override
  Future<Map<String, dynamic>> saluda() {
    return fakeApiOdooDataSource.saluda();
  }

  /*
  Fallers
  */

  @override
  Future<List?> getFallers() {
    return fakeApiOdooDataSource.getFallers();
  }

  @override
  Future<Map<String, dynamic>> getMostraQR({required String id}) {
    return fakeApiOdooDataSource.getMostraQR(id);
  }
  
  @override
  Future<Map<String, dynamic>> getPerfil({required String id}) {
    return fakeApiOdooDataSource.getPerfil(id);
  }

  @override
  Future<List?> getMostraMembres({required String idFamilia}) {
    return fakeApiOdooDataSource.getMostraMembres(idFamilia);
  }

  @override
  Future<Map<String, dynamic>> postFaller({required String nom, required String rol, required String valorPulsera}) {
    return fakeApiOdooDataSource.postFaller(nom: nom, rol: rol, valorPulsera: valorPulsera);
  }

  @override
  Future<Map<String, dynamic>> canviaNom({required String id, required String nouNom}) {
    return fakeApiOdooDataSource.canviaNom(id, nouNom);
  }
  
  @override
  Future<Map<String, dynamic>> canviaRol({required String id, required String rol}) {
    return fakeApiOdooDataSource.canviaRol(id, rol);
  }

  @override
  Future<Map<String, dynamic>> assignarFamilia({required String id, required String idFamilia}) {
    return fakeApiOdooDataSource.asignarFamilia(id, idFamilia);
  }

  @override
  Future<void> borrarFaller({required String valorPulsera}) {
    return fakeApiOdooDataSource.borrarFaller(valorPulsera);
  }

  /*
  Events
  */

  @override
  Future<List?> getEvents() async {
    return fakeApiOdooDataSource.getEvents();
  }

  @override
  Future<Map<String, dynamic>> getEventsDetallats({required String id}) {
    return fakeApiOdooDataSource.getEventsDetallats(id);
  }

  @override
  Future<List?> getLlistaEvents() {
    return fakeApiOdooDataSource.getLlistaEvents();
  }

  @override
  Future<Map<String, dynamic>> postEvents({required String nom, required DateTime dataInici, required DateTime dataFi, String? desc}) {
    return fakeApiOdooDataSource.postEvents(nom: nom, dataInici: dataInici, dataFi: dataFi);
  }

  @override
  Future<void> borrarEvent({required String nom}) {
    return fakeApiOdooDataSource.borrarEvent(nom);
  }
  
  /*
  Families
  */

  @override
  Future<List?> getFamilies() {
    return fakeApiOdooDataSource.getFamilies();
  }

  @override
  Future<Map<String, dynamic>> postFamilies({required String nom}) {
    return fakeApiOdooDataSource.postFamilies(nom: nom);
  }

  @override
  Future<void> borrarFamilia({required String nom}) {
    return fakeApiOdooDataSource.borrarFamilia(nom);
  }

  /*
  Cobradors
  */
  
  @override
  Future<List?> getCobradors() {
    return fakeApiOdooDataSource.getCobradors();
  }

  @override
  Future<Map<String, dynamic>> postCobrador({required String rolCobrador}) {
    return fakeApiOdooDataSource.postCobrador(rolCobrador: rolCobrador);
  }

  @override
  Future<void> borrarCobrador({required String nom}) {
    return fakeApiOdooDataSource.borrarCobrador(nom);
  }

  /*
  Productes
  */
  
  @override
  Future<List?> getProductes() {
    return fakeApiOdooDataSource.getProductes();
  }

  @override
  Future<List?> getProductesBarra() {
    return fakeApiOdooDataSource.getProductesBarra();
  }
  
  @override
  Future<Map<String, dynamic>> postProducte({required String nom, required double preu, required int stock, required String imatgeUrl}) {
    return fakeApiOdooDataSource.postProducte(nom: nom, preu: preu, stock: stock, imatgeUrl: imatgeUrl);
  }

  @override
  Future<void> borrarProducte({required String nom}) {
    return fakeApiOdooDataSource.borrarProducte(nom);
  }

  /*
  Tickets
  */
  
  @override
  Future<List?> getTickets() {
    return fakeApiOdooDataSource.getTickets();
  }
  
  @override
  Future<Map<String, dynamic>> postTickets({required int quantitat, required double preu, required bool maxim}) {
    return fakeApiOdooDataSource.postTickets(quantitat: quantitat, preu: preu, maxim: maxim);
  }

  @override
  Future<void> borrarTicket({required String id}) {
    return fakeApiOdooDataSource.borrarTicket(id);
  }
  
  @override
  Future<Faller?> verificarUsuari({required nom, required valorPulsera}) async{
    return await fakeApiOdooDataSource.verificarUsuari(nom, valorPulsera);
  }
  
}
