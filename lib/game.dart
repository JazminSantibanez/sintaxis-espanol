import 'dart:async';
import 'dart:math';

import "package:flutter/material.dart";
import 'package:flutter_layout_grid/flutter_layout_grid.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sintaxis_espanol/databaseHelper.dart';
import 'package:sintaxis_espanol/variables.dart';
//import 'package:sintaxis_espanol/globals.dart' as globals;

Set<int> setOfInts = Set();

class SyntaxGame extends StatelessWidget {
  final int score;
  SyntaxGame(this.score);
  static int globalScore;
  @override
  Widget build(BuildContext context) {
      globalScore = score;
    return Scaffold(
      appBar: buildAppBar(),
      body: Game(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("Atrás"),
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
  List<SentenceStr> elemSen = [];

  while (cont < qsentences) {
    if (s.elementAt(0).values.elementAt(2 + i) != null) {
      String t = s.elementAt(0).keys.elementAt(2 + i);
      String c = s.elementAt(0).values.elementAt(2 + i);

      elemSen.add(SentenceStr(cont+1, t, c));
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
              color: Colors.transparent,
              child: LayoutGrid(
                areas: '''
        score
        instructions
        sentence-nums
        sentence-spots
        .
        sentence-parts
        buttonCheck
        ''',
                columnSizes: [1.fr],
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
                  Instructions().inGridArea("instructions"),
                  SentenceNums(snapshot.data)
                      .inGridArea("sentence-nums"),
                  SentenceSpots(snapshot.data.length)
                      .inGridArea("sentence-spots"),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (int i = 0; i < snapshot.data.length; i++)
                        Container(child: Sentence(i + 1, snapshot.data[i].content), width: double.infinity, height: (MediaQuery.of(context).size.height * 0.28307692307 / (snapshot.data.length + 1)))
                    ],
                  ).inGridArea("sentence-parts"),
                  BCheck().inGridArea("buttonCheck"),
                ],
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
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
  int points = SyntaxGame.globalScore;

  @override
  Widget build(BuildContext context) {
    var totalWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Container(
            child: Text("Puntuación "),
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: totalWidth * 0.05)),
        Container(
          margin: EdgeInsets.only(left: totalWidth * 0.02),
          padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
          decoration: roundBoxDecoration(color: SEColorScheme.blue),
          child: Text(points.toString()),
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

DragTarget<List> sentenceSpotDragSpot(int id) {

  bool accepted = false;
  int sentencePartNum;
  int sentenceNo;
 

  return DragTarget<List>(
    onWillAccept: (data) {
      return true;
    },
    onAccept: (data) {
      accepted = true;
      sentencePartNum = data.elementAt(0);
      sentenceNo = data.elementAt(1);
      if(id == sentencePartNum){
        SentenceSpots.answers[id]=true;
        print(SentenceSpots.answers[id].toString());
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
    static var  answers;
  SentenceSpots(this.sentenceCount);
  @override
  Widget build(BuildContext context) {
    answers = List.filled(sentenceCount+1, false);
    answers[0]=true; 
    return Center(
        child: Container(
      child: Row(
        children: [
          for (int i = 0; i < sentenceCount; i++) sentenceSpotDragSpot(i+1),
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
  final List<SentenceStr>sentenceparts;
  SentenceNums(this.sentenceparts);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        child: Container(
          child: Row(
            children: [
              for (int i = 0; i < sentenceparts.length; i++)
                sentenceNumDraggable(sentenceparts.elementAt(i).num, i+1,context: context),
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

class BCheck extends StatefulWidget {
  @override
  _ButtonCheck createState() => _ButtonCheck();
}

class _ButtonCheck extends State<BCheck> {
  bool _visible =true;
  bool _next =false;
  void _disappear(){
    setState(() {
      _visible = false;
    });
    
  }
    void _appear(){
    setState(() {
      _visible = true;
    });
    }
    void _appearnext(){
    setState(() {
      _next = true;
    });
    }
  @override
  Widget build(BuildContext context) {
   
    return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[ Visibility( visible: _next,
            child: TextButton(child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Next',
                      style: buttonTStyle,
                    ),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: SEColorScheme.black,
                    shape: StadiumBorder(),
                  ), onPressed: () {  
                      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
                     return SyntaxGame( SyntaxGame.globalScore);
                 
                  }));
                  }
          )),
            Visibility(
              visible: _visible,
              child: TextButton(
                onPressed: () async {
                  bool win =true;
                  for(int i=0;i<SentenceSpots.answers.length;i++)
                
                    if(!SentenceSpots.answers[i]){
                      win=false;
                      break;
                    }
                  if(win){ 
                    SyntaxGame.globalScore +=100;
                    print(SyntaxGame.globalScore);
                    _disappear();
                    winToast();
                    Timer(Duration(seconds: 3), () {
                        _appearnext();
                    });
                    
                  }
                  
                  else{
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
                ),
              ),
            )
          ],
        ),
      );
  }
}

void winToast(){
  
              
              Fluttertoast.showToast(
                msg: '¡Correcto!🥳',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.transparent,
                textColor: SEColorScheme.gray,
                fontSize: 40,
              );
              ButtonNext();
              

}
void loseToast(){
              
              Fluttertoast.showToast(
                msg: '¡Incorrecto!🤬',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.transparent,
                textColor: SEColorScheme.gray,
                fontSize: 40,
              );


}

class ButtonNext extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[TextButton(
                onPressed: () async {
                

                },
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
                ),
              ),
          ],
        ),
      );
  }
}

