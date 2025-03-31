import 'dart:ffi';

import 'package:gestio_falla/domain/familia.dart';

class Membre {
  double id;
  String nom;
  bool? teLimit;
  Float? limit;
  bool? esCap;
  Float? saldo;
  Familia? familia;
  Membre({required this.id,required this.nom,this.teLimit,this.limit,this.esCap,this.saldo,this.familia});
}