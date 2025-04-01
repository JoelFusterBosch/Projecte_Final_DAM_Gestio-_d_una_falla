import 'dart:ffi';

import 'package:gestio_falla/domain/event.dart';

class Ticket {
  double id;
  Bool? maxim;
  Event? event;
  Ticket({required this.id, this.maxim, this.event});
}