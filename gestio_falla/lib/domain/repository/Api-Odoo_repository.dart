abstract class ApiOdooRepository {
  /* Descomentar quan vaja a fer peticions per l'API de Odoo
  Future<int?> login(String email, String password);
  Future<List<dynamic>?> getUsers(int uid, String password);
  
  Future<List<dynamic>?> getEvents(int uid, String password);
  */
  Future<List<dynamic>?> getFallers();
  Future<List<dynamic>?> getEvents();
  Future<String> saluda();
  Future<List<dynamic>?> getFamilies();
}