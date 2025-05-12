import 'package:gestio_falla/domain/entities/ticket.dart';

class Event {
  double? id;
  String nom;
  Ticket? ticket;
  DateTime dataInici;
  DateTime dataFi;
  String? urlImatge;
  Event({this.id,required this.nom,this.ticket, required this.dataInici, required this.dataFi, this.urlImatge});

  factory Event.fromJSON(Map<String, dynamic> json){
    return Event(
      id: (json['id'] as num?)?.toDouble(),
      nom: json['nom'],
      ticket: json['ticket'] != null ? Ticket.fromJSON(json['ticket']) : null,
      dataInici: DateTime.parse(json['dataInici']),
      dataFi: DateTime.parse(json['dataFi']),
      urlImatge: json['urlImatge'] ?? "",
    );
  }
}