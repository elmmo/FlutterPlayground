import 'package:flutter/material.dart';
import 'LinePainter.dart';
import 'dart:math';
import 'Node.dart';

class Field extends StatefulWidget {

  @override
  _Field createState() => _Field();
}

class _Field extends State<Field> {
  // managing node relationships 
  List<List<int>> edges; // adjacency matrix of connections between nodes 
  Map<int, Offset> coordinates; // edge representation for visuals 

  // managing nodes 
  Map<int, Widget> nodes;    // nodes displayed visually 
  int nodeCount;         // the number of nodes currently active
  Random random;         // for generating node position randomly  

  // managing connection process 
  Node connectNode;     // the node initiating a connect
  Function connectCallback; // the callback for communicting to the connect initiator node 

  @override
  void initState() {
    super.initState(); 
    random = new Random(); 
    nodes = new Map<int, Widget>(); 
    coordinates = new Map<int, Offset>(); 
    edges = new List<List<int>>(); 
    nodeCount = 0; 
    connectNode = null;  
    connectCallback = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          // unless a button is tapped, don't block touch from gesture detector 
          behavior: HitTestBehavior.translucent,
          // if user taps out of connection, void it 
          onTap: () {
            if (connectNode != null) {
              connectCallback();  // cancel on the node side 
              voidConnect();      // cancel on the field side 
            }
          },
          child: createField(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          double startX = random.nextDouble() * getScreenWidth(context, dividedBy: 2);
          double startY = random.nextDouble() * getScreenHeight(context, dividedBy: 2);
          // adds a node to the main visualization 
          setState(() {
            nodes[nodeCount] = Node(nodeCount, startConnect, Offset(startX, startY));
            nodeCount++; 
            addNodeToMatrix(); 
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  // adds a node to the adjacency matrix 
  void addNodeToMatrix() {
    for (int i = 0; i < nodeCount-1; i++) {
      edges[i].add(0); 
    }
    edges.add(new List()); 
    // used in place of List.filled because List.filled produces an immutable list 
    for (int i = 0; i < nodeCount; i++) {
      edges[nodeCount-1].add(0); 
    }
  }

  // returns a string representation of the adjacency matrix 
  String getMatrixString() {
    String result = ""; 
    for (int i = 0; i < nodeCount; i++) {
      for (int j = 0; j < nodeCount; j++) {
        result += (edges[i][j]).toString() + " "; 
      }
      result += "\n";
    }
    return result; 
  }

  // connects one node to another 
  // id: the id of the node that triggered the connection 
  void startConnect(Node node, Function callback) {
    if (connectNode != null) {
      // update adjacency matrix 
      setState(() {
        // register connection in adjacency matrix 
        edges[connectNode.id][node.id] = 1; 
        edges[node.id][connectNode.id] = 1;
        // communicate completion back to the nodes 
        callback(); 
        connectCallback();
        // complete on the field side 
        voidConnect(); 
      });
    } else {
      // start connection
      setState(() {
        connectNode = node; 
        connectCallback = callback; 
      }); 
    }
  }

  // cancels the connection process that was started 
  void voidConnect() {
    setState(() {
      connectNode = null; 
    }); 
  }

  // creates the main view of the app 
  Widget createField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        // the display area for nodes 
        Expanded(
          child: Padding(
            padding: EdgeInsets.fromLTRB(5, 50, 5, 5),
            // line paint area 
            child: ClipRect(
              child: CustomPaint(
                // nodes 
                child: SizedBox.expand(
                  child: Stack(
                    children: nodes.values.toList()
                    )
                ),
                //painter: LinePainter(coordinates)
              ),
            ),
          )
        ),
        Container(color: Colors.green, height: 100, width: MediaQuery.of(context).size.width),
    ],);}

    double getScreenHeight(BuildContext context, {dividedBy = 1}) {
      return MediaQuery.of(context).size.height/dividedBy; 
    }

    double getScreenWidth(BuildContext context, {dividedBy = 1}) {
      return MediaQuery.of(context).size.width/dividedBy; 
    }
}