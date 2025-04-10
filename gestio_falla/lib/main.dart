import 'package:flutter/material.dart';
import 'package:gestio_falla/presentation/screens/principal_screen.dart';


void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Falla Portal',
      debugShowCheckedModeBanner: true,
      home: PrincipalScreen(),
    );
  }
}



