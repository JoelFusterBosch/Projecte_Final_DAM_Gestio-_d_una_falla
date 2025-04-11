import 'dart:convert'; // Per a utf8 i jsondecode
import 'dart:io'; // Per a HttpStatus
import 'package:http/http.dart'
    as http; // Importem la llibreria http l'àlias http

class EventsService {
  static Future<List<dynamic>> obtenirEvents({
    int a=0
  }) async {
    String urlBase = '';

    String url = "$urlBase";

    http.Response data = await http.get(Uri.parse(url));
    if (data.statusCode == HttpStatus.ok) {
      String body = utf8.decode(data.bodyBytes);
      final bodyJSON = jsonDecode(body);
      return bodyJSON[""]
          as List; // Retornem només la propietat "" com a llista
    } else {
      return [];
    }
  }
}
