import 'dart:ffi';
import 'package:gestio_falla/domain/event.dart';
import 'package:gestio_falla/domain/ticket.dart';

class RegistraEvent {
  int qTickets;
  Ticket ticket;
  Float? preuTotal;
  Event? event;
  RegistraEvent({required this.qTickets,required this.ticket,this.preuTotal,this.event}); 
}