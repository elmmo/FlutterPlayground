import 'package:flutter/material.dart';

class Node extends StatefulWidget {

  @override
  _Node createState() => _Node();
}

class _Node extends State<Node> {
  Offset position; 

  @override
  void initState() {
    super.initState(); 
    position = Offset.zero;
  }

  @override
  Widget build(BuildContext context) {
    // what the node will look like 
    Container circle = new Container(
      width: 30,
      height: 30,
      margin: EdgeInsets.all(10),
      decoration: new BoxDecoration(shape: BoxShape.circle, color: Colors.black)
    ); 
    // positioning the node on a coordinate grid within the stack 
    return Positioned(
      left: position.dx,
      top: position.dy,
      height: 50,
      // listener on the node 
      child: GestureDetector(
            // trigger when node is dragged 
            onPanUpdate: (details) {
              setState(() {
                position = Offset(position.dx + details.delta.dx, position.dy + details.delta.dy);
              });
            },
            child: circle,
          ),
    );
  }
}
