import 'package:flutter/widgets.dart';
import 'package:gestio_falla/repository/events_repository.dart';

class Eventprovider with ChangeNotifier{
  final _EventRepository = EventsRepository();
}