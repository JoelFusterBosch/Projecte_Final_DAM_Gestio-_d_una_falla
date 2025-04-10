import 'package:gestio_falla/domain/entities/event.dart';
import 'package:gestio_falla/domain/entities/ticket.dart';

class RegistraEvent {
  int qTickets;
  Ticket ticket;
  double? preuTotal;
  Event? event;
  RegistraEvent({required this.qTickets,required this.ticket,this.preuTotal,this.event}); 

  factory RegistraEvent.fromJSON(Map<String,dynamic>json){
    return RegistraEvent(
      qTickets: json['qTickets'], 
      ticket: json['tickets'],
      preuTotal: (json['preuTotal'] is int)
              ? (json['preuTotal'] as int).toDouble()
              : json['preuTotal'],
      event: json['event'],
      );
  }
}