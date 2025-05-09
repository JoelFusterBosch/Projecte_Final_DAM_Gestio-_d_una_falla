import 'dart:ffi';
import 'package:gestio_falla/domain/entities/faller.dart';

class Familia {
  double? id;
  String nom;
  Float? saldoTotal;
  List<Faller>? membres;
  Familia({this.id, required this.nom,this.saldoTotal, this.membres});

  factory Familia.fromJSON(Map<String, dynamic> json){
    return Familia(
      id: json["id"],
      nom: json["nom"],
      saldoTotal: json["saldoTotal"],
      membres: json["membres"],
      );
  }
}