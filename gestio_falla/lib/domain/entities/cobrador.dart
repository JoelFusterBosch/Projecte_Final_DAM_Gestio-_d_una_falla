class Cobrador {
  String? id;
  final String rolcobrador;

  static const List<String> rolsValids = ['Cadires', 'Barra', 'Escudellar'];

  Cobrador({required this.rolcobrador, this.id}) {
    if (!rolsValids.contains(rolcobrador)) {
      throw ArgumentError('Rol no vàlid: $rolcobrador');
    }
  }

  factory Cobrador.fromJSON(Map<String, dynamic> json) {
    return Cobrador(
      id: json['id'],
      rolcobrador: json['rolcobrador']
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id' : id,
      'rolcobrador': rolcobrador,
    };
  }
}
