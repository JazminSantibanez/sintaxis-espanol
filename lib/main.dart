import "package:flutter/material.dart";
import 'package:sintaxis_espanol/variables.dart';
import 'package:sintaxis_espanol/menu.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

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
        home: AnimatedSplashScreen(

          splash:  Container(child: Image.asset('assets/images/sintaxlogo.png',)),
          nextScreen: Menu(),
          splashTransition: SplashTransition.rotationTransition,
          backgroundColor: SEColorScheme.lightBlue,
          duration: 1000,
          pageTransitionType: PageTransitionType.fade,
        ),
        //Menu(),
       /* Scaffold(
            appBar: AppBar(
              title: Text("Sintáxis Español"),
            ),
            body: SyntaxGame()) */
            );
  }
}

