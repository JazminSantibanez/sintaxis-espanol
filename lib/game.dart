import 'dart:async';
import 'dart:math';
import 'dart:ui';
import "package:flutter/material.dart";
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sintaxis_espanol/databaseHelper.dart';
import 'package:sintaxis_espanol/lose.dart';
import 'package:sintaxis_espanol/menu.dart';
import 'package:sintaxis_espanol/variables.dart';
import 'package:rxdart/rxdart.dart';

class SyntaxGame extends StatelessWidget {
  final int score;
  final int streak;
  final Set<int> setOfIntsUsed;
  SyntaxGame(this.score, this.streak, this.setOfIntsUsed);
  static int globalScore;
  static int globalStreak;
  static Set<int> setOfInts;
  static final globalScoreSubject = BehaviorSubject<int>();
  static final globalStreakSubject = BehaviorSubject<int>();
  @override
  Widget build(BuildContext context) {
    globalStreak = streak;
    globalStreakSubject.add(streak);
    globalScore = score;
    globalScoreSubject.add(score);
    setOfInts = setOfIntsUsed;
    if (SyntaxGame.setOfInts.length >= 100) {
      limite();
      return Menu();
    } else
      return Scaffold(
        appBar: buildAppBar(),
        body: Game(),
      );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text(
        "Atrás",
        style: TextStyle(fontFamily: 'groovy', fontSize: 25),
      ),
    );
  }
}

class SentenceStr {
  String type;
  String content;
  int num;

  SentenceStr(this.num, this.type, this.content);

  @override
  String toString() {
    return '{ ${this.num},${this.type}, ${this.content} }';
  }
}

Future<List<SentenceStr>> randomSentence() async {
  int queryrows = await DatabaseHelper.instance.numRows();

  // Del total de número obtener un número random que no re repita
  Random random = new Random();
  int randomNumber = random.nextInt(queryrows) + 1;

  while (SyntaxGame.setOfInts.contains(randomNumber)) {
    randomNumber = random.nextInt(queryrows) + 1;
  }
  SyntaxGame.setOfInts.add(randomNumber);

  // obtener la fila que contiene el id del número random generado
  List<Map<String, dynamic>> s =
      await DatabaseHelper.instance.getSentencetById(randomNumber);
  print(s);

  // obtener cantidad de elementos que contiene la oración
  int qsentences = s.elementAt(0).values.elementAt(1);
  print(qsentences);

  // crear una lista que incluya el número de elementos de la lista
  int i = 0, cont = 0;
  List<SentenceStr> elemSen = [];

  while (cont < qsentences) {
    if (s.elementAt(0).values.elementAt(2 + i) != null) {
      String t = s.elementAt(0).keys.elementAt(2 + i);
      String c = s.elementAt(0).values.elementAt(2 + i);

      elemSen.add(SentenceStr(cont + 1, t, c));
      cont++;
    }
    i++;
  }
  // se ordena la lista
  elemSen.shuffle();
  //globals.elelist=elemSen;
  print(elemSen);
  return elemSen;
}

