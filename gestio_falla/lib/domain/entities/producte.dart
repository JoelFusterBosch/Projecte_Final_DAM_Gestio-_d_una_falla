class Producte {
  double? id;
  String nom;
  String? descripcio;
  double preu;
  int stock;
  String? urlimatge;
  bool eventespecific;
  Producte({ this.id, required this.nom, this.descripcio, required this.preu, required this.stock, this.urlimatge, required this.eventespecific});

  factory Producte.fromJSON(Map<String, dynamic> json){
    return Producte(
      id: json['id'],
      nom: json['nom'], 
      descripcio: json['descripcio'],
      preu: json['preu'], 
      stock: json['stock'],
      urlimatge: json['urlimatge'] ?? "",
      eventespecific: json['eventespecific']
    );
  }
  Map<String, dynamic> toJSON() => {
  'id': id,
  'nom': nom,
  'descripcio': descripcio,
  'preu': preu,
  'stock': stock,
  'urlImatge': urlimatge,
  'eventEspecific': eventespecific,
};

}