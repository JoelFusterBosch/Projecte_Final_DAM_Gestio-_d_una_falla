import 'dart:ffi';

import 'package:gestio_falla/domain/entities/event.dart';

class Ticket {
  double id;
  Bool? maxim;
  Event? event;
  Ticket({required this.id, this.maxim, this.event});

  factory Ticket.fromJSON(Map<String, dynamic>json){
    return Ticket(
      id: json['id'],
      maxim: json['maxim'],
      event: json['event'],
      );
  }
}