class Game extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future<List<SentenceStr>> lista = randomSentence();
    print(lista);

    return FutureBuilder<List<SentenceStr>>(
        future: lista,
        builder: (context, AsyncSnapshot<List<SentenceStr>> snapshot) {
          if (snapshot.hasData) {
            return Container(
              color: Colors.white,
              child: LayoutGrid(
                areas: '''
                        score error-streaks
                        instructions instructions
                        sentence-nums sentence-nums
                        sentence-spots sentence-spots
                        . .
                        sentence-parts sentence-parts
                        button-check button-check
                       ''',
                columnSizes: [1.fr, 1.fr],
                rowSizes: [
                  (1.2).fr,
                  (0.9).fr,
                  (0.8).fr,
                  (0.8).fr,
                  (0.325).fr,
                  (2.3).fr,
                  (1.8).fr,
                ],
                columnGap: 0.00,
                rowGap: 0.00,
                children: [
                  Score().inGridArea("score"),
                  ErrorStreak().inGridArea("error-streaks"),
                  Instructions().inGridArea("instructions"),
                  SentenceNums(snapshot.data).inGridArea("sentence-nums"),
                  SentenceSpots(snapshot.data.length)
                      .inGridArea("sentence-spots"),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (int i = 0; i < snapshot.data.length; i++)
                        Container(
                            child: Sentence(i + 1, snapshot.data[i].content),
                            width: double.infinity,
                            height: (MediaQuery.of(context).size.height *
                                0.28307692307 /
                                (snapshot.data.length + 1)))
                    ],
                  ).inGridArea("sentence-parts"),
                  BCheck().inGridArea("button-check"),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }
}

class ErrorStreakState extends State<ErrorStreak> {
  @override
  Widget build(BuildContext context) {
    SyntaxGame.globalStreakSubject.listen((newStreak) {
      if (this.mounted) {
        setState(() {});
      }
    });

    return Center(
      child: Row(
          children: [
            for (int i = 0; i < SyntaxGame.globalStreak; i++)
              Expanded(
                  child: FractionallySizedBox(
                      child: Image.asset('assets/images/streak.png'),
                      heightFactor: 0.5,
                      widthFactor: 0.5))
          ],
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly),
    );
  }
}

class ErrorStreak extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ErrorStreakState();
  }
}

BoxDecoration roundBoxDecoration(
    {Color color = SEColorScheme.white,
    Color borderColor = Colors.transparent,
    double borderRadius = 7.5,
    double borderWidth = 1}) {
  return BoxDecoration(
      border: Border.all(color: borderColor, width: borderWidth),
      borderRadius: BorderRadius.circular(borderRadius),
      color: color);
}

class ScoreState extends State<Score> {
  var scoreStr = SyntaxGame.globalScore.toString();

  @override
  Widget build(BuildContext context) {
    var totalWidth = MediaQuery.of(context).size.width;
    SyntaxGame.globalScoreSubject.listen((newScore) {
      if (this.mounted) {
        setState(() {
          scoreStr = newScore.toString();
        });
      }
    });

    return Row(
      children: [
        Container(
            child: Text(
              "Puntuación ",
              style: TextStyle(fontFamily: 'groovy', fontSize: 25),
            ),
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: totalWidth * 0.05)),
        Container(
          margin: EdgeInsets.only(left: totalWidth * 0.02),
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          decoration: roundBoxDecoration(color: SEColorScheme.blue),
          child: Text(scoreStr),
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
    );
  }
}

class Score extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ScoreState();
  }
}

TextStyle instructionTextStyle =
    new TextStyle(fontSize: 20, fontFamily: 'Helveticat');

class Instructions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: FractionallySizedBox(
            alignment: Alignment.center,
            widthFactor: 0.65,
            child: Text(
              "Ordena las frases para que formen la oración correcta.",
              style: instructionTextStyle,
              textAlign: TextAlign.center,
            )));
  }
}

class Sentence extends StatelessWidget {
  Sentence(this.sentenceNo, this.text);
  final String text;
  final int sentenceNo;

  @override
  Widget build(BuildContext context) {
    var totalWidth = MediaQuery.of(context).size.width;

    return Center(
        child: Stack(alignment: Alignment.centerRight, children: [
      FractionallySizedBox(
        widthFactor: 0.85,
        child: Container(
            decoration: roundBoxDecoration(color: SEColorScheme.gray),
            child: FractionallySizedBox(
                child: Container(
                    child: Text(
                      "$sentenceNo°",
                      style: TextStyle(fontSize: 17, fontFamily: 'Helveticat'),
                    ),
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(left: totalWidth * 0.075)),
                heightFactor: 1)),
      ),
      FractionallySizedBox(
          alignment: Alignment.centerRight,
          widthFactor: 0.65,
          child: Container(
            decoration: roundBoxDecoration(color: SEColorScheme.lightBlue),
            child: FractionallySizedBox(
                child: Container(
                    child: Text(
                      "$text",
                      style: TextStyle(
                          fontSize: 13,
                          color: SEColorScheme.black,
                          fontFamily: 'Helveticat'),
                      textAlign: TextAlign.center,
                    ),
                    alignment: Alignment.center),
                heightFactor: 1),
          ))
    ]));
  }
}

