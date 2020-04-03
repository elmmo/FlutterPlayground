import 'package:flutter/material.dart';
import 'CalculatorFormatting.dart';

class CalculatorLanding extends StatefulWidget {
  @override 
  State createState() => new CalculatorState(); 
}

class CalculatorState extends State<CalculatorLanding>{
  bool _evaluate = false;
  String _evalStmt = "";                 // current statement 
  List<String> _entries = new List();    // past statements 
  List<String> _evalTokens = new List(); // the list of tokens

  @override 
  Widget build(BuildContext context) { 
    MaterialColor themeColor = Theme.of(context).primaryColor;
    return new Scaffold(
      // layout for the button grid
      body: Column(
        children: <Widget>[
          Expanded( // fills the rest of the space not taken up by the buttons
            child: Container(
              color: themeColor[50],
              padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: CalculatorFormatting.getCalcEntries(_entries)
                  ),
                  Align(
                    alignment: Alignment.bottomRight, 
                    child: Container( 
                      height: 50,
                      child: Text(_evalStmt)
                    )
                  ),
                ]
                )
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
        _entries.add(_evalStmt + "=");
        print(_evalStmt);
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
          if (_evalStmt.substring(0,1) == "-") {
            _evalStmt = _evalStmt.substring(2, _evalStmt.length-1);
            // could put in a regex but flutter doesn't have a removeAll function
            _evalTokens.remove("-");
            _evalTokens.remove("one");
            _evalTokens.remove("(");
            _evalTokens.remove(")");
          } else { 
            _evalStmt = "-(" + _evalStmt + ")"; 
            // need to do separately to provide proper tokens to the parser 
            _evalTokens.insert(0, "-");
            _evalTokens.insert(1, "one"); // uses the one identifier to prevent clashes with user input 
            _evalTokens.insert(3, "(");
            _evalTokens.add(")");
          }
        }); 
        return true; 
      }
      break; 
    }
    // if the input token is a number or an operator following a number 
    // case too complicated to put in switch 
    RegExp nums = new RegExp(r"[0-9]|\)"); 
    if (nums.hasMatch(token) | (_evalStmt.length > 0 && nums.hasMatch(_evalStmt.substring(_evalStmt.length-1)))) { 
      setState(() {
        _evalStmt = (_evalStmt == "0" && nums.hasMatch(token)) ? token : _evalStmt += token; 
      }); 
      return true; 
    }
    return false; 
  }
}