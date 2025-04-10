import 'package:gestio_falla/domain/entities/event.dart';
import 'package:gestio_falla/infrastructure/services/events_service.dart';

class EventsRepository {
  static Future<List<Event>> obtenirEvents({
    int a = 0,
  })async{ List<dynamic>llistaJson= await EventsService.obtenirEvents(a: a); 
    List<Event> llistaEvents=[];
    for(int i=0; i<llistaJson.length ;i++){
      Event event = Event.fromJSON(llistaJson[i]);
      llistaEvents.add(event);
    }
    return llistaEvents;
  }
}