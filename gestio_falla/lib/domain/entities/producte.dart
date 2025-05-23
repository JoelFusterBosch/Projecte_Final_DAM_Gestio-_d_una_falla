class Producte {
  double? id;
  String nom;
  String? desc;
  double preu;
  int stock;
  String? urlImatge;
  bool eventEspecific;
  Producte({ this.id, required this.nom, this.desc, required this.preu, required this.stock, this.urlImatge, required this.eventEspecific});

  factory Producte.fromJSON(Map<String, dynamic> json){
    return Producte(
      id: json['id'],
      nom: json['nom'], 
      desc: json['desc'],
      preu: json['preu'], 
      stock: json['stock'],
      urlImatge: json['urlImatge'] ?? "",
      eventEspecific: json['eventEspecific']
    );
  }
}