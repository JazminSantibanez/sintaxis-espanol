import "package:flutter/material.dart";
import 'package:sintaxis_espanol/variables.dart';

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: SEColorScheme.white,
      appBar: buildAppBar(),
      body: Help(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("Menú principal",style:TextStyle(fontFamily: 'groovy', fontSize: 25)),
    );
  }
}


class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
          return ListView(
  padding: const EdgeInsets.all(1),
  children: <Widget>[
    Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Image.asset('assets/images/intro.png')
    ),
    Container(
      width: MediaQuery.of(context).size.width,
      child: Image.asset('assets/images/1.png')
    ),
    Container(
      width: MediaQuery.of(context).size.width,
      child: Image.asset('assets/images/2.png')
    ),
    Container(
      width: MediaQuery.of(context).size.width,
      child: Image.asset('assets/images/3.png')
    ),
     Container(
      width: MediaQuery.of(context).size.width,
      child: Image.asset('assets/images/4.png')
    ),
  ],
);
      
  }
}