import 'dart:ffi';
import 'package:gestio_falla/domain/ticket.dart';

class Event {
  double id;
  String nom;
  Float? preu;
  Ticket? ticket;
  Event({required this.id,required this.nom,this.preu,this.ticket});
}