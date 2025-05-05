import 'package:flutter/material.dart';
import 'package:gestio_falla/domain/repository/qr_repository.dart';
import 'package:gestio_falla/infrastructure/data_source/qr_datasource.dart';

class QrRepositoryImpl implements QrRepository{
  final QrDataSource qrDataSource;
  QrRepositoryImpl(this.qrDataSource);
  
  @override
  Future<void> llegirQR({
    required BuildContext context, 
    required String valorEsperat,
    required void Function() onCoincidencia,
    void Function(String)? onDiferent,
    void Function()? onError,
    }) {
      return qrDataSource.llegirQR(
        context: context,
        valorEsperat: valorEsperat,
        onCoincidencia: onCoincidencia,
        onDiferent: onDiferent,
        onError: onError,
        );
  }
}