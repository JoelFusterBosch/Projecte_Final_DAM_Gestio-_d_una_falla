import 'dart:ffi';
import 'package:gestio_falla/domain/faller.dart';

class Familia {
  double id;
  String nom;
  Float? saldoTotal;
  List<Faller>? membres;
  Familia({required this.id, required this.nom,this.saldoTotal, this.membres});
}