import 'dart:math';

import "package:flutter/material.dart";
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sintaxis_espanol/databaseHelper.dart';
import 'package:sintaxis_espanol/variables.dart';
import 'package:sqflite/sqflite.dart';

Set<int> setOfInts = Set();

class SyntaxGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Game(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("Sintáxis Español"),
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

void randomSentence() async {
  int queryrows = await DatabaseHelper.instance.numRows();

  // Del total de número obtener un número random que no re repita
  Random random = new Random();
  int randomNumber = random.nextInt(queryrows) + 1;

  while (setOfInts.contains(randomNumber)) {
    randomNumber = random.nextInt(queryrows) + 1;
  }
  setOfInts.add(randomNumber);

  // obtener la fila que contiene el id del número random generado
  List<Map<String, dynamic>> s =
      await DatabaseHelper.instance.getSentencetById(randomNumber);
  print(s);

  // obtener cantidad de elementos que contiene la oración
  int qsentences = s.elementAt(0).values.elementAt(1);
  print(qsentences);

  // crear una lista que incluya el número de elementos de la lista
  int i = 0, cont = 0;
  List elemSen = [];
  Set<int> setOfInts2 = Set();

  while (cont < qsentences) {
    if (s.elementAt(0).values.elementAt(2 + i) != null) {
      String t = s.elementAt(0).keys.elementAt(2 + i);
      String c = s.elementAt(0).values.elementAt(2 + i);

      Random random2 = new Random();
      int randomNumber2 = random2.nextInt(qsentences) + 1;

      while (setOfInts2.contains(randomNumber2)) {
        randomNumber2 = random2.nextInt(qsentences) + 1;
      }

      setOfInts2.add(randomNumber2);

      elemSen.add(SentenceStr(randomNumber2, t, c));
      cont++;
    }
    i++;
  }
  // se ordena la lista
  elemSen.sort((a, b) => a.num.compareTo(b.num));
  print(elemSen);
  //return elemSen;
}

class Game extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    randomSentence();

    return Container(
      color: Colors.transparent,
      child: LayoutGrid(
        areas: '''
        score
        instructions
        sentence-nums
        sentence-spots
        .
        sentence-1
        .
        sentence-2
        .
        sentence-3
        buttonCheck
        ''',
        columnSizes: [1.fr],
        rowSizes: [
          (1.2).fr,
          (0.9).fr,
          (0.8).fr,
          (0.8).fr,
          (0.325).fr,
          (0.5).fr,
          (0.4).fr,
          (0.5).fr,
          (0.4).fr,
          (0.5).fr,
          (1.8).fr,
        ],
        columnGap: 0.00,
        rowGap: 0.00,
        children: [
          Score().inGridArea("score"),
          Instructions().inGridArea("instructions"),
          SentenceNums().inGridArea("sentence-nums"),
          SentenceSpots().inGridArea("sentence-spots"),
          Sentence(1, "Tiene").inGridArea("sentence-1"),
          Sentence(2, "Una de cada seis estrellas del tamaño de nuestro sol")
              .inGridArea("sentence-2"),
          Sentence(3, "Un planeta similar al nuestro").inGridArea("sentence-3"),
          ButtonCheck().inGridArea("buttonCheck"),
        ],
      ),
    );
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
  @override
  Widget build(BuildContext context) {
    var totalWidth = MediaQuery.of(context).size.width;

    return Row(
      children: [
        Container(
            child: Text("Puntuación"),
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: totalWidth * 0.05)),
        Container(
          margin: EdgeInsets.only(left: totalWidth * 0.02),
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          decoration: roundBoxDecoration(color: SEColorScheme.blue),
          child: Text(2345.toString()),
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

TextStyle instructionTextStyle = new TextStyle(fontSize: 17);

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
                      style: TextStyle(fontSize: 17),
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
                      style:
                          TextStyle(fontSize: 11, color: SEColorScheme.black),
                      textAlign: TextAlign.center,
                    ),
                    alignment: Alignment.center),
                heightFactor: 1),
          ))
    ]));
  }
}

DragTarget<int> sentenceSpotDragSpot() {
  bool accepted = false;
  int sentenceNum;

  return DragTarget<int>(
    onWillAccept: (data) {
      return true;
    },
    onAccept: (data) {
      accepted = true;
      sentenceNum = data;
    },
    builder: (context, candidateData, rejectedData) => accepted
        ? Stack(
            children: [SentenceSpot(), SentenceNum(sentenceNum)],
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
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      child: Row(
        children: [
          sentenceSpotDragSpot(),
          sentenceSpotDragSpot(),
          sentenceSpotDragSpot()
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
      decoration: roundBoxDecoration(color: SEColorScheme.gray),
      child: Text(
        "$sentenceNo°",
        style: TextStyle(color: SEColorScheme.white, fontSize: 16),
      ),
      alignment: Alignment.center,
      width: totalWidth / 10,
      height: totalHeight / 22,
    );
  }
}

Widget sentenceNumDraggable(int sentenceNum, {BuildContext context}) {
  var totalWidth = MediaQuery.of(context).size.width;

  return LayoutBuilder(
    builder: (context, constraints) => Draggable<int>(
        data: sentenceNum,
        child: SentenceNum(sentenceNum),
        feedback: Material(
            type: MaterialType.transparency,
            child: Container(
              height: constraints.maxHeight,
              child: SentenceNum(sentenceNum),
            )),
        childWhenDragging: Container(width: totalWidth / 10)),
  );
}

class SentenceNums extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        child: Container(
          child: Row(
            children: [
              sentenceNumDraggable(1, context: context),
              sentenceNumDraggable(2, context: context),
              sentenceNumDraggable(3, context: context),
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
  fontSize: 15,
);
TextStyle toastStyle = new TextStyle(
  color: SEColorScheme.white,
  fontSize: 25,
);

class ButtonCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          TextButton(
            onPressed: () async {
              Fluttertoast.showToast(
                msg: '¡Correcto!🥳',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: SEColorScheme.white,
                textColor: SEColorScheme.gray,
                fontSize: 40,
              );
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
            ),
          )
        ],
      ),
    );
  }
}
