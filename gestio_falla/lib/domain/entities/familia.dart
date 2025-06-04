import 'package:gestio_falla/domain/entities/faller.dart';

class Familia {
  String? id;
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
      id: json['id'],
      nom: json['nom'],
      saldo_total: json['saldo_total'] != null ? double.tryParse(json['saldo_total'].toString()) : null,
      membres: json['membres'] != null
          ? List<Faller>.from(json['membres'].map((m) => Faller.fromJSON(m)))
          : null,
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'id': id,
      'nom': nom,
      'saldo_total': saldo_total,
      'membres': membres?.map((m) => m.toJSON()).toList(),
    };
  }
}
