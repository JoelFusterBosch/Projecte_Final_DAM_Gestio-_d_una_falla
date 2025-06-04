import 'package:gestio_falla/domain/entities/cobrador.dart';
import 'package:gestio_falla/domain/entities/familia.dart';

class Faller {
  String? id;
  String nom;
  bool telimit;
  double? llimit;
  double saldo=0;
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
    required this.saldo,
    this.familia_id,
    required this.rol,
    this.cobrador_id,
    required this.valorpulsera,
    this.imatgeurl,
    required this.estaloguejat,
  }) {
    if (!rolsValids.contains(rol)) {
      throw ArgumentError('Rol no vàlid: $rol');
    } else if (rol == 'Cobrador') {
      if (cobrador_id == null) {
        throw ArgumentError('El rol "Cobrador" requereix una instància de Cobrador.');
      }
      if (!Cobrador.rolsValids.contains(cobrador_id!.rolcobrador)) {
        throw ArgumentError('Cobrador deu tindre un subRol vàlid: ${cobrador_id!.rolcobrador}.');
      }
    } else if (rol == 'SuperAdmin' && cobrador_id != null) {
      if (!Cobrador.rolsValids.contains(cobrador_id!.rolcobrador)) {
        throw ArgumentError('Cobrador (de SuperAdmin) té un subRol no vàlid: ${cobrador_id!.rolcobrador}.');
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
    id: json['id']?.toString(),
    nom: json['nom'] ?? '',
    telimit: json['telimit'] == true || json['telimit'] == 'true',
    llimit: json['llimit'] != null ? double.tryParse(json['llimit'].toString()) : null,
    saldo: double.tryParse(json['saldo'].toString()) ?? 0.0,
    familia_id: json['familia'] is Map<String, dynamic> ? Familia.fromJSON(json['familia']) : null,
    rol: json['rol'] ?? '',
    cobrador_id: json['cobrador'] != null ? Cobrador.fromJSON(json['cobrador']) : null,
    valorpulsera: json['valorpulsera'] ?? '',
    imatgeurl: json['imatgeurl'],
    estaloguejat: json['estaloguejat'] == true || json['estaloguejat'] == 'true',
  );
}

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'nom': nom,
      'telimit': telimit,
      'llimit': llimit,
      'saldo': saldo,
      'familia_id': familia_id?.toJSON(),
      'rol': rol,
      'cobrador_id': cobrador_id?.toJSON(),
      'valorpulsera': valorpulsera,
      'imatgeurl': imatgeurl,
      'estaloguejat': estaloguejat,
    };
  }
}
