import 'package:flutter/material.dart';
import 'CalculatorLanding.dart';
import 'dart:math';

void main() => runApp(new Calculator());

// entry for the rest of the app 
class Calculator extends StatelessWidget {
  // colors available for the app
  static const List<MaterialColor> prettyColors = [Colors.amber, Colors.teal, Colors.lightGreen, Colors.cyan, Colors.blueGrey, Colors.orange];

  // builds the main container widget 
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: "Calculator App",
      theme: ThemeData(
        primaryColor: getThemeColor(),
        textTheme: Theme.of(context).textTheme.apply(
          fontFamily: 'Baloo 2',
          fontSizeDelta: 30
        )
      ), 
      home: new CalculatorLanding(),
    );
  }

  // randomly select the base color used for the calculator 
  MaterialColor getThemeColor() => prettyColors[new Random().nextInt(prettyColors.length)];
}