class Producte {
  String? id;
  String nom;
  double preu;
  int stock;
  String? urlimatge;
  bool eventespecific;

  Producte({
    this.id,
    required this.nom,
    required this.preu,
    required this.stock,
    this.urlimatge,
    required this.eventespecific,
  });

  factory Producte.fromJSON(Map<String, dynamic> json) {
    return Producte(
      id: json['id'],
      nom: json['nom'] ?? 'Sense nom',
      preu: double.tryParse(json['preu']?.toString() ?? '0.0') ?? 0.0,
      stock: json['stock'] is int ? json['stock'] : 0,
      urlimatge: json['urlimatge'] ?? '',
      eventespecific: json['eventespecific'] is bool ? json['eventespecific'] : false,
    );
  }

  Map<String, dynamic> toJSON() => {
    'id': id,
    'nom': nom,
    'preu': preu,
    'stock': stock,
    'urlimatge': urlimatge,
    'eventespecific': eventespecific,
  };
}
