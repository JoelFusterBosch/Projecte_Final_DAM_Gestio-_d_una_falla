import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QrDataSource {
  QrDataSource();

  Future<void> llegirQR({
    required BuildContext context,
    required String valorEsperat,
    required void Function() onCoincidencia,
    void Function(String)? onDiferent,
    void Function()? onError,
  }) async {
    final status = await Permission.camera.request();

    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permís de càmera denegat')),
      );
      onError?.call();
      return;
    }

    bool isProcessing = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Scaffold(
          appBar: AppBar(title: const Text('Escàner QR')),
          body: MobileScanner(
            controller: MobileScannerController(),
            onDetect: (capture) {
              if (isProcessing) return;
              isProcessing = true;

              final String? code = capture.barcodes.first.rawValue;
              if (code == null) return;

              Navigator.pop(dialogContext);

              if (code == valorEsperat) {
                onCoincidencia();
              } else {
                onDiferent?.call(code);
              }
            },
          ),
        );
      },
    );
  }

  // Aquí el nou mètode per llegir QR i retornar el valor (o null)
  Future<String?> llegirQRAmbRetorn({
    required BuildContext context,
    void Function()? onError,
  }) async {
    final status = await Permission.camera.request();

    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permís de càmera denegat')),
      );
      onError?.call();
      return null;
    }

    String? valorLlegit;
    bool isProcessing = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Scaffold(
          appBar: AppBar(title: const Text('Escàner QR')),
          body: MobileScanner(
            controller: MobileScannerController(),
            onDetect: (capture) {
              if (isProcessing) return;
              isProcessing = true;

              final String? code = capture.barcodes.first.rawValue;
              if (code == null) {
                onError?.call();
                Navigator.pop(dialogContext);
                return;
              }

              valorLlegit = code;
              Navigator.pop(dialogContext);
            },
          ),
        );
      },
    );

    return valorLlegit;
  }

}
