# gestio_falla

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
## Dependències en el fitxer pubspec.yaml i com implementar-les:
### Provider
 Gestor d'estat de flutter, cal posar el següent en el yaml en l'apartat de `dependencies`:
 ```yaml
 provider: ^6.1.4  #Versió de Provider utilitzada 
 ```
 I per últim executem en el terminal:
 ```plaintext
 flutter pub get
 ```
 Més documentació a [la pàgina oficial](https://pub.dev/packages/provider)
### NFC
 Esta llibreria incorpora la capacitat de poder llegir etiquetes nfc, cal posar el següent en el yaml en l'apartat de `dependencies`:
 ```yaml
 nfc_manager: ^3.2.0  #Versió de nfc_manager utilitzada 
 ```
 Ara en el `AndroidManifest.xml` necessitarem posar el següent en l'apartat de `manifest`:
 ```xml
 <uses-permission android:name="android.permission.NFC"/>
 <uses-feature android:name="android.hardware.nfc" android:required="true"/>
 ```
 I per últim executem en el terminal:
 ```plaintext
 flutter pub get
 ```
 Més informació en [la pàgina oficial](https://pub.dev/packages/nfc_manager)
### http
 Esta llibreria ens servira per a poder connectar-mon a l'API d'Odoo, cal posar el següent en el yaml en l'apartat de `dependencies`:
 ```yaml
 http: ^1.3.0  #Versió de http utilitzada 
 ```
 I per últim executem en el terminal:
 ```plaintext
 flutter pub get
 ```
 Més documentacio en [la pàgina oficial](https://pub.dev/packages/http)
### MobileScanner(Per a codi QR)
 Esta llibreria ens dona la capacitat de llegir codis QR, cal posar el següent en el yaml en l'apartat de `dependencies`:
 ```yaml
 mobile_scanner: ^3.0.0 #Versió de mobile_scanner utilitzada
 ```
 Ara executem:
 ```plaintext
 flutter pub get
 ```
### Mostrar QR (qr_flutter)
 Esta llibreria ens permet generar codis QR en la nostra aplicació, cal posar el següent en el yaml en l'apartat de `dependencies`:
  ```yaml
  qr_flutter: ^4.0.0 #Versió de qr_flutter utilitzada
  ```
  Més documentació en [la pàgina oficial](https://pub.dev/packages/qr_flutter)
 ### Permisos
 Per a poder llegir codis QR necessitarem la camara, i per això hi haura que demanar permisos de la següent forma:
 Anem al `AndroidManifest` que es troba en la següent ruta:
 ```plaintext
 /android/src/AndroidManifest.xml
 ```
 Tindrem que posar el següent:<br>
 En l'apartat de manifest
 ```
 <manifest xmlns:android="http://schemas.android.com/apk/res/android">
 ...
 <uses-permission android:name="android.permission.CAMERA"/>
 <uses-feature android:name="android.hardware.camera" android:required="false"/>
 ```
### Notificacions
 Esta llibreria ens permetrà manar notificacions al mòbil, cal posar el següent en el yaml en l'apartat de `dependencies`:
 ```yaml
 flutter_local_notifications: 15.1.1  #Versió de flutter_local_notifications utilitzada 
 ```
#### Alteracions per a que funcione en la versió 15.1.1
 Necessiteu anar al fitxer en `FlutterLocalNotificationsPlugin.java` que és troba en:
 - Windows:
 ```plaintext
 C:\Users\usuari\AppData\Local\Pub\Cache\hosted\pub.dev\flutter_local_notifications-15.1\android\src\main\java\com\dexterous\flutterlocalnotifications\FlutterLocalNotificationsPlugin.java
 ```
 - Linux:
 ```plaintext
 /home/usuari/.pub-cache/hosted/pub.dev/flutter_local_notifications-15.1.1/android/src/main/java/com/dexterous/flutterlocalnotifications/FlutterLocalNotificationsPlugin.java
 ```
 
 El que teniu que canviar d'aquest fitxer és el següent:
 **Si ho feu en VSCode aconselle que apreteu Ctrl+f per a obrir un buscador i posar la línia que volem modificar perque el fitxer és molt llarg**
 ```plaintext
 bigPictureStyle.bigLargeIcon(null);
 ```
 Ho cambiem a:
 ```plantext
 bigPictureStyle.bigLargeIcon((Bitmap) null);
 ```
 Ho cambiem degut a que elimina la ambigüetat perque li diu al compilador que use la versió `bigLargeIcon(Bitmap)`.
 I per últim executem en el terminal:
 ```plaintext
 flutter pub get
 ```
 Més documentació de les versions més actuals en [la pàgina oficial](https://pub.dev/packages/flutter_local_notifications)
### Permisos
 Esta llibreria ens permetrà fer que funcionen les notificacions, cal posar el següent en el yaml en l'apartat de `dependencies`:
 ```yaml
 permission_handler: ^11.0.0  #Versió de permision_handler utilitzada 
 ```
 Ara en el fitxer anomenat `AndroidManifest.xml` posarem el següent en el `manifest`:
 ```xml
 <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
 ```
 I per últim executem en el terminal:
 ```plaintext
 flutter pub get
 ```
### Modificació per a posar el format d'hora que vullgues "intl"
 Esta llibrearia ens permet posar el format d'hora que nosaltres vullgam potser tant hh:mm:ss aaaa-mm-dd com dd-mm-aaaa hh:mm:ss per exemple, cal posar en el següent en ´'apartat de `dependencies`:
  ```yaml
 intl: ^11.0.0  #Versió de intl utilitzada 
 ```
 Més documentació em [la pàgina oficial](https://pub.dev/packages/permission_handler)