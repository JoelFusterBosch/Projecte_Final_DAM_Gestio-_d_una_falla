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
  Event({this.id,required this.nom, this.desc, this.ticket, required this.dataInici, required this.dataFi, this.urlImatge});
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
    );
  }
}