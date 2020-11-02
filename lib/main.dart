import 'package:flutter/material.dart';
import 'package:roger/ui/accueil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter avec Sum\'s',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AccueilPrincipal(),
    );
  }
}
