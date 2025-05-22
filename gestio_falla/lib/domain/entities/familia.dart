import 'package:gestio_falla/domain/entities/faller.dart';

class Familia {
  double? id;
  String nom;
  double? saldoTotal;
  List<Faller>? membres;

  Familia({
    this.id,
    required this.nom,
    this.saldoTotal,
    this.membres,
  });

  factory Familia.fromJSON(Map<String, dynamic> json) {
    return Familia(
      id: (json['id'] as num?)?.toDouble(),
      nom: json['nom'],
      saldoTotal: (json['saldoTotal'] as num?)?.toDouble(),
      membres: json['membres'] != null
          ? List<Faller>.from(json['membres'].map((m) => Faller.fromJSON(m)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'saldoTotal': saldoTotal,
      'membres': membres?.map((m) => m.toJSON()).toList(),
    };
  }
}