DragTarget<List> sentenceSpotDragSpot(int id) {
  bool accepted = false;
  int sentencePartNum;
  int sentenceNo;

  return DragTarget<List>(
    onWillAccept: (data) {
      // return !SentenceSpots.currentDraggablePositions.contains(data[1] as int);
      return true;
    },
    onAccept: (data) {
      // SentenceSpots.currentDraggablePositions[id-1] = data[1] as int;
      accepted = true;
      sentencePartNum = data.elementAt(0);
      sentenceNo = data.elementAt(1);
      if (id == sentencePartNum) {
        SentenceSpots.answers[id] = true;
      }
    },
    builder: (context, candidateData, rejectedData) => accepted
        ? Stack(
            children: [SentenceSpot(), SentenceNum(sentenceNo)],
            alignment: Alignment.center,
          )
        : SentenceSpot(),
  );
}

class SentenceSpot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var totalWidth = MediaQuery.of(context).size.width;

    return Container(
        decoration:
            roundBoxDecoration(borderColor: SEColorScheme.blue, borderWidth: 4),
        width: totalWidth * 0.185);
  }
}

class SentenceSpots extends StatelessWidget {
  final int sentenceCount;
  static List<bool> answers;
  static List<int> currentDraggablePositions;

  SentenceSpots(this.sentenceCount) {
    currentDraggablePositions = List<int>.filled(sentenceCount, 0);
  }

  @override
  Widget build(BuildContext context) {
    answers = List.filled(sentenceCount + 1, false);
    answers[0] = true;

    return Center(
        child: Container(
      child: Row(
        children: [
          for (int i = 0; i < sentenceCount; i++) sentenceSpotDragSpot(i + 1),
        ],
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      color: SEColorScheme.lightBlue,
    ));
  }
}

class SentenceNum extends StatelessWidget {
  final int sentenceNo;
  final BuildContext context;

  SentenceNum(this.sentenceNo, {this.context});
  @override
  Widget build(BuildContext context) {
    var totalWidth = MediaQuery.of(context).size.width;
    var totalHeight = MediaQuery.of(context).size.height;

    return Container(
      //decoration: roundBoxDecoration(color: SEColorScheme.gray, borderColor: SEColorScheme.black.withOpacity(.2), borderWidth: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: SEColorScheme.gray,
        boxShadow: [
          BoxShadow(
            color: SEColorScheme.black.withOpacity(.3),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 6), // changes position of shadow
          ),
        ],
      ),
      child: Text(
        "$sentenceNo°",
        style: TextStyle(
            color: SEColorScheme.white, fontSize: 18, fontFamily: 'Helveticat'),
      ),
      alignment: Alignment.center,
      width: totalWidth / 10,
      height: totalHeight / 22,
    );
  }
}

Widget sentenceNumDraggable(int sentencepart, int num, {BuildContext context}) {
  var totalWidth = MediaQuery.of(context).size.width;

  return LayoutBuilder(
    builder: (context, constraints) => Draggable<List>(
        data: [sentencepart, num],
        child: SentenceNum(num),
        feedback: Material(
            type: MaterialType.transparency,
            child: Container(
              height: constraints.maxHeight,
              child: SentenceNum(num),
            )),
        childWhenDragging: Container(width: totalWidth / 10)),
  );
}

