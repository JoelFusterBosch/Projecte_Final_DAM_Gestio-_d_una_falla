import 'dart:convert';
import 'package:http/http.dart' as http;

class FakeApiOdooDataSource {
  final String baseUrl;
  final String db;

  FakeApiOdooDataSource({required this.baseUrl, required this.db});
  Future<Map<String,dynamic>> saluda() async{
    final url = Uri.parse('$baseUrl/');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error a l'hora de conectar al servidor");
    }
  }
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

  // Obté el perfil d'un faller (GET)
  Future<Map<String, dynamic>> getPerfil(String id) async {
    final url = Uri.parse('$baseUrl/fallers/perfil/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception("Perfil no encontrado");
    } else {
      throw Exception("Error a l'hora d'obtindre el perfil");
    }
  }

  // Obté dades per al QR d'un faller (GET)
  Future<Map<String, dynamic>> getMostraQR(String id) async {
    final url = Uri.parse('$baseUrl/fallers/mostraQR/$id');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 404) {
      throw Exception("Faller no encontrado");
    } else {
      throw Exception("Error a l'hora d'obtindre les dades per al QR");
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
        'valorPulsera': valorPulsera,
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
  Future<Map<String, dynamic>> asignarFamilia(String id, String idFamilia) async {
    final url = Uri.parse('$baseUrl/fallers/familia/$id');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idFamilia': idFamilia}),
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Error a l'hora d¡asignar la familia");
    }
  }

  // Cambia el rol d'un faller (PUT)
  Future<Map<String, dynamic>> canviaRol(String id, String rol) async {
    final url = Uri.parse('$baseUrl/fallers/cambiaRol/$id');
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
  Future<void> borrarFaller(String id) async {
    final url = Uri.parse('$baseUrl/fallers/borrar/$id');
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

  // Obté l'event detallat (GET)
  Future<Map<String, dynamic>> getEventsDetallats(String id) async{
    final url = Uri.parse('$baseUrl/events/detallat/$id');
    final response = await http.get(url);
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      throw Exception("Error a l'hora d'obtindre els events detallats");
    }
  }

  // Obté la llista d'events (GET)
  Future <List<dynamic>?> getLlistaEvents() async{
    final url = Uri.parse('$baseUrl/events/llista');
    final response = await http.get(url);
    if(response.statusCode == 200){
      return jsonDecode(response.body);
    }else{
      throw Exception("Error a l'hora d'obtindre la llista d'events");
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
      'datafi' : dataFi
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
  Future<void> borrarEvent(String id) async{
    final url = Uri.parse('$baseUrl/events/borrar/$id');
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
  Future <void> borrarFamilia(String id) async{
    final url = Uri.parse('$baseUrl/families/borrar/$id');
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
  {required int quantitat, required double preu, required bool maxim}) async{
    final url = Uri.parse('$baseUrl/tickets/insertar');
    final response = await http.post(
      url,
      headers: {'Content-Type':'applicattion/json'},
      body: jsonEncode({
        'quantitat' : quantitat,
        'preu' : preu,
        'maxim' : maxim,
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
  Future <void> borrarProducte(String id) async {
    final url = Uri.parse('$baseUrl/productes/borrar/$id');
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
        'rol_cobrador': rolCobrador,
      }),
    );
    if(response.statusCode == 201){
      return jsonDecode(response.body);
    }else{
      throw Exception("Error a l'hora d'insertar un cobrador");
    }
  }

  // Borra un cobrador (DELETE)
  Future <void> borrarCobrador(String id) async{
    final url = Uri.parse('$baseUrl/cobrador/borrar/$id');
    final response = await http.delete(url);
    if (response.statusCode == 200){
      return;
    }else{
      throw Exception("Error a l'hora de borrar al cobrador");
    }
  } 

  Future<bool> verificarUsuari(String nom, String valorPulsera) async {
    final url = Uri.parse('$baseUrl/auth/verificar');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nom': nom,
        'valorPulsera': valorPulsera,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body['verificat'] == true;
    } else {
      return false;
    }
  }
}
