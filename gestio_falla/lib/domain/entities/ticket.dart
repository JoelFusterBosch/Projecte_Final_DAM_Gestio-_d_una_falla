class Ticket {
  double id;
  double preu;
  int quantitat;
  bool maxim;
  Ticket({required this.id,required this.preu, required this.quantitat, required this.maxim,});

  factory Ticket.fromJSON(Map<String, dynamic>json){
    return Ticket(
      id: json['id'],
      preu: (json['preu'] is int)
              ? (json['preu'] as int).toDouble()
              : json['preu'],
      quantitat: json['quantitat'],
      maxim: json['maxim'],
      );
  }
  Map<String, dynamic> toJSON() => {
    'id': id,
    'preu': preu,
    'quantitat': quantitat,
    'maxim': maxim,
  };

}