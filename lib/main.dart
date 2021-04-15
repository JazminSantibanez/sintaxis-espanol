import "package:flutter/material.dart";
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:sintaxis_espanol/variables.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.black),
        home: Scaffold(
            appBar: AppBar(
              title: Text("Sintáxis Español"),
            ),
            body: SyntaxGame()));
  }
}

class SyntaxGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
        .
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
        ],
      ),
    );
  }
}

BoxDecoration roundBoxDecoration(
    {Color color = Colors.white,
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
          decoration: roundBoxDecoration(
              color: SEColorScheme.blue), //             <--- BoxDecoration here
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
              "Ordena las frases para que formen la oración correcta",
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
            decoration: roundBoxDecoration(color: SEColorScheme.black),
            child: FractionallySizedBox(
                child: Container(
                    child: Text(
                      "$text",
                      style:
                          TextStyle(fontSize: 11, color: SEColorScheme.white),
                      textAlign: TextAlign.center,
                    ),
                    alignment: Alignment.center),
                heightFactor: 1),
          ))
    ]));
  }
}

class SentenceSpot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: FractionallySizedBox(
      child: Container(
        decoration:
            roundBoxDecoration(borderColor: SEColorScheme.blue, borderWidth: 4),
      ),
      heightFactor: 0.8,
      widthFactor: 0.475,
    ));
  }
}

class SentenceSpots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [SentenceSpot(), SentenceSpot(), SentenceSpot()],
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      color: SEColorScheme.lightBlue,
    );
  }
}

class SentenceNum extends StatelessWidget {
  final int sentenceNo;
  final BuildContext context;

  SentenceNum(this.sentenceNo, {this.context});
  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: FractionallySizedBox(
      child: Container(
        decoration: roundBoxDecoration(color: SEColorScheme.gray),
        child: Text(
          "$sentenceNo°",
          style: TextStyle(color: SEColorScheme.white, fontSize: 16),
        ),
        alignment: Alignment.center,
      ),
      heightFactor: 0.5,
      widthFactor: 0.3,
    ));
  }
}

class SentenceNums extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [SentenceNum(1), SentenceNum(2), SentenceNum(3)],
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      ),
      color: SEColorScheme.white,
    );
  }
}
