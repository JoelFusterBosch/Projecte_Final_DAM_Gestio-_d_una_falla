abstract class ApiOdooRepository {
  Future<int?> login(String email, String password);
  Future<List<dynamic>?> getUsers(int uid, String password);
  Future<List<dynamic>?> getEvents(int uid, String password);
  Future<String> saluda();
}
