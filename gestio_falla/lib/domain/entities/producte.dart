class Producte {
  String nom;
  String? desc;
  double preu;
  int stock;
  String? urlImatge;
  Producte({required this.nom, this.desc, required this.preu, required this.stock, this.urlImatge});

  factory Producte.fromJSON(Map<String, dynamic> json){
    return Producte(
      nom: json['nom'], 
      desc: json['desc'],
      preu: json['preu'], 
      stock: json['stock'],
      urlImatge: json['urlImatge'] ?? "",
    );
  }
}