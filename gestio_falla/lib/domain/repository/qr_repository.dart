import 'package:flutter/material.dart';

abstract class QrRepository {
  Future <void> llegirQR({
    required BuildContext context,
    required String valorEsperat,
    required void Function() onCoincidencia,
    void Function()? onError,
    void Function(String)? onDiferent,
  });
}