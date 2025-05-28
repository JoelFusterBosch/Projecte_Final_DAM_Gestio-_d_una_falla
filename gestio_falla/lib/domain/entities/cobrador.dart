class Cobrador {
  double? id;
  final String rolCobrador;

  static const List<String> rolsValids = ['Cadires', 'Barra', 'Escudellar'];

  Cobrador({required this.rolCobrador, this.id}) {
    if (!rolsValids.contains(rolCobrador)) {
      throw ArgumentError('Rol no vàlid: $rolCobrador');
    }
  }

  factory Cobrador.fromJSON(Map<String, dynamic> json) {
    return Cobrador(
      id: json['id'],
      rolCobrador: json['rolCobrador']
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id' : id,
      'rolCobrador': rolCobrador,
    };
  }
}
