import 'package:flutter/material.dart';
import 'package:sintaxis_espanol/game.dart';
import 'package:sintaxis_espanol/variables.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';


class Menu extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: buildAppBar(),
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
  Widget build(BuildContext context){
    //nos da la altura y anchura de la pantalla
    //Size size = MediaQuery.of(context).size;
    return Container(
      color: SEColorScheme.lightBlue,
      child: LayoutGrid(
        areas: '''
        Logo
        ButtonGame
        ButtonStreak
        .
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
        ],
      ),

    

    );

  }

}
class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset("assets/images/logoto.png", height: 100,
                         width: 300, fit: BoxFit.fitWidth,)
            );
  }
}

TextStyle buttonTStyle = new TextStyle(color:SEColorScheme.white,fontSize: 25,fontFamily:'Helvetica',);

class ButtonGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      //color: SEColorScheme.black ,
        child:Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Image.asset("assets/icons/prize.png",height: 80,
                             width: 80, fit: BoxFit.fitWidth,),
            TextButton(
              onPressed: (){
                Navigator.of(context).push( 
                  MaterialPageRoute(
                    builder: (context) => SyntaxGame()
                    )
                );

              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text('Nueva Partida', style: buttonTStyle,),
              ),
              style: TextButton.styleFrom(
                backgroundColor: SEColorScheme.black,
                shape: StadiumBorder(),
              ),
            ),
                           
            ]
          ),
        )
        
            );
  }
}

class ButtonStreak extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
         child:Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Image.asset("assets/icons/fire.png",height: 80,
                             width: 80, fit: BoxFit.fitWidth,),
            TextButton(
              onPressed: (){},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Text('Mejor Partida', style: buttonTStyle,),
              ),
              style: TextButton.styleFrom(
                backgroundColor: SEColorScheme.black,
                shape: StadiumBorder(),
              ),
            ),
                           
            ]
          ),
        )
        
            );
  }
}

