import "package:flutter/material.dart";

class HelpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Help(),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text("Atrás"),
    );
  }
}

class Help extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Image.asset("assets/images/streak.png",
        width: double.infinity, height: double.infinity);
  }
}
