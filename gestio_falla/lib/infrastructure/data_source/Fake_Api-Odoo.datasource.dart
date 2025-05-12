import 'dart:convert';
import 'package:http/http.dart' as http;

class FakeApiOdooDataSource {
  final String baseUrl;
  final String db;

  FakeApiOdooDataSource({required this.baseUrl, required this.db});

  Future<int?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/');
    
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "service": "common",
          "method": "login",
          "args": [db, email, password],
        },
        "id": 1,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final result = data['result'];
      if (result != null && result is int && result > 0) {
        return result;
      } else {
        print('Login fallido o UID inválido. Result: $result');
        return null;
      }
    } else {
      print('Error HTTP: ${response.statusCode}');
      return null;
    }
  }

  Future<List<dynamic>?> getUsers(int uid, String password) async {
    final url = Uri.parse('$baseUrl/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "jsonrpc": "2.0",
        "method": "call",
        "params": {
          "service": "object",
          "method": "execute_kw",
          "args": [
            db,
            uid,
            password,
            'res.users',
            'search_read',
            [],
            {'fields': ['id', 'name', 'login']}
          ],
        },
        "id": 2
      }),
    );
    final data = jsonDecode(response.body);
    return data['result'];
  }

  Future<List<dynamic>?> getEvents() async {
    final url = Uri.parse('$baseUrl/events');
    final response = await http.get(url);
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return data['mensaje'];
    }else{
      throw Exception('Error al conectar al servidor');
    }
  }
  Future<String> saluda() async{
    final url = Uri.parse('$baseUrl/saluda');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['mensaje'];
    } else {
      throw Exception('Error al conectar al servidor');
    }
  }
}
