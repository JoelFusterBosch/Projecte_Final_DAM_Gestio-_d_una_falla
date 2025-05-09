

class Cobrador {
  final String rolCobrador; // sols permet certs valors

  static const List<String> rolsValids = ['Cadires', 'Barra', 'Escudellar'];

  Cobrador({required this.rolCobrador}) {
    if (!rolsValids.contains(rolCobrador)) {
      throw ArgumentError('Rol no vàlid: $rolCobrador');
    }
  }
  factory Cobrador.fromJSON(Map<String, dynamic> json){
    return Cobrador(rolCobrador: json["rolCobrador"]);
  }
}