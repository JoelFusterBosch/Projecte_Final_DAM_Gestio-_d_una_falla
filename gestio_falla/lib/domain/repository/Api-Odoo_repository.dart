abstract class ApiOdooRepository {
  Future<int?> login(String email, String password);
  Future<List<dynamic>?> getUsers(int uid, String password);
}
