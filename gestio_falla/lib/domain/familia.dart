import 'dart:ffi';
import 'package:gestio_falla/domain/membre.dart';

class Familia {
  double id;
  String nom;
  Float? saldoTotal;
  List<Membre>? membres;
  Familia({required this.id, required this.nom,this.saldoTotal, this.membres});
}