import 'package:gestio_falla/domain/entities/familia.dart';

class Faller {
  double? id;
  String nom;
  bool? teLimit;
  double? limit;
  bool? esCap;
  double? saldo;
  Familia? familia;

  String rol;     
  static const List<String> rolsValids = ['Faller', 'Cobrador','Cap de familia'];  
  String? subRol;   

  Faller({
    this.id,
    required this.nom,
    this.teLimit,
    this.limit,
    this.esCap,
    this.saldo,
    this.familia,
    required this.rol,
    
    this.subRol,
  }) {
    if (!rolsValids.contains(rol)) {
      throw ArgumentError('Rol no vàlid: $rol');
    }else if (rol == 'cobrador') {
      if (subRol == null || !subRolesCobrador.contains(subRol)) {
        throw ArgumentError('Cobrador debe tener un subRol válido.');
      }
    } else {
      subRol = null; // limpiar si no es cobrador
    }
  }

  static const List<String> subRolesCobrador = ['Cadires', 'Barra', 'Escudellar'];

  bool get esCobrador => rol == 'cobrador';

  factory Faller.fromJSON(Map<String, dynamic> json) {
    return Faller(
      id: json['id'],
      nom: json['nom'],
      teLimit: json['teLimit'],
      limit: json['limit'],
      esCap: json['esCap'],
      saldo: (json['saldo'] is int)
          ? (json['saldo'] as int).toDouble()
          : json['saldo'],
      familia: json['familia'], // debería deserializar Familia si es un objeto
      rol: json['rol'],
      subRol: json['subRol'],
    );
  }
}
