import 'package:flutter/material.dart';
import 'dart:io';
import 'LinePainter.dart';
import 'Node.dart';

class Field extends StatefulWidget {

  @override
  _Field createState() => _Field();
}

class _Field extends State<Field> {
  List<List<int>> edges; // adjacency matrix of connections between nodes 
  List<List<Node>> coordinates; // edge representation for visuals 
  Map<int, Widget> nodes;    // nodes displayed visually 
  int nodeCount;         // the number of nodes currently active 
  Node connectNode;     // the node initiating a connect
  Function connectCallback; // the callback for communicting to the connect initiator node 

  @override
  void initState() {
    super.initState(); 
    nodes = new Map<int, Widget>(); 
    //coordinates = new Map<>(); 
    edges = new List<List<int>>(); 
    nodeCount = 0; 
    connectNode = null;  
    connectCallback = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          // adds a node to the main visualization 
          setState(() {
            nodes[nodeCount] = Node(nodeCount, startConnect, voidConnect);
            nodeCount++; 
            addNodeToMatrix(); 
          })
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
        edges[connectNode.id][node.id] = 1; 
        edges[node.id][connectNode.id] = 1;
        callback(); 
        connectCallback();
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

}
