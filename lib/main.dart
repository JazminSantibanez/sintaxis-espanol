import "package:flutter/material.dart";
import 'package:sintaxis_espanol/variables.dart';
import 'package:sintaxis_espanol/menu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sintáxis Español',
        theme: ThemeData(
            primaryColor: SEColorScheme.black,
            backgroundColor: SEColorScheme.white),
        home: Menu(),
       /* Scaffold(
            appBar: AppBar(
              title: Text("Sintáxis Español"),
            ),
            body: SyntaxGame()) */
            );
  }
}

