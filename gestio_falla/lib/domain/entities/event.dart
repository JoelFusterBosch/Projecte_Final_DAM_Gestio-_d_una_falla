import 'package:intl/intl.dart';
import 'package:gestio_falla/domain/entities/producte.dart';
import 'package:gestio_falla/domain/entities/ticket.dart';

class Event {
  String? id;
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
    this.producte_id,
  }) {
    if (prodespecific) {
      if (prodespecific && producte_id != null) {
        if (!producte_id!.eventespecific) {
          throw ArgumentError("Només es poden assignar productes exclusius a l'event.");
        }
      }
      if (!producte_id!.eventespecific) {
        throw ArgumentError("Només es poden assignar productes exclusius a l'event.");
      }
    } else {
      producte_id = null;
    }
  }

  String get dataIniciFormatejada => DateFormat('dd-MM-yyyy HH:mm').format(datainici);
  String get dataFiFormatejada => DateFormat('dd-MM-yyyy HH:mm').format(datafi);

  factory Event.fromJSON(Map<String, dynamic> json) {
  final DateTime datainiciParsed = DateTime.parse(json['dataInici']);
  final DateTime datafiParsed = DateTime.parse(json['dataFi']);

  return Event(
    id: json['id']?.toString(),
    nom: json['nom'] ?? 'Sense nom',
    descripcio: json['descripcio'],
    ticket_id: json['ticket'] != null ? Ticket.fromJSON(json['ticket']) : null,
    datainici: datainiciParsed,
    datafi: datafiParsed,
    urlimatge: json['urlImatge'],
    numcadires: json['numCadires'] ?? 0,
    prodespecific: json['prodEspecific'] ?? false,
    producte_id: json['producte'] != null ? Producte.fromJSON(json['producte']) : null,
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
    'numcadires': numcadires,
    'prodespecific': prodespecific,
    'producte_id': producte_id?.toJSON(),
  };
}
