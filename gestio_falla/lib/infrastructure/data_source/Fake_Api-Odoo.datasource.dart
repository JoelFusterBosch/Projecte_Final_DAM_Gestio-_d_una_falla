import 'dart:convert';
import 'package:gestio_falla/domain/entities/event.dart';
import 'package:gestio_falla/domain/entities/faller.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart' as httpClient;

class FakeApiOdooDataSource {
  final String baseUrl;
  final String db;

  FakeApiOdooDataSource({required this.baseUrl, required this.db});
  /*
  Fallers 
  */

  // Obté tots els fallers (GET)
  Future<List<dynamic>?> getFallers() async {
    final url = Uri.parse('$baseUrl/fallers');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error a l'hora d'obtindre als fallers");
    }
  }
  //Obté el faller per el id
  Future<Faller> getFaller(String id) async {
    final url = Uri.parse('$baseUrl/fallers/faller/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error a l'hora d'obtindre als fallers");
    }
  }

  // Obté membres d'una familia (GET)
  Future<List<dynamic>?> getMostraMembres(String idFamilia) async {
    final url = Uri.parse('$baseUrl/fallers/mostraMembres/$idFamilia');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception("No hay miembros en esta familia");
    } else {
      throw Exception("Error a l'hoar d'obtindre els membres de la familia");
    }
  }

  Future<Faller?> getMembrePerValorPolsera(String valorPulsera) async{
    try {
      // Exemple: crida GET a l’endpoint que filtra per 'valorpulsera' igual a valorPolsera
      final response = await httpClient.get(
        Uri.parse('$baseUrl/fallers/buscarPerPulsera/$valorPulsera'),
        headers: {
          'Authorization': 'Bearer token_o_auth',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data != null && data['results'] != null && data['results'].isNotEmpty) {
          // Convertir el primer resultat a entitat Faller
          return Faller.fromJSON(data['results'][0]);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Inserta un faller nou (POST)
  Future<Map<String, dynamic>> postFaller(
    {required String nom, required String rol, required String valorPulsera}) async {
    final url = Uri.parse('$baseUrl/fallers/insertar');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nom': nom,
        'rol': rol,
        'valorulsera': valorPulsera,
      }),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception("No s'ha pogut insertar al faller");
    }
  }

  // Canvia el nom d'un faller (PUT)
  Future<Map<String, dynamic>> canviaNom(String id, String nouNom) async {
    final url = Uri.parse('$baseUrl/fallers/canviaNom/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nom': nouNom}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error a l'hora de cambiar el nom");
    }
  }

  // Asigna una familia a un faller (PUT)
  Future<Map<String, dynamic>> asignarFamilia(String valorPulsera, String idFamilia) async {
    final url = Uri.parse('$baseUrl/fallers/familia/$idFamilia');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'familia': idFamilia}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error a l'hora d'asignar la familia");
    }
  }

  // Cambia el rol d'un faller (PUT)
  Future<Map<String, dynamic>> canviaRol(String id, String rol) async {
    final url = Uri.parse('$baseUrl/fallers/canviaRol/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'rol': rol}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error a l'hora de cambiar de rol");
    }
  }

  // Borra un faller (DELETE)
  Future<void> borrarFaller(String valorPulsera) async {
    final url = Uri.parse('$baseUrl/fallers/borrar/$valorPulsera');
    final response = await http.delete(url);
    if (response.statusCode == 200) {
      return;
    } else {
      throw Exception("Error a l'hora de borrar al faller");
    }
  }
  /*
  Events 
  */

  // Obté tots els events (GET)
  Future<List<dynamic>?> getEvents() async {
    final url = Uri.parse('$baseUrl/events');
    final response = await http.get(url);
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      throw Exception('Error al conectar al servidor');
    }
  }
  Future<Event?> getEvent(String nom) async {
    final url = Uri.parse('$baseUrl/events/event/$nom');
    final response = await http.get(url);
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      throw Exception('Error al conectar al servidor');
    }
  }
  
  // Inserta un nou event (POST)
  Future <Map<String, dynamic>> postEvents(
    {required String nom, required DateTime dataInici, required DateTime dataFi, String? desc }) async{
    final url = Uri.parse('$baseUrl/events/insertar');
    final response = await http.post(
    url,
    headers: {'Content-Type':'application/json'},
    body: jsonEncode({
      'nom': nom,
      'datainici': dataInici, 
      'datafi' : dataFi,
      'descripcio' : desc
      }),
    );
    if(response.statusCode == 201){
      return jsonDecode(response.body);
    }
    else{
      throw Exception("Error a l'hora d'insertar l'event");
    }
  }

  // Borra un event (DELETE)
  Future<void> borrarEvent(String nom) async{
    final url = Uri.parse('$baseUrl/events/borrar/$nom');
    final response = await http.delete(url);
    if(response.statusCode==200){
      return;
    }else{
      throw Exception("Error a l'hora de borrar l'event");
    }
  }

  /*
  Familia
  */

  // Obté totes les families (GET)
  Future<List<dynamic>?> getFamilies() async{
    final url = Uri.parse('$baseUrl/families');
    final response = await http.get(url);
    if(response.statusCode==200){
      return jsonDecode(response.body);
    }else{
      throw Exception("Error a l'hora de conectar al servidor");
    }
  }

  // Inserta una nova familia (POST)
  Future <Map<String, dynamic>> postFamilies(
  {required String nom}) async{
    final url = Uri.parse('$baseUrl/families/insertar');
    final response = await http.post(
      url,
      headers: {'Content-Type':'applicaton/json'},
      body: jsonEncode({
        'nom' : nom,
      }),
      );
    if(response.statusCode == 201){
      return jsonDecode(response.body);
    }else{
      throw Exception("Error a l'hora d'insertar a la familia");
    }
  }

  // Borra una familia (DELETE)
  Future <void> borrarFamilia(String nom) async{
    final url = Uri.parse('$baseUrl/families/borrar/$nom');
    final response = await http.delete(url);
    if (response.statusCode == 200){
      return;
    }else{
      throw Exception("Error a l'hora de borrar a la familia");
    }
  }
  /*
  tickets
  */

  // Obté tots els tickets (GET)
  Future<List<dynamic>?> getTickets() async{
    final url = Uri.parse('$baseUrl/tickets');
    final response = await http.get(url);
    if(response.statusCode==200){
      return jsonDecode(response.body);
    }else{
      throw Exception("Error a l'hora d'obtindre els tickets");
    }
  }

  // Inserta nous tickets (POST)
  Future<Map<String, dynamic>> postTickets(
  {required int quantitat, required double preu}) async{
    final url = Uri.parse('$baseUrl/tickets/insertar');
    final response = await http.post(
      url,
      headers: {'Content-Type':'applicattion/json'},
      body: jsonEncode({
        'quantitat' : quantitat,
        'preu' : preu,
      }),
    );
    if(response.statusCode == 201){
      return jsonDecode(response.body);
    }else{
      throw Exception("Error a l'hora d'insertar un ticket");
    }
  }

  // Borra un ticket (DELETE)
  Future <void> borrarTicket(String id) async{
    final url = Uri.parse('$baseUrl/tickets/borrar/$id');
    final response = await http.delete(url);
    if(response.statusCode == 200){
      return;
    }else{
      throw Exception("Error a l'hora de borrar el ticket");
    }
  }
  /*
  Productes  
  */

  // Obté tots els productes (GET)
  Future<List<dynamic>?> getProductes() async{
    final url = Uri.parse('$baseUrl/productes');
    final response = await http.get(url);
    if(response.statusCode==200){
      return jsonDecode(response.body);
    }else{
      throw Exception("Error a l'hora d'obtindre els productes");
    }
  }

  // Obté els productes de la barra (GET)
  Future<List<dynamic>?> getProductesBarra() async{
    final url = Uri.parse('$baseUrl/productes/barra');
    final response = await http.get(url);
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      throw Exception("Error a l'hora d'obtindre els productes de la barra");
    }
  }

  // Inserta un nou producte (POST)
  Future<Map<String, dynamic>> postProducte({
    required String nom, required double preu, required int stock, required String imatgeUrl
  }) async{
    final url = Uri.parse('$baseUrl/productes/insertar');
    final response = await http.post(
      url,
      headers: {'Content-Type':'application/json'},
      body: jsonEncode({
      'nom' : nom,
      'preu' : preu,
      'stock' : stock,
      'urlimatge' : imatgeUrl,  
      }),
    );
    if(response.statusCode == 201){
      return jsonDecode(response.body);
    }else{
      throw Exception("Error a l'hora d'insertar el producte");
    }
  }

  // Borra un producte (DELETE)
  Future <void> borrarProducte(String nom) async {
    final url = Uri.parse('$baseUrl/productes/borrar/$nom');
    final response = await http.delete(url);
    if(response.statusCode == 200){
      return;
    }else{
      throw Exception("Error a l'hora de borrar ek producte");
    }
  }
  /*
  Cobrador
  */

  // Obté tots els cobradors (GET)
  Future<List<dynamic>?> getCobradors() async{
    final url = Uri.parse('$baseUrl/cobrador');
    final response = await http.get(url);
    if(response.statusCode==200){
      return jsonDecode(response.body);
    }else{
      throw Exception("Error a l'hora d'obtindre als cobradors");
    }
  }

  // Inserta un nou cobrador (POST)
  Future<Map<String, dynamic>> postCobrador(
    {required String rolCobrador}
  ) async{
    final url = Uri.parse('$baseUrl/cobrador/insertar');
    final response = await http.post(
      url,
      headers: {'Content-Type':'applicattion/json'},
      body: jsonEncode({
        'rolcobrador': rolCobrador,
      }),
    );
    if(response.statusCode == 201){
      return jsonDecode(response.body);
    }else{
      throw Exception("Error a l'hora d'insertar un cobrador");
    }
  }

  // Borra un cobrador (DELETE)
  Future <void> borrarCobrador(String rolCobrador) async{
    final url = Uri.parse('$baseUrl/cobrador/borrar/$rolCobrador');
    final response = await http.delete(url);
    if (response.statusCode == 200){
      return;
    }else{
      throw Exception("Error a l'hora de borrar al cobrador");
    }
  } 

  Future<Faller?> verificarUsuari(String nom, String valorPulsera) async {
    final url = Uri.parse('$baseUrl/verificar');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nom': nom,
        'valorPulsera': valorPulsera,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Faller.fromJSON(data['faller']);
    } else {
      // Aquí pots gestionar errors o mostrar missatge
      print('Error: ${response.body}');
      return null;
    }
  }
}
