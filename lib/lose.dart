import 'dart:async';

import "package:flutter/material.dart";
import 'package:sintaxis_espanol/menu.dart';
import 'package:sintaxis_espanol/variables.dart';

import 'game.dart';

class Lose extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      appBar: buildAppBar(),
      body: LoseScreen(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("Menú principal",
          style: TextStyle(fontFamily: 'groovy', fontSize: 25)),
    );
  }
}

void updateMenuHighScore() {
  print(
      "Your score was ${SyntaxGame.globalScore}. Your highscore is ${Menu.highestScore}.");
  print(
      "So the score was ${SyntaxGame.globalScore > Menu.highestScore ? '' : 'not'} replaced.");
  if (SyntaxGame.globalScore > Menu.highestScore) {
    updateHighScore(SyntaxGame.globalScore);
    Menu.highestScore = SyntaxGame.globalScore;
  }
  print("The new highscore is ${Menu.highestScore}.");
  SyntaxGame.globalScore = 0;
}

class LoseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      Image.asset("assets/images/instrucciones.png",
          width: double.infinity, height: double.infinity);
    });

    return Container(
      alignment: Alignment.center,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(
          'Perdiste',
          style: TextStyle(
              fontFamily: 'groovy', fontSize: 120, color: SEColorScheme.white),
        ),
        Text('😖', style: TextStyle(fontSize: 150)),
      ]),
    );
  }
}
