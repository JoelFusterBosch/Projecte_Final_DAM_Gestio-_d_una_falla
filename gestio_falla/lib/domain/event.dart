import 'package:gestio_falla/domain/ticket.dart';

class Event {
  double id;
  String nom;
  double? preu;
  Ticket? ticket;
  Event({required this.id,required this.nom,this.preu,this.ticket});

  factory Event.fromJSON(Map<String, dynamic> json){
    return Event(
      id: json['id'], 
      nom: json['nom'],
      preu: (json['preu'] is int)
              ? (json['preu'] as int).toDouble()
              : json['preu'],
      ticket: json['ticket'],
    );
  }
}