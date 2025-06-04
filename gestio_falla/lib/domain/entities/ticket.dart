class Ticket {
  String id;
  double preu;
  int quantitat;
  bool maxim;

  Ticket({
    required this.id,
    required this.preu,
    required this.quantitat,
    required this.maxim,
  });

  factory Ticket.fromJSON(Map<String, dynamic> json) {
  return Ticket(
    id: json['id'].toString(),
    preu: double.tryParse(json['preu'].toString()) ?? 0.0,
    quantitat: json['quantitat'] ?? 0,
    maxim: json['maxim'] == true,
  );
}


  Map<String, dynamic> toJSON() => {
    'id': id,
    'preu': preu,
    'quantitat': quantitat,
    'maxim': maxim,
  };
}
