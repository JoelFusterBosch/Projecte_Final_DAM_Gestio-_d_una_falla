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
## Instal·lar flutter i com configurar-ho en VSCode
Primerament instal·la el SDK de la [pàgina oficial de Flutter](https://docs.flutter.dev/get-started/install):
<p align= "center">
   <img src="../gestio_falla/assets/README/Instal·lar Flutter.png" alt="Lloc per a Instal·lar Flutter" width="400"/>
</p>

### Dependencies per a Flutter
Per a provar les apps de flutter en Android has de tindre Android Studio segons els requisits de flutter Doctor, o simplement vols un emulador d'Android o veure el dispositiu físic en la pantalla del teu ordinador, Android Studio pot ajudar-te en este apartat.
Per a veure si tens totes les ferramentes per a usar flutter pots saber-ho amb este comando:<p>
 ```bash
 flutter doctor
 ```
Ara que tenim el SDK instal·lat ara la pregunta és... On puc programar en Flutter?<p>
Pots programar Flutter en VSCode si primerament instal·les les següents extensions (Fixat que per a instal·lar extensions en VSCode és en la següent icona)<p>
<img src="../gestio_falla/assets/README/Extensions.png" alt="Icona d'extensions de Visual Studio Code" width="200"/><p>
Estes són les extensions que has d'instal·lar:

- Flutter

<p align= "center">
   <img src="../gestio_falla/assets/README/Extensió Flutter.png" alt="Extensió de Flutter" width="600"/>
</p>

- Dart

<p align= "center">
   <img src="../gestio_falla/assets/README/Extensió Dart.png" alt="Extensió de Dart" width="600"/>
</p>

- Awesome Flutter Snippets

<p align= "center">
   <img src="../gestio_falla/assets/README/Extensió Awesome Flutter Snippets.png" alt="Extensió de Awesome Flutter Snippets" width="600"/>
</p>

- Pubspec

<p align= "center">
   <img src="../gestio_falla/assets/README/Extensió pubspec.png" alt="Extensió de pubspec" width="600"/>
</p>

## Com generar un projecte de Flutter
Per a generar un projecte de flutter necessitem executar el següent quan premem (Ctrl+Shift+P):

```bash
Flutter: New Project 
```
 

Quan premem la tecla *Enter* apareixerà el següent:
<p align= "center">
   <img src="../gestio_falla/assets/README/Creacio aplicació Flutter.png" alt="Creació de l'aplicació de Flutter" width="600"/>
</p>

Haureu d'prémer la primera opció (Application) esta generara tota l'estructura de directoris perquè pugueu executar l'aplicació de flutter en qualsevol dispositiu perquè genera les carpetes dels respectius sistemes operatius, ara hem d'assignar la carpeta a l'aplicació, en este cas la posaré dins de la carpeta *Projecte_Falla*:

<p align= "center">
   <img src="../gestio_falla/assets/README/Assignar carpeta per a l&apos;aplicació.png" alt="Assignació de la carpeta per a la aplicació de Flutter" width="600"/>
</p>

I després poseu el nom que vulgueu, en el meu cas es dirà *prova*:

<p align= "center">
   <img src="../gestio_falla/assets/README/nom de l&apos;aplicació.png" alt="Assignació de la carpeta per a la aplicació de Flutter" width="600"/>
</p>

Al posar-li el nom premeu la tecla *Enter* i us generara de forma aproximada el següent:
```bash
gestio_falla/
├── .dart.tool/
├── .idea/
│   ├── libraries/
│   │   ├── Dart_SDK.xml
│   │   ├── KotlinJavaRuntime.xml
│   ├── runConfigurations/
│   │   ├── main_dart.xml
│   ├── modules.xml
│   ├── workspace.xml
├── android/
│   ├── buildOutputcleanup/
│   │   ├── buildOutputcleanup
│   │   ├── cache.prperties
│   │   ├── outputFiles.bin
│   ├── kotlin/
│   │   ├── errors/
│   │   ├── sessions/
│   ├── noVersion/
│   │   ├── buildLogic.lock/
│   ├── noVersion/
│   │   ├── vcs-1/
│   ├── gc.properties
│   ├── app/
│   │   ├── .cxx/     
│   │   ├── src/
│   │   │   ├── debug/ 
│   │   │   │   ├── AndroidManifest.xml
│   │   │   ├── main/
│   │   │   │   ├── java/
│   │   │   │   │   ├── io/
│   │   │   │   │   │   ├── flutter/
│   │   │   │   │   │   │   └── GeneratedPluginRegistrant.java
│   │   │   │   ├── kotlin/
│   │   │   │   │   └─── MainActivity.kt
│   │   │   │   ├── res/
│   │   │   │   │   ├── drawable/
│   │   │   │   │   │   ├── launch_background.xml
│   │   │   │   │   ├── drawable-v21/
│   │   │   │   │   │   ├── launch_background.xml
│   │   │   │   │   ├── mipmap-hdpi/
│   │   │   │   │   │   ├── ic_launcher.png
│   │   │   │   │   ├── mipmap-mdpi/
│   │   │   │   │   │   ├── ic_launcher.png
│   │   │   │   │   ├── mipmap-xhdpi/
│   │   │   │   │   │   ├── ic_launcher.png
│   │   │   │   │   ├── mipmap-xxhdpi/
│   │   │   │   │   │   ├── ic_launcher.png
│   │   │   │   │   ├── mipmap-xxxhdpi/
│   │   │   │   │   │   ├── ic_launcher.png
│   │   │   │   │   ├── values/
│   │   │   │   │   │   ├── style.xml
│   │   │   │   │   ├── values-night/
│   │   │   │   │   │   └── style.xml
│   │   │   │   └── AndroidManifest.xml    
│   │   │   └── profile/         
│   │   └── build.gradle.kts
│   ├── gradle/
│   ├── .gitignore
│   ├── build.gradle.kts
│   ├── gestio_falla_android.iml
│   ├── gradle.properties
│   ├── gradlew
│   ├── gradlew.bat
│   ├── local.properties
│   └── settings.gradle.kts
├── build/
├── ios/
│   ├── Flutter/
│   │   ├── .AppFrameworkinfo.plist 
│   │   ├── Debug.xconfig
│   │   ├── flutter_export_environment.sh 
│   │   ├── Generated.xcconfig
│   │   └── Release.xcconfig
│   ├── Runner/
│   │   ├── Assets.xcassets/ 
│   │   ├── Base.Iproj/
│   │   ├── AppDelegate.swift
│   │   ├── GeneratedPluginRegistrant.h
│   │   ├── GeneratedPluginRegistrant.m
│   │   ├── Info.plist
│   │   └── Runner-Bridging-Header.h
│   ├── Runner.xcodeproj/
│   │   ├── project.xcworkspace/
│   │   │   ├── xcshareddata/
│   │   │   │   ├── IDEWorkspaceChecks.plist
│   │   │   │   └── WorkspaceSettings.xcsettings    
│   │   │   └── contents.xcworkspacedata
│   │   ├── xcshareddata/
│   │   │   └── xcschemes/
│   │   │   │   └── Runner.xcscheme
│   │   └── project.pbxproj
│   ├── Runner.xcworkspace/
│   │   ├── xcshareddata/
│   │   │   ├── IDEWorkspaceChecks.plist
│   │   │   └── WorkspaceSettings.xcsettings    
│   │   └──contents.xcworkspacedata    
│   ├── RunnerTests/
│   │   └── RunnerTests.swift
│   └── .gitignore
├── lib/
│   └── main.dart
├── linux/
│   ├── flutter/
│   │   └── ephemeral/
│   │   │   └── .plugin_symlinks/
│   ├── runner/
│   │   ├── CMakeList.txt
│   │   ├── main.cc
│   │   ├── my_application.cc
│   │   ├── my_application.h       
│   ├── .gitignore
│   └── CMakeList.txt
├── macos/ 
│   ├── Flutter/
│   │   ├── ephemeral/
│   │   │   ├── flutter_export_environment.sh
│   │   │   └── Flutter-Generated.xcconfig
│   │   ├── Flutter-Debug.xcconfig/  
│   │   ├── Flutter-Release.xcconfig/
│   │   └── GeneratedPluginRegistrant.swift/       
│   ├── Runner/
│   │   ├── Assets.xcassets/
│   │   │   ├── AppIcon.appiconset
│   │   │   │   ├── app_icon_16.png
│   │   │   │   ├── app_icon_32.png
│   │   │   │   ├── app_icon_64.png
│   │   │   │   ├── app_icon_128.png
│   │   │   │   ├── app_icon_256.png
│   │   │   │   ├── app_icon_512.png
│   │   │   │   ├── app_icon_1024.png
│   │   │   │   └── Contents.json  
│   │   ├── Base.Iproj/
│   │   │   └── MainMenu.xib
│   │   ├── Configs/
│   │   │   ├── AppInfo.xcconfig
│   │   │   ├── Debug.xcconfig
│   │   │   ├── Release.xcconfig
│   │   │   └── Warnings.xcconfig
│   │   ├── AppDelegate.swift
│   │   ├── DebugProfile.entitlements
│   │   ├── Info.plist
│   │   ├── MainFlutterWindow.swift
│   │   └── Release.entitlements      
│   ├── Runner.xcodeproj/
│   │   ├── project.xcworkspace/
│   │   │   └── IDEWorkspaceChecks.plist
│   │   ├── xcshareddata/ 
│   │   │   └── Runner.xcscheme 
│   │   └── project.pbxproj   
│   ├── Runner.xcworkspace/
│   │   ├── xcshareddata/
│   │   │   └── IDEWorkspaceChecks.plist
│   │   └── contents.xcworkspacedata  
│   ├── RunnerTets/
│   │   └── RunnerTests.swift  
│   └── .gitignore   
├── web/    
│   ├── icons/
│   │   ├── Icon-192.png 
│   │   ├── Icon-512.png
│   │   ├── Icon-maskable-192.png  
│   │   ├── Icon-maskable-512.png  
│   ├── favicon.png
│   ├── index.html
│   ├── manifest.json 
├── windows/
│   ├── flutter/
│   │   ├── ephemeral/
│   │   │   └── plugin_symlinks
│   │   ├── Flutter-Debug.xcconfig/  
│   │   ├── Flutter-Release.xcconfig/
│   │   └── GeneratedPluginRegistrant.swift/ 
│   ├── runner/
│   │   ├── resources/
│   │   │   └── app_icon.ico
│   │   ├── CMakeLists.txt  
│   │   ├── flutter_window.cpp
│   │   ├── flutter_window.h
│   │   ├── main.cpp
│   │   ├── resource.h
│   │   ├── runner.exe.manifest
│   │   ├── Runner.rc
│   │   ├── utils.cpp
│   │   ├── utils.h
│   │   ├── win32_window.cpp
│   │   └── win32_window.h   
│   ├── .gitignore
│   └── CMakeLists.txt
├── .flutter-plugins
├── .flutter-plugins-dependencies
├── .gitignore
├── .metadata
├── analysis_options.yaml
├── devtools_options.yaml
├── gestio_falla.iml
├── pubspec.yaml
└── README.md              
```
I se us obrira el main automàticament amb el següent contingut:

<p align= "center">
   <img src="../gestio_falla/assets/README/main de l&apos;aplicació.png" alt="Contingut del fitxer main.dart de l'aplicació" width="600"/>
</p>

Ara si voleu veure que és premeu **F5** o en el terminal escriviu:
```bash
flutter run
```
Tardara una estona en executar, no us preocupeu, que la primera vegada en Android ha d'instal·lar-se l'aplicació i afegir les dependències a l'aplicació, però quan acabe obrira automàticament l'aplicació.
Quan s'òbriga veureu el següent:

<p align= "center">
   <img src="../gestio_falla/assets/README/Pantalla demo inicial.jpg" alt="El primer que veus al executar l'aplicació" width="200"/>
</p>

Com veieu no és més que un simple comptador que al prémer al botó de *+* augmentara el valor per 1:

<p align= "center">
   <img src="../gestio_falla/assets/README/Pantalla demo al apretar el boto +.jpg" alt="El que veus al premer el botó de '+'" width="200"/>
</p>

I amb això ja hem generat una aplicació de flutter molt senzilla i funcional.

## Estructura de l'aplicació:
L'aplicació flutter té la següent estructura de directoris:
```bash
lib/
├── assets/
│   ├── logo/
│   │   └── foreground.png
│   └── FallaPortal.png
├── domain/
│   ├── entities/
│   │   ├── cobrador.dart
│   │   ├── event.dart
│   │   ├── faller.dart
│   │   ├── producte.dart
│   │   └── ticket.dart
│   └── repository/
│   │   ├── Api-Odoo_repository.dart
│   │   ├── mostraQR_repository.dart
│   │   ├── nfc_repository.dart
│   │   ├── notificacions_repository.dart
│   │   └── qr_repository.dart
├── infrastructure/
│   ├── data_source/
│   │   ├── Api-Odoo_datasource.dart
│   │   ├── Fake_Api-Odoo_datasource.dart
│   │   ├── mostraQR_datasource.dart
│   │   ├── nfc_datasource.dart
│   │   ├── notificacions_datasource.dart
│   │   └── qr_datasource.dart
│   └── repository/
│   │   ├── Api-Odoo_repository_impl.dart
│   │   ├── mostraQR_repository_impl.dart
│   │   ├── nfc_repository_impl.dart
│   │   ├── notificacions_repository_impl.dart
│   │   └── qr_repository_impl.dart
├── presentation/
│   ├── screens/
│   │   ├── admin_screen.dart
│   │   ├── afegir_membre.dart
│   │   ├── barra_screen.dart
│   │   ├── crear_familia_screen.dart
│   │   ├── descompta_cadira_screen.dart
│   │   ├── editar_perfil_screen.dart
│   │   ├── editar_usuari_screen.dart
│   │   ├── escaner.dart
│   │   ├── escudellar_screen.dart
│   │   ├── event_detallat_screen.dart
│   │   ├── events_screen.dart
│   │   ├── login_screen.dart
│   │   ├── mostra_QR_screen.dart
│   │   ├── perfil_screen.dart
│   │   ├── principal_screen.dart
│   │   ├── registrar_screen.dart
│   │   └── splash_screen.dart
│   ├── themes/
│   └── widgets/
├── provider/
│   ├── Api-OdooProvider.dart
│   ├── mostraQRProvider.dart
│   ├── nfcProvider.dart
│   ├── notificacionsProvider.dart
│   └── qrProvider.dart  
└── main.dart
```
Esta estructura de directoris seguix l'arquitectura *CLEAN* o també coneguda com *Clean Architecture*
## Dependències en el fitxer pubspec.yaml i com implementar-les:
### Provider
 Gestor d'estat de flutter, cal posar el següent en el yaml en l'apartat de `dependencies`:
 ```yaml
dependencies:
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
dependencies:
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
dependencies:
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
dependencies:
   mobile_scanner: ^3.0.0 #Versió de mobile_scanner utilitzada
 ```
 Ara executem:
 ```plaintext
 flutter pub get
 ```
### Mostrar QR (qr_flutter)
 Esta llibreria ens permet generar codis QR en la nostra aplicació, cal posar el següent en el yaml en l'apartat de `dependencies`:
  ```yaml
dependencies:
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
dependencies:
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
 **Si ho feu en VSCode aconselle que premeu Ctrl+f per a obrir un buscador i posar la línia que volem modificar perque el fitxer és molt llarg**
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
dependencies:
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
 Esta llibrearia ens permet posar el format d'hora que nosaltres vullgam potser tant *hh:mm:ss aaaa-mm-dd* com *dd-mm-aaaa hh:mm:ss* perque DateTime usa per defecte ** per exemple, cal posar en el següent en ´'apartat de `dependencies`:
  ```yaml
dependencies:
   intl: ^11.0.0  #Versió de intl utilitzada 
 ```
 Més documentació em [la pàgina oficial](https://pub.dev/packages/permission_handler)
### Posar una imatge
Per a posar una imatge ***que estiga definida en Flutter*** haurem de localitzar la imatge que volem que és vega i recomane posar-la en una carpeta **assets** perquè no es perda, després en el **pubspec.yaml** localitzem esta part:

```yaml
flutter:

   # The following line ensures that the Material Icons font is
   # included with your application, so that you can use the icons in
   # the material Icons class.
   uses-material-design: true
   assets:
```
I posem la ruta de la imatge de la següent forma:
```yaml
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true
  assets:
    - lib/assets/FallaPortal.png
``` 
I així es veuria la imatge dins de l'aplicació
```dart
// En codi
child: Image.asset(
  'lib/assets/FallaPortal.png',
  fit: BoxFit.fill,
),
```
En l'aplicació:
### Posar una icona a l'aplicació 
Paregut al que havíem fet abans per a posar una imatge ens dirigim al mateix apartat, però en lloc de **assests** és **flutter_launcher_icons**, però abans de mostrar-ho tens que inicialitzar-lo en l'apartat de dependències:

```yaml
dependencies:
  flutter_launcher_icons: ^0.14.3 #Versió de flutter_launcher_icons utilizada
```

```yaml
flutter_launcher_icons:
  android: true
  ios: true
  adaptive_icon_foreground: "assets/logo/foreground.png"
  adaptive_icon_background: "#FFFFFF"
```
### Resultat final del pubsec.yaml
Així quedaria el **pubspec.yaml** amb totes les modificacions:
```yaml
name: 'nom de la vostra aplicació'
description: "A new Flutter project."
# The following line prevents the package from being accidentally published to
# pub.dev using `flutter pub publish`. This is preferred for private packages.
publish_to: 'none' # Remove this line if you wish to publish to pub.dev

# The following defines the version and build number for your application.
# A version number is three numbers separated by dots, like 1.2.43
# followed by an optional build number separated by a +.
# Both the version and the builder number may be overridden in flutter
# build by specifying --build-name and --build-number, respectively.
# In Android, build-name is used as versionName while build-number used as versionCode.
# Read more about Android versioning at https://developer.android.com/studio/publish/versioning
# In iOS, build-name is used as CFBundleShortVersionString while build-number is used as CFBundleVersion.
# Read more about iOS versioning at
# https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CoreFoundationKeys.html
# In Windows, build-name is used as the major, minor, and patch parts
# of the product and file versions while build-number is used as the build suffix.
version: 1.0.0+1

environment:
  sdk: ^3.7.0

# Dependencies specify other packages that your package needs in order to work.
# To automatically upgrade your package dependencies to the latest versions
# consider running `flutter pub upgrade --major-versions`. Alternatively,
# dependencies can be manually updated by changing the version numbers below to
# the latest version available on pub.dev. To see which dependencies have newer
# versions available, run `flutter pub outdated`.
dependencies:
  flutter:
    sdk: flutter

  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.8
  provider: ^6.1.4
  nfc_manager: ^3.2.0
  http: ^1.3.0
  flutter_local_notifications: 15.1.1
  permission_handler: ^11.0.0
  mobile_scanner: ^3.0.0
  intl: ^0.18.0
  qr_flutter: ^4.0.0
  flutter_launcher_icons: ^0.14.3
  shared_preferences: ^2.0.15

dev_dependencies:
  flutter_test:
    sdk: flutter

  # The "flutter_lints" package below contains a set of recommended lints to
  # encourage good coding practices. The lint set provided by the package is
  # activated in the `analysis_options.yaml` file located at the root of your
  # package. See that file for information about deactivating specific lint
  # rules and activating additional ones.
  flutter_lints: ^5.0.0

# For information on the generic Dart part of this file, see the
# following page: https://dart.dev/tools/pub/pubspec

# The following section is specific to Flutter packages.
flutter:

  # The following line ensures that the Material Icons font is
  # included with your application, so that you can use the icons in
  # the material Icons class.
  uses-material-design: true
  assets:
    - lib/assets/FallaPortal.png
flutter_launcher_icons:
  android: true
  ios: true
  adaptive_icon_foreground: "assets/logo/foreground.png"
  adaptive_icon_background: "#FFFFFF"


  # To add assets to your application, add an assets section, like this:
  # assets:
  #   - images/a_dot_burr.jpeg
  #   - images/a_dot_ham.jpeg

  # An image asset can refer to one or more resolution-specific "variants", see
  # https://flutter.dev/to/resolution-aware-images

  # For details regarding adding assets from package dependencies, see
  # https://flutter.dev/to/asset-from-package

  # To add custom fonts to your application, add a fonts section here,
  # in this "flutter" section. Each entry in this list should have a
  # "family" key with the font family name, and a "fonts" key with a
  # list giving the asset and other descriptors for the font. For
  # example:
  # fonts:
  #   - family: Schyler
  #     fonts:
  #       - asset: fonts/Schyler-Regular.ttf
  #       - asset: fonts/Schyler-Italic.ttf
  #         style: italic
  #   - family: Trajan Pro
  #     fonts:
  #       - asset: fonts/TrajanPro.ttf
  #       - asset: fonts/TrajanPro_Bold.ttf
  #         weight: 700
  #
  # For details regarding fonts from package dependencies,
  # see https://flutter.dev/to/font-from-package
```