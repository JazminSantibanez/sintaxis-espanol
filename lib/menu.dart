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
        .
        ButtonStreak
        ButtonHelp
        ''',
        columnSizes: [1.fr],
        rowSizes: [
          (.5).fr,
          (.5).fr,
          (.2).fr,
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
    return Container(
      alignment: Alignment.bottomCenter,
      child: Image.asset(
        "assets/images/sintaxlogo.png",
        width: double.infinity,
      ),
    );
  }
}

TextStyle buttonTStyle = new TextStyle(
  color: SEColorScheme.white,
  fontSize: 35,
  fontFamily: 'groovy',
);

class ButtonGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(alignment: Alignment.center, children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * .07,
          width: MediaQuery.of(context).size.width * .55,
          child: TextButton(
            onPressed: () {
              int score = 0;
              int streak = 0;
              Set<int> setOfInts = Set();
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SyntaxGame(score, streak,setOfInts)));
            },
            child: Container(
              alignment: Alignment.centerRight,
              child: Text(
                'Nueva Partida',
                style: buttonTStyle,
              ),
            ),
            style: TextButton.styleFrom(
              backgroundColor: SEColorScheme.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              shadowColor: SEColorScheme.blue,
              elevation: 10,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 53.0),
          child: Container(
            child: Image.asset(
              "assets/icons/prize.png",
              height: MediaQuery.of(context).size.height * .155,
            ),
            alignment: Alignment.topLeft,
          ),
        ),
      ]),
    );
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
            return Column(children: [
              Image.asset(
                'assets/images/rank.png',
                height: MediaQuery.of(context).size.height / 10,
              ),
              Container(
                child: Row(
                  children: [Stack(children:[
                    /*Text('Mejor Puntaje: ',
                         style: TextStyle(
        fontSize: 35,
        foreground: Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 6
          ..color = SEColorScheme.white, fontFamily: 'groovy'
      )),*/Text('Mejor Puntaje: ',
                        style: const TextStyle(
                          fontSize: 35,
                          fontFamily: 'groovy',
                          color: SEColorScheme.black,
                        ))
                        ]),
                    Text(snapshot.data.toString(),
                        style: const TextStyle(
                            fontSize: 35,
                            fontFamily: 'fatnumbers',
                            color: SEColorScheme.black)),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ),
                alignment: Alignment.topCenter,
              )
            ]);
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
      icon: Icon(Icons.help_outline_rounded),
      iconSize: MediaQuery.of(context).size.height * .1,
      color: SEColorScheme.black,
      onPressed: () {
        openHelpScreen(context);
      },
    ));
  }
}
