import 'package:flutter/material.dart';
import 'package:sintaxis_espanol/variables.dart';
import 'package:flutter_layout_grid/flutter_layout_grid.dart';


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

      /*children:[
       Image.asset("assets/images/logofake.png", height: 100,
                         width: 300, fit: BoxFit.fitWidth,),
        Row(
          child: TextButton(onPressed: onPressed, )
        ),
       Row()
          ], */

    );

  }

}
class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset("assets/images/logofake.png", height: 100,
                         width: 300, fit: BoxFit.fitWidth,)
            );
  }
}
class ButtonGame extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset("assets/images/logofake.png", height: 100,
                         width: 300, fit: BoxFit.fitWidth,)
            );
  }
}

class ButtonStreak extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Image.asset("assets/images/logofake.png", height: 100,
                         width: 300, fit: BoxFit.fitWidth,)
            );
  }
}