class SentenceNums extends StatelessWidget {
  final List<SentenceStr> sentenceparts;
  SentenceNums(this.sentenceparts);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        child: Container(
          child: Row(
            children: [
              for (int i = 0; i < sentenceparts.length; i++)
                sentenceNumDraggable(sentenceparts.elementAt(i).num, i + 1,
                    context: context),
            ],
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          color: Colors.transparent,
        ),
        heightFactor: 0.5,
      ),
    );
  }
}

TextStyle buttonTStyle = new TextStyle(
  color: SEColorScheme.white,
  fontFamily: 'groovy',
  fontSize: 25,
);

class BCheck extends StatefulWidget {
  @override
  _ButtonCheck createState() => _ButtonCheck();
}

class _ButtonCheck extends State<BCheck> {
  bool _visible = true;
  bool _next = false;
  void _disappear() {
    if (this.mounted) {
      setState(() {
        _visible = false;
      });
    }
  }

  void _appear() {
    if (this.mounted) {
      setState(() {
        _visible = true;
      });
    }
  }

  void _appearnext() {
    if (this.mounted) {
      setState(() {
        _next = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AssetsAudioPlayer audioPlayer = AssetsAudioPlayer();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Visibility(
              visible: _next,
              child: TextButton(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Siguiente',
                      style: buttonTStyle,
                    ),
                  ),
                  style: TextButton.styleFrom(
                      backgroundColor: SEColorScheme.black,
                      shape: StadiumBorder(),
                      shadowColor: SEColorScheme.black,
                      elevation: 10),
                  onPressed: () {
                    Navigator.pop(context);

                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return Menu();
                    }));

                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return SyntaxGame(SyntaxGame.globalScore,
                          SyntaxGame.globalStreak, SyntaxGame.setOfInts);
                    }));
                  })),
          Visibility(
            visible: _visible,
            child: TextButton(
              onPressed: () async {
                bool win = true;
                for (int i = 0; i < SentenceSpots.answers.length; i++)
                  if (!SentenceSpots.answers[i]) {
                    win = false;
                    break;
                  }
                if (win) {
                  audioPlayer.open(
                    Audio('assets/sounds/win.wav'),
                  );
                  SyntaxGame.globalScore += 100;
                  SyntaxGame.globalScoreSubject.add(SyntaxGame.globalScore);
                  print(SyntaxGame.globalScore);
                  _disappear();
                  //_audioController.play(fileName);
                  winToast();
                  Timer(Duration(seconds: 3), () {
                    _appearnext();
                  });
                } else {
                  audioPlayer.open(
                    Audio('assets/sounds/lose.wav'),
                  );
                  SyntaxGame.globalStreak += 1;
                  SyntaxGame.globalStreakSubject.add(SyntaxGame.globalStreak);

                  // You lost
                  if (SyntaxGame.globalStreak == 3) {
                    updateMenuHighScore();

                    Navigator.popUntil(
                        context, (Route<dynamic> route) => false);

                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return Menu();
                    }));

                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return Lose();
                    }));
                  }
                  _disappear();
                  loseToast();
                  Timer(Duration(seconds: 3), () {
                    _appear();
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Comprobar',
                  style: buttonTStyle,
                ),
              ),
              style: TextButton.styleFrom(
                backgroundColor: SEColorScheme.black,
                shape: StadiumBorder(),
                shadowColor: SEColorScheme.black,
                elevation: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}

void updateHighScore(int currentScore) async {
  DatabaseHelper.instance.updateScore(currentScore);
}

void winToast() {
  Fluttertoast.showToast(
    msg: '¡Correcto! 🥳',
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.transparent,
    textColor: SEColorScheme.gray,
    fontSize: 40,
  );
}

void loseToast() {
  Fluttertoast.showToast(
    msg: '¡Incorrecto! 🤡',
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.transparent,
    textColor: SEColorScheme.gray,
    fontSize: 40,
  );
}

void limite() {
  Fluttertoast.showToast(
    msg: '¡has contestado todas las preguntas! 😯',
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: SEColorScheme.white,
    textColor: SEColorScheme.black,
    fontSize: 40,
  );
}
