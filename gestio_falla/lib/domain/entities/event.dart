import 'package:gestio_falla/domain/entities/producte.dart';
import 'package:gestio_falla/domain/entities/ticket.dart';
import 'package:intl/intl.dart';

class Event {
  double? id;
  String nom;
  String? descripcio;
  Ticket? ticket_id;
  DateTime datainici;
  DateTime datafi;
  String? urlimatge;
  int numcadires;
  bool prodespecific;
  Producte? producte_id;
  Event({
    this.id,
    required this.nom,
    this.descripcio,
    this.ticket_id, 
    required this.datainici, 
    required this.datafi, 
    this.urlimatge, 
    required this.numcadires, 
    required this.prodespecific, 
    this.producte_id}){
    if (prodespecific) {
      if (producte_id == null) {
        throw ArgumentError("Si el producte es específic de l'event tens que posar un producte.");
      }
      if(!producte_id!.eventespecific){
        throw ArgumentError("Tens que posar sols els productes exclusius a eixe event");
      }
    } else {
      // Si no és Cobrador, subRol hauria de ser null
      producte_id = null;
    }
  }
  String get dataIniciFormatejada {
    return DateFormat('dd-MM-yyyy HH:mm').format(datainici);
  }
  String get dataFiFormatejada {
    return DateFormat('dd-MM-yyyy HH:mm').format(datafi);
  }


  factory Event.fromJSON(Map<String, dynamic> json){
    return Event(
      id: (json['id'] as num?)?.toDouble(),
      nom: json['nom'],
      descripcio: json['descripcio'],
      ticket_id: json['ticket_id'] != null ? Ticket.fromJSON(json['ticket']) : null,
      datainici: DateTime.parse(json['dataInici']),
      datafi: DateTime.parse(json['dataFi']),
      urlimatge: json['urlimatge'] ?? "",
      numcadires: json['numcadires'],
      prodespecific: json['prodespecific'],
      producte_id: json['producte_id'] != null ? Producte.fromJSON(json['producte']) : null,
    );
  }
  Map<String, dynamic> toJSON() => {
    'id': id,
    'nom': nom,
    'descripcio': descripcio,
    'ticket_id': ticket_id?.toJSON(),
    'datainici': datainici.toIso8601String(),
    'datafi': datafi.toIso8601String(),
    'urlimatge': urlimatge,
    'numCadires': numcadires,
    'prodespecific': prodespecific,
    'producte_id': producte_id?.toJSON(),
  };

}