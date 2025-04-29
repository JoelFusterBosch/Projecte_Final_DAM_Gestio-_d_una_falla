class Cobrador {
  final String rolCobrador; // solo permite ciertos valores

  static const List<String> rolsValids = ['cadires', 'barra', 'escudellar'];

  Cobrador({required this.rolCobrador}) {
    if (!rolsValids.contains(rolCobrador)) {
      throw ArgumentError('Rol no vàlid: $rolCobrador');
    }
  }
}