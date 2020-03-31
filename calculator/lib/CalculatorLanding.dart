import 'package:flutter/material.dart';
import 'CalculatorFormatting.dart';

class CalculatorLanding extends StatefulWidget {
  @override 
  State createState() => new CalculatorState(); 
}

class CalculatorState extends State<CalculatorLanding>{
  bool _evaluate = false;
  String _evalStmt = "";  

  @override 
  Widget build(BuildContext context) { 
    MaterialColor themeColor = Theme.of(context).primaryColor;
    return new Scaffold(
      // layout for the button grid
      body: Column(
        children: <Widget>[
          Expanded( // fills the rest of the space not taken up by the buttons
            // stack lays widgets on top of each other 
            child: Stack(
              children: <Widget>[
                Container(  // bottom widget - background 
                  color: themeColor[50]
                ), 
                Text(_evalStmt)
              ]
            )
          ),
          CalculatorFormatting.getCalcButtonLayout(themeColor, updateEvaluation)
        ]
      )
    );
  }

  // responds to button clicks by updating state 
  bool updateEvaluation(String token) {
    switch (token) { 
      // if token indicates clear 
      case "AC": {
        setState(() {
          _evalStmt = "0"; 
        }); 
        return true; 
      }
      break; 
      // if token indicates evaluation 
      case "=": {
        setState(() {
          _evaluate = true; 
          _evalStmt = "0";
        }); 
        return true; 
      }
      break; 
      // make statement negative if positive and positive if already negative 
      case "+/-": {
        setState(() {
          _evalStmt = (_evalStmt.substring(0, 1) == "-") ? _evalStmt.substring(1) : "-" + _evalStmt; 
        }); 
        return true; 
      }
      break; 
    }
    // if the input token is a number or an operator following a number 
    // case too complicated to put in switch 
    RegExp nums = new RegExp(r"[0-9]"); 
    if (nums.hasMatch(token) | (_evalStmt.length > 0 && nums.hasMatch(_evalStmt.substring(_evalStmt.length-1)))) { 
      setState(() {
        _evalStmt = (_evalStmt == "0" && nums.hasMatch(token)) ? token : _evalStmt += token; 
      }); 
      return true; 
    }
    return false; 
  }
}