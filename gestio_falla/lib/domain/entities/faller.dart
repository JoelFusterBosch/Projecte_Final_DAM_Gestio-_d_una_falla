import 'package:gestio_falla/domain/entities/cobrador.dart';
import 'package:gestio_falla/domain/entities/familia.dart';

class Faller {
  double? id;
  String nom;
  bool? teLimit;
  double? limit;
  double? saldo;
  Familia? familia;

  String rol;     
  static const List<String> rolsValids = ['Faller', 'Cobrador','Cap de familia','Administrador'];  
  Cobrador? cobrador;  
  String valorPulsera; 

  Faller({
    this.id,
    required this.nom,
    this.teLimit,
    this.limit,
    this.saldo,
    this.familia,
    required this.rol,
    this.cobrador,
    required this.valorPulsera,
  }) {
    if (!rolsValids.contains(rol)) {
      throw ArgumentError('Rol no vàlid: $rol');
    } else if (rol == 'Cobrador') {
      if (cobrador == null) {
        throw ArgumentError('El rol "Cobrador" requereix una instància de Cobrador.');
      }
      if (!Cobrador.rolsValids.contains(cobrador!.rolCobrador)) {
        throw ArgumentError('Cobrador deu tindre un subRol vàlid: ${cobrador!.rolCobrador}.');
      }
    } else {
      // Si no és Cobrador, subRol hauria de ser null
      cobrador = null;
    }
  }

  factory Faller.fromJSON(Map<String, dynamic> json) {
    return Faller(
      id: json['id'],
      nom: json['nom'],
      teLimit: json['teLimit'],
      limit: json['limit'],
      saldo: (json['saldo'] is int)
          ? (json['saldo'] as int).toDouble()
          : json['saldo'],
      familia: json['familia'], 
      rol: json['rol'],
      valorPulsera: json['valorPulsera'],
    );
  }
}
