import 'dart:convert';
import 'package:http/http.dart' as http;

class FakeApiOdooDataSource {
  final String baseUrl;
  final String db;

  FakeApiOdooDataSource({required this.baseUrl, required this.db});
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
  /*
  Fallers 
  */

  Future<List<dynamic>?> getFallers() async {
    final url = Uri.parse('$baseUrl/fallers');
    final response = await http.get(url);
    if(response.statusCode==200){
      final data = jsonDecode(response.body);
      return data['result'];
    }else{
      throw Exception("Error al conectar al servidor");
    }
  }
  /*
  Events 
  */

  Future<List<dynamic>?> getEvents() async {
    final url = Uri.parse('$baseUrl/events');
    final response = await http.get(url);
    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return data['result'];
    }else{
      throw Exception('Error al conectar al servidor');
    }
  }
  
  /*
  Familia
  */
  Future<List<dynamic>?> getFamilies() async{
    final url = Uri.parse('$baseUrl/families');
    final response = await http.get(url);
    if(response.statusCode==200){
      final data = jsonDecode(response.body);
      return data['result'];
    }else{
      throw Exception("Error a l'hora de conectar al servidor");
    }
  }
  /*
  tickets
  */
  Future<List<dynamic>?> getTickets() async{
    final url = Uri.parse('$baseUrl/tickets');
    final response = await http.get(url);
    if(response.statusCode==200){
      final data = jsonDecode(response.body);
      return data['result'];
    }else{
      throw Exception("Error a l'hora d'obtindre els tickets");
    }
  }
  /*
  Productes  
  */
  Future<List<dynamic>?> getProductes() async{
    final url = Uri.parse('$baseUrl/productes');
    final response = await http.get(url);
    if(response.statusCode==200){
      final data = jsonDecode(response.body);
      return data['result'];
    }else{
      throw Exception("Error a l'hora d'obtindre els productes");
    }
  }
  /*
  Cobrador
  */
  Future<List<dynamic>?> getCobradors() async{
    final url = Uri.parse('$baseUrl/cobrador');
    final response = await http.get(url);
    if(response.statusCode==200){
      final data = jsonDecode(response.body);
      return data['result'];
    }else{
      throw Exception("Error a l'hora d'obtindre als cobradors");
    }
  }
}
