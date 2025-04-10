
import 'package:gestio_falla/domain/entities/familia.dart';

class Faller {
  double? id;
  String nom;
  bool? teLimit;
  double? limit;
  bool? esCap;
  double? saldo;
  Familia? familia;
  Faller({this.id,required this.nom,this.teLimit,this.limit,this.esCap,this.saldo,this.familia});

  factory Faller.fromJSON(Map<String,dynamic>json){
    return Faller(
      id: json['id'], 
      nom: json['nom'],
      teLimit: json['teLimit'],
      limit: json['limit'],
      esCap: json['esCap'],
      saldo: (json['saldo'] is int)
              ? (json['saldo'] as int).toDouble()
              : json['saldo'],
      familia: json['familia'],
    );
  }
}