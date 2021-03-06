import 'package:flutter/material.dart';

class Node extends StatefulWidget {
  final int id; 
  final Function startConnect; 
  final Offset startPosition; 
  final Function onDrag; 
  final Function focus; 

  // constructor that passes connection information back to the parent 
  Node(this.id, this.startConnect, this.startPosition, this.onDrag, this.focus); 

  @override
  _Node createState() => _Node();
}

class _Node extends State<Node> {
  Offset position; 
  bool connecting; 

  @override
  void initState() {
    super.initState(); 
    position = this.widget.startPosition;  
    connecting = false; 
  }

  @override
  Widget build(BuildContext context) {
    // what the node will look like 
    Container circle = new Container(
      width: 30,
      height: 30,
      margin: EdgeInsets.all(10),
      decoration: new BoxDecoration(
        shape: BoxShape.circle, 
        color: ((connecting) ? Colors.blue : Colors.black),
      ),
      // label the node 
      child: Center(child: Text(
        this.widget.id.toString(), 
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)
      )),
    ); 
    // positioning the node on a coordinate grid within the stack 
    return Positioned(
      left: position.dx,
      top: position.dy,
      height: 50,
      // listener on the node 
      child: GestureDetector(
            // trigger when node is dragged 
            onTap: () { toggleConnecting(); },
            onPanUpdate: (details) {
              setState(() {
                position = Offset(position.dx + details.delta.dx, position.dy + details.delta.dy);
              });
              this.widget.onDrag(this.widget, position); 
            },
            child: circle,
          ),
    );
  }

  // toggles the connecting bool so the node will respond visually to connections
  void toggleConnecting() {
    setState(() {
      connecting = (connecting) ? false : true;
    });
    this.widget.focus(this.widget); 
    if (connecting) this.widget.startConnect(this.widget, position, toggleConnecting);
  }

}
