import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/repository/mostraQR_repository.dart';

class Mostraqrprovider with ChangeNotifier{
  final MostraqrRepository mostraqrRepository;
  String? _qrData;
  String? get qrData => _qrData;

  Mostraqrprovider(this.mostraqrRepository);

  Future<void> generateQr(String valorQRaMostrar) async {
    _qrData = await  mostraqrRepository.mostraQR(valorQRaMostrar: valorQRaMostrar);
    notifyListeners();
  }
}