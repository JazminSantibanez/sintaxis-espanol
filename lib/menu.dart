import 'dart:io';

import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:sintaxis_espanol/game.dart';
import 'package:sintaxis_espanol/variables.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';

import 'databaseHelper.dart';
import 'helpScreen.dart';

class Menu extends StatelessWidget {
  static int highestScore = 0;

  Menu();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: buildAppBar(),
      body: Body(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("Sintáxis Español"),
    );
  }
}

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //nos da la altura y anchura de la pantalla
    //Size size = MediaQuery.of(context).size;
    return Container(
      color: SEColorScheme.lightBlue,
      child: LayoutGrid(
        areas: '''
        Logo
        ButtonGame
        ButtonStreak
        ButtonHelp
        ''',
        columnSizes: [1.fr],
        rowSizes: [
          (.5).fr,
          (.5).fr,
          (.5).fr,
          (.5).fr,
        ],
        columnGap: 0.00,
        rowGap: 0.00,
        children: [
          Logo().inGridArea("Logo"),
          ButtonGame().inGridArea("ButtonGame"),
          ButtonStreak().inGridArea("ButtonStreak"),
          ButtonHelp().inGridArea("ButtonHelp")
        ],
      ),
    );
  }
}

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(top: 55.0),
      child: Image.asset(
        "assets/images/sintaxlogo.png",
        height: 100,
        width: 400,
        fit: BoxFit.fitWidth,
      ),
    ));
  }
}

TextStyle buttonTStyle = new TextStyle(
  color: SEColorScheme.white,
  fontSize: 25,
  fontFamily: 'Helveticat',
);

class ButtonGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        //color: SEColorScheme.black ,
        child: Center(
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Image.asset(
          "assets/icons/prize.png",
          height: 80,
          width: 80,
          fit: BoxFit.fitWidth,
        ),
        TextButton(
          onPressed: () {
            int score = 0;
            int streak = 0;
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => SyntaxGame(score, streak)));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Nueva Partida',
              style: buttonTStyle,
            ),
          ),
          style: TextButton.styleFrom(
            backgroundColor: SEColorScheme.black,
            shape: StadiumBorder(),
          ),
        ),
      ]),
    ));
  }
}

Future<int> updateHighScoreWithDelay() {
  sleep(Duration(seconds: 3));
  return DatabaseHelper.instance.getHighScore();
}

class ButtonStreak extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ButtonStreakState();
  }
}

class ButtonStreakState extends State<ButtonStreak> {
  @override
  Widget build(BuildContext context) {
    var highScoreQuery = DatabaseHelper.instance
        .getHighScore()
        .then((value) => Menu.highestScore = value);

    return FutureBuilder<int>(
        future: highScoreQuery,
        builder: (context, AsyncSnapshot<int> snapshot) {
          if (snapshot.hasData) {
            return Container(
                child: Center(
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Image.asset(
                  "assets/icons/fire.png",
                  height: 80,
                  width: 80,
                  fit: BoxFit.fitWidth,
                ),
                TextButton(
                  onPressed: () async {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      'Mejor Partida: ' + snapshot.data.toString(),
                      style: buttonTStyle,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: SEColorScheme.black,
                    shape: StadiumBorder(),
                  ),
                ),
              ]),
            ));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

void openHelpScreen(BuildContext context) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => HelpScreen()));
}

class ButtonHelp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: IconButton(
      icon: Icon(Icons.help),
      color: SEColorScheme.white,
      onPressed: () {
        openHelpScreen(context);
      },
    ));
  }
}
