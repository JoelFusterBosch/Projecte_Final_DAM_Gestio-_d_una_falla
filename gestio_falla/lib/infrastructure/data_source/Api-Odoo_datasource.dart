import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiOdooDataSource {
  final String baseUrl;
  final String db;

  ApiOdooDataSource({required this.baseUrl, required this.db});

  /// Login function that returns the UID or null on failure
  Future<int?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/jsonrpc');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
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
      if (data['result'] != null) {
        return data['result']; // UID del usuario
      } else {
        print('Error en login: ${data['error']}');
        return null;
      }
    } else {
      print('Error HTTP: ${response.statusCode}');
      return null;
    }
  }
}
