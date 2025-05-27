import 'package:gestio_falla/domain/entities/cobrador.dart';
import 'package:gestio_falla/domain/entities/familia.dart';

class Faller {
  double? id;
  String nom;
  bool teLimit;
  double? limit;
  double? saldo;
  Familia? familia;

  String rol;     
  static const List<String> rolsValids = ['Faller', 'Cobrador','Cap de familia','Administrador','SuperAdmin'];  
  Cobrador? cobrador;  
  String valorPulsera; 
  String? imatgeUrl;
  bool estaLoguejat;

  Faller({
    this.id,
    required this.nom,
    required this.teLimit,
    this.limit,
    this.saldo,
    this.familia,
    required this.rol,
    this.cobrador,
    required this.valorPulsera,
    this.imatgeUrl,
    required this.estaLoguejat,
  }) {
    if (!rolsValids.contains(rol)) {
      throw ArgumentError('Rol no vàlid: $rol');
    } else if (rol == 'Cobrador' || rol == 'SuperAdmin') {
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
    if(rol!="Cap de familia"){
      if (teLimit && limit == null) {
      throw ArgumentError("Si 'teLimit' es vertader, 'limit' no pot ser nul.");
      }
      if (!teLimit && limit != null) {
        throw ArgumentError("Si 'teLimit' es fals, 'limit' deu ser nul.");
      }
    } else {
      if (teLimit && limit == null) {
        throw ArgumentError("Si 'teLimit' és vertader, 'limit' no pot ser nul.");
      }
      if (!teLimit && limit != null) {
        throw ArgumentError("Si 'teLimit' és fals, 'limit' ha de ser nul.");
      }
    }
  }

  factory Faller.fromJSON(Map<String, dynamic> json) {
    return Faller(
      id: (json['id'] as num?)?.toDouble(),
      nom: json['nom'],
      teLimit: json['teLimit'],
      limit: (json['limit'] as num?)?.toDouble(),
      saldo: (json['saldo'] as num?)?.toDouble(),
      familia: json['familia'] != null ? Familia.fromJSON(json['familia']) : null,
      rol: json['rol'],
      cobrador: json['cobrador'] != null ? Cobrador.fromJSON(json['cobrador']) : null,
      valorPulsera: json['valorPulsera'],
      imatgeUrl: json['imatgeUrl'],
      estaLoguejat: json['estaLoguejat'],
    );
  }
  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'nom': nom,
      'teLimit': teLimit,
      'limit': limit,
      'saldo': saldo,
      'familia': familia?.toJson(),
      'rol': rol,
      'cobrador': cobrador?.toJSON(),
      'valorPulsera': valorPulsera,
      'imatgeUrl': imatgeUrl,
      'estaLoguejat': estaLoguejat,
    };
  }
}
