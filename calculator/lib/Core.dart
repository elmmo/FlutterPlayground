import 'dart:math';
// recursive descent parser for calculator language 

class Core {
  List<ValueNode> exeList = new List<ValueNode>();

  // entry point for the descent parser 
  // would return double calculation in full implmentation
  double calculate(List tokens) {
    _program(tokens); 
    print("EXE LIST:");
    for (int i = 0; i < exeList.length; i++) {
      print(exeList[i].strValue);
    }
  }

  // create value node that update state and value 
  void _addValueNode(String strValue, [int intValue]) {
    ValueNode node = (intValue == null) ? new ValueNode(strValue, intValue) : new ValueNode(strValue); 
    exeList.add(node); 
  }

  // removes the first element of remaining arr
  void _consumeInputToken(String expected, List arr) {
    arr.removeAt(0);
    print(expected + " consumed"); 
  }

  // ensures that the token to be consumed is the one we're looking for 
  void _match(String expected, List arr) {
    if (arr[0] == expected) {
      _consumeInputToken(expected, arr);
    } else {
      throw Exception('Match was called but expected did not match'); 
    }
  }
  
  // start of the recursive descent parser 
  void _program(List arr) {
    _stmtList(arr);
    _match("=", arr);
  }

  // searching for list items after stmt 
  List _stmtList(List arr) {
    String token = arr[0];
    if (token == "=") { // if nothing was entered 
      return arr; 
    } else {
      _stmt(arr); 
      _stmtList(arr);
    }
  }

  // reference grammar 
  void _stmt(List arr) {
    String token = arr[0];
    // if negative expression 
    if (token == "-") {
      _match("-", arr);        // remove symbols 
      _match("one", arr);
      _addValueNode("-1", -1); // replace symbols with executables 
      _addValueNode("*"); 
      _expr(arr);
    } else {
      _expr(arr); 
    }
  }

  // reference grammar 
  double _expr(List arr) {
    _term(arr);
    if (arr.length > 1) _termTail(arr);   // checking if term_tail is possible
  }

  // searching for list items after term 
  void _termTail(List arr) {
    String token = arr[0];
    if (token == "+" || token == "-") {
      _addOp(arr);
      _term(arr);
      _termTail(arr);
    }
  }

  // reference grammar 
  void _term(List arr) {
    _factor(arr);
    if (arr.length > 1) _factorTail(arr); 
  }

  // searching for list items after factor 
  void _factorTail(List arr) {
    String token = arr[0];
    if (token == "*" || token == "/") {
      _multOp(arr); 
      _factor(arr);
      _factorTail(arr);
    }
  }

  // base levle for translating grouped items into concrete expressions 
  void _factor(List arr) {
    String token = arr[0];
    if (token == "√") {           // evaluation of square root function 
      _match("√", arr);
      _addValueNode(token); 
      _expr(arr);
    } else if (token == "^") {    // evaluation of exponent function 
      _match("^", arr);
      _addValueNode(token); 
      _expr(arr);
    } else if (token == "(") {    // evaluation parantheses
      _match("(", arr);
      _expr(arr); 
      _match(")", arr);
    }
    RegExp nums = new RegExp(r"[0-9]");    // find numbers 
    if (nums.hasMatch(token)) {
      _match(token, arr); 
      _addValueNode(token, int.tryParse(token));
    }
  }

  // reference grammar 
  void _addOp(List<String> arr) {
    String token = arr[0];
    _match(token, arr); 
    _addValueNode(token); 
  }

  // reference grammar 
  void _multOp(List<String> arr) {
    String token = arr[0];
    _match(token, arr);
    _addValueNode(token); 
  }
}

class ValueNode {
  String strValue; 
  int intState;
  int intValue; 

  ValueNode(this.strValue, [this.intValue]);
}