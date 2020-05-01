import 'package:flutter/material.dart';
import 'LinePainter.dart';
import 'dart:math';
import 'Node.dart';
import 'Edge.dart';

class Field extends StatefulWidget {

  @override
  _Field createState() => _Field();
}

class _Field extends State<Field> {
  // managing node relationships 
  List<List<int>> matrix; // adjacency matrix of connections between nodes 
  List<Edge> edges; // edge representation for visuals 
  List<List<Offset>> coordinates; // the points to draw lines between 

  // managing nodes 
  Map<int, Widget> nodes;    // nodes displayed visually 
  int nodeCount;         // the number of nodes currently active
  Random random;         // for generating node position randomly  

  @override
  void initState() {
    super.initState(); 
    random = new Random(); 
    nodes = new Map<int, Widget>(); 
    edges = new List<Edge>(); 
    matrix = new List<List<int>>(); 
    coordinates = new List<List<Offset>>(); 
    nodeCount = 0; 
  }

  @override
  Widget build(BuildContext context) {
    print(edges); 
    return Scaffold(
      body: Center(
        child: GestureDetector(
          // unless a button is tapped, don't block touch from gesture detector 
          behavior: HitTestBehavior.translucent,
          // if user taps out of connection, void it 
          onTap: () {
            if (edges.length > 0 && !edges[edges.length-1].complete) {
              voidConnect();      // cancel on the field side 
            }
          },
          child: createField(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // randomly determine where on the screen the node will start 
          double startX = random.nextDouble() * getScreenWidth(context, dividedBy: 2);
          double startY = random.nextDouble() * getScreenHeight(context, dividedBy: 2);
          Offset offsetPosition = Offset(startX, startY);
          // adds a node to the main visualization 
          setState(() {
            nodes[nodeCount] = Node(nodeCount, startConnect, offsetPosition, onDrag);
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
      matrix[i].add(0); 
    }
    matrix.add(new List()); 
    // used in place of List.filled because List.filled produces an immutable list 
    for (int i = 0; i < nodeCount; i++) {
      matrix[nodeCount-1].add(0); 
    }
  }

  // returns a string representation of the adjacency matrix 
  String getMatrixString() {
    String result = ""; 
    for (int i = 0; i < nodeCount; i++) {
      for (int j = 0; j < nodeCount; j++) {
        result += (matrix[i][j]).toString() + " "; 
      }
      result += "\n";
    }
    return result; 
  }

  // connects one node to another 
  // id: the id of the node that triggered the connection 
  void startConnect(Node node, Offset position, Function callback) {
    if (edges.length > 0 && !edges[edges.length-1].complete) {
      Edge latestEdge = edges[edges.length-1]; 
      // check if self-edge 
      if (latestEdge.nodes[0] == node) {
        voidConnect(); 
      } else {
        // register connection in edge list 
        latestEdge.addNode(node, getAdjustedPosition(position), callback);
        // communicate completion back to the nodes 
        latestEdge.closeConnection();
        List<int> ids = latestEdge.getIds(mustBeComplete: true); 
        // update adjacency matrix 
        setState(() {
          // register connection in adjacency matrix 
          matrix[ids[0]][ids[1]] = 1; 
          matrix[ids[1]][ids[0]] = 1;
        });
        // update visuals 
        updateDrawingCoordinates(); 
      }
    } else {
      // start connection
      setState(() {
        edges.add(new Edge(node, getAdjustedPosition(position), callback));
      }); 
    }
  }

  // cancels the connection process that was started 
  void voidConnect() {
    setState(() {
      edges.removeLast();
    }); 
  }

  // triggered every time node is dragged and updates coordinates 
  void onDrag(Node node, Offset position) {
    for (int i = 0; i < edges.length; i++) {
      if (edges[i].nodes.contains(node)) {
        edges[i].setLocation(node, getAdjustedPosition(position));
      }
    }
    updateDrawingCoordinates(); 
  }

  // adjusts the line position to account for the difference between the circle center and the true offset 
  Offset getAdjustedPosition(Offset position) => Offset(position.dx+25, position.dy+25);

  void updateDrawingCoordinates() {
    List<List<Offset>> newCoordinates = new List(); 
    for (int i = 0; i < edges.length; i++) {
      newCoordinates.add(edges[i].locations.values.toList());
    }

    setState(() {
      coordinates = newCoordinates; 
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
                painter: LinePainter(coordinates)
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