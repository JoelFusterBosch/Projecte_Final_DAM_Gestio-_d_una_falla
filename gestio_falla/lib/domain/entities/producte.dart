class Producte {
  String? id;
  String nom;
  double preu;
  int stock;
  String? urlimatge;
  bool eventespecific;
  Producte({ this.id, required this.nom, required this.preu, required this.stock, this.urlimatge, required this.eventespecific});

  factory Producte.fromJSON(Map<String, dynamic> json){
    return Producte(
      id: json['id'],
      nom: json['nom'], 
      preu: json['preu'], 
      stock: json['stock'],
      urlimatge: json['urlimatge'] ?? "",
      eventespecific: json['eventespecific']
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