import 'package:gestio_falla/domain/entities/faller.dart';

class Familia {
  double? id;
  String nom;
  double? saldo_total;
  List<Faller>? membres;

  Familia({
    this.id,
    required this.nom,
    this.saldo_total,
    this.membres,
  });

  factory Familia.fromJSON(Map<String, dynamic> json) {
    return Familia(
      id: (json['id'] as num?)?.toDouble(),
      nom: json['nom'],
      saldo_total: (json['saldo_total'] as num?)?.toDouble(),
      membres: json['membres'] != null
          ? List<Faller>.from(json['membres'].map((m) => Faller.fromJSON(m)))
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'saldo_total': saldo_total,
      'membres': membres?.map((m) => m.toJSON()).toList(),
    };
  }
}
