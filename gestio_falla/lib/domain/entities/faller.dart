import 'package:gestio_falla/domain/entities/cobrador.dart';
import 'package:gestio_falla/domain/entities/familia.dart';

class Faller {
  double? id;
  String nom;
  bool telimit;
  double? llimit;
  double? saldo;
  Familia? familia_id;

  String rol;     
  static const List<String> rolsValids = ['Faller', 'Cobrador','Cap de familia','Administrador','SuperAdmin'];  
  Cobrador? cobrador_id;  
  String valorpulsera; 
  String? imatgeurl;
  bool estaloguejat;

  Faller({
    this.id,
    required this.nom,
    required this.telimit,
    this.llimit,
    this.saldo,
    this.familia_id,
    required this.rol,
    this.cobrador_id,
    required this.valorpulsera,
    this.imatgeurl,
    required this.estaloguejat,
  }) {
    if (!rolsValids.contains(rol)) {
      throw ArgumentError('Rol no vàlid: $rol');
    } else if (rol == 'Cobrador' || rol == 'SuperAdmin') {
      if (cobrador_id == null) {
        throw ArgumentError('El rol "Cobrador" requereix una instància de Cobrador.');
      }
      if (!Cobrador.rolsValids.contains(cobrador_id!.rolCobrador)) {
        throw ArgumentError('Cobrador deu tindre un subRol vàlid: ${cobrador_id!.rolCobrador}.');
      }
    } else {
      // Si no és Cobrador, subRol hauria de ser null
      cobrador_id = null;
    }
    if(rol!="Cap de familia"){
      if (telimit && llimit == null) {
      throw ArgumentError("Si 'teLimit' es vertader, 'limit' no pot ser nul.");
      }
      if (!telimit && llimit != null) {
        throw ArgumentError("Si 'teLimit' es fals, 'limit' deu ser nul.");
      }
    } else {
      if (telimit && llimit == null) {
        throw ArgumentError("Si 'teLimit' és vertader, 'limit' no pot ser nul.");
      }
      if (!telimit && llimit != null) {
        throw ArgumentError("Si 'teLimit' és fals, 'limit' ha de ser nul.");
      }
    }
  }

  factory Faller.fromJSON(Map<String, dynamic> json) {
    return Faller(
      id: (json['id'] as num?)?.toDouble(),
      nom: json['nom'],
      telimit: json['telimit'],
      llimit: (json['llimit'] as num?)?.toDouble(),
      saldo: (json['saldo'] as num?)?.toDouble(),
      familia_id: json['familia_id'] != null ? Familia.fromJSON(json['familia']) : null,
      rol: json['rol'],
      cobrador_id: json['cobrador_id'] != null ? Cobrador.fromJSON(json['cobrador']) : null,
      valorpulsera: json['valorpulsera'],
      imatgeurl: json['imatgeurl'],
      estaloguejat: json['estaloguejat'],
    );
  }
  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'nom': nom,
      'telimit': telimit,
      'llimit': llimit,
      'saldo': saldo,
      'familia_id': familia_id?.toJson(),
      'rol': rol,
      'cobrador_id': cobrador_id?.toJSON(),
      'valorpulsera': valorpulsera,
      'imatgeurl': imatgeurl,
      'estaloguejat': estaloguejat,
    };
  }
}
