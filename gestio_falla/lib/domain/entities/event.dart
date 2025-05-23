import 'package:gestio_falla/domain/entities/producte.dart';
import 'package:gestio_falla/domain/entities/ticket.dart';
import 'package:intl/intl.dart';

class Event {
  double? id;
  String nom;
  String? desc;
  Ticket? ticket;
  DateTime dataInici;
  DateTime dataFi;
  String? urlImatge;
  int numCadires;
  bool prodEspecific;
  Producte? producte;
  Event({
    this.id,
    required this.nom,
    this.desc,
    this.ticket, 
    required this.dataInici, 
    required this.dataFi, 
    this.urlImatge, 
    required this.numCadires, 
    required this.prodEspecific, 
    this.producte}){
    if (prodEspecific) {
      if (producte == null) {
        throw ArgumentError("Si el producte es específic de l'event tens que posar un producte.");
      }
      if(!producte!.eventEspecific){
        throw ArgumentError("Tens que posar sols els productes exclusius a eixe event");
      }
    } else {
      // Si no és Cobrador, subRol hauria de ser null
      producte = null;
    }
  }
  String get dataIniciFormatejada {
    return DateFormat('dd-MM-yyyy HH:mm').format(dataInici);
  }
  String get dataFiFormatejada {
    return DateFormat('dd-MM-yyyy HH:mm').format(dataFi);
  }


  factory Event.fromJSON(Map<String, dynamic> json){
    return Event(
      id: (json['id'] as num?)?.toDouble(),
      nom: json['nom'],
      desc: json['desc'],
      ticket: json['ticket'] != null ? Ticket.fromJSON(json['ticket']) : null,
      dataInici: DateTime.parse(json['dataInici']),
      dataFi: DateTime.parse(json['dataFi']),
      urlImatge: json['urlImatge'] ?? "",
      numCadires: json['numCadires'],
      prodEspecific: json['prodEspecific'],
      producte: json['producte']
    );
  }
}