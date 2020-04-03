import 'dart:math';

class Core {
  List<ValueNode> exeList = new List<ValueNode>();

  double calculate(List tokens) {
    _program(tokens); 
    print("EXE LIST:");
    print(exeList); 
  }

  void _addValueNode(String strValue, [int intValue]) {
    ValueNode node = (intValue == null) ? new ValueNode(strValue, intValue) : new ValueNode(strValue); 
    exeList.add(node); 
  }

  // removes the first element of remaining arr
  void _consumeInputToken(String expected, List arr) {
    arr.removeAt(0);
    print(expected + "consumed"); 
  }

  void _match(String expected, List arr) {
    if (arr[0] == expected) {
      _consumeInputToken(expected, arr);
    } else {
      throw Exception('Match was called but expected did not match'); 
    }
  }
  
  // entry point for the recursive descent tree 
  void _program(List arr) {
    print("program called");
    print(arr); 
    _stmtList(arr);
    _match("=", arr);
  }

  List _stmtList(List arr) {
    print("stmtlist called");
    print(arr); 
    String token = arr[0];
    if (token == "=") { // if nothing was entered 
      return arr; 
    } else {
      _stmt(arr); 
      _stmtList(arr);
    }
  }

  void _stmt(List arr) {
    print("stmt called");
    print(arr); 
    String token = arr[0];
    if (token == "-") {
      _match("-", arr);
      _match("one", arr);
      _addValueNode("-1", -1);
      _addValueNode("*"); 
      _expr(arr);
    } else {
      _expr(arr); 
    }
  }

  double _expr(List arr) {
    print("expr called");
    print(arr); 
    _term(arr);
    if (arr.length > 1) _termTail(arr); 
  }

  void _termTail(List arr) {
    print("termtail called");
    print(arr); 
    _addOp(arr);
    _term(arr);
    _termTail(arr);
  }

  void _term(List arr) {
    print("term called");
    print(arr); 
    _factor(arr);
    if (arr.length > 1) _factorTail(arr); 
  }

  void _factorTail(List arr) {
    print("factortail called");
    print(arr); 
    _multOp(arr); 
    _factor(arr);
    if (arr.length > 1) _factorTail(arr); 
  }

  void _factor(List arr) {
    print("factor called");
    print(arr); 
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

  void _addOp(List<String> arr) {
    print("add op called");
    String token = arr[0];
    if (token == "+" || token == "-") {
      _match(token, arr); 
      _addValueNode(token); 
    }
  }

  void _multOp(List<String> arr) {
    print("Mult op claled");
    String token = arr[0];
    if (token == "/" || token == "*") {
      _match(token, arr);
      _addValueNode(token); 
    }
  }
}

class ValueNode {
  String strValue; 
  int intValue;

  ValueNode(this.strValue, [this.intValue]);
}

void main() {
  List<String> list = new List(); 
  list.add("3");
  list.add("+");
  list.add("4");
  list.add("+");
  list.add("5");
  list.add("x");
  list.add("6");
  list.add("/");
  list.add("7");
  list.add("+");
  list.add("9");
  list.add("=");
  Core c = new Core(); 
  c.calculate(list); 
}