import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'LinePainter.dart';
import 'EulerLogic.dart';
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
  Node focusNode;        // the last node clicked on 

  // managing graph relationships 
  bool connected; 
  bool highlight; // for highlighting graph relationships 

  @override
  void initState() {
    super.initState(); 
    random = new Random(); 
    nodes = new Map<int, Widget>(); 
    edges = new List<Edge>(); 
    matrix = new List<List<int>>(); 
    coordinates = new List<List<Offset>>(); 
    nodeCount = 0; 
    focusNode = null; 
    connected = false; 
    highlight = false; 
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
            if (edges.length > 0 && !edges[edges.length-1].connected) {
              voidConnect();      // cancel on the field side 
            }
          },
          child: createField(),
        ),
      ),
    );
  }

    void addNode() {
      // randomly determine where on the screen the node will start 
      double startX = random.nextDouble() * getScreenWidth(context, dividedBy: 2);
      double startY = random.nextDouble() * getScreenHeight(context, dividedBy: 2);
      Offset offsetPosition = Offset(startX, startY);
      nodes[nodeCount] = Node(nodeCount, startConnect, offsetPosition, onDrag, setFocus);
      nodeCount++; 
      highlight = false; 
      // adds a node to the main visualization
      setState(() {
        addNodeToMatrix();  
      });
      addNodeToMatrix();  
      if (nodes.length > 1) {
        setState(() {
          connected = isConnected(matrix, excludeZeroDeg: false); 
        });
      }
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
    String result = "["; 
    for (int i = 0; i < nodeCount; i++) {
      result += "[";
      for (int j = 0; j < nodeCount; j++) {
        result += (matrix[i][j]).toString(); 
        if (j < nodeCount-1) result += ",";
      }
      result += "],\n";
    }
    result += "]";
    return result; 
  }

  // connects one node to another 
  // id: the id of the node that triggered the connection 
  void startConnect(Node node, Offset position, Function callback) {
    if (edges.length > 0 && !edges[edges.length-1].connected) {
      Edge latestEdge = edges[edges.length-1]; 
      // check if self-edge 
      if (latestEdge.nodes[0] == node) {
        voidConnect(); 
      } else {
        // register connection on field side
        latestEdge.addNode(node, getAdjustedPosition(position), callback);
        // communicate completion back to the nodes 
        latestEdge.closeConnection();
        List<int> ids = latestEdge.getIds(mustBeconnected: true); 
        // update adjacency matrix 
        setState(() {
          // register connection in adjacency matrix 
          matrix[ids[0]][ids[1]] = 1; 
          matrix[ids[1]][ids[0]] = 1;
        });
        // update visuals 
        updateDrawingCoordinates(); 
        // check against graph patterns 
        setState(() {
          connected = isConnected(matrix, excludeZeroDeg: false);
        });
        focusNode = null; 
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
    focusNode = null; 
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
    highlight = false; 
    updateDrawingCoordinates(); 
  }

  // adjusts the line position to account for the difference between the circle center and the true offset 
  Offset getAdjustedPosition(Offset position) => Offset(position.dx+25, position.dy+25);

  // adjusts the coordinates for drawing edges between the nodes 
  void updateDrawingCoordinates() {
    List<List<Offset>> newCoordinates = new List(); 
    for (int i = 0; i < edges.length; i++) {
      // gets the new coordinates directly from the edge 
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
        // button for help 
        Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, 50, 30, 0),
                child: Container(height: 50, width: 50,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: Icon(Icons.info),
                      tooltip: "Help", 
                      iconSize: 34, 
                      color: Colors.grey[400],
                      onPressed: () {
                        print("Hello World");
                      }
                    )
                  ))
              )
            )
          ]
        ),
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
                painter: getLinePainter(),
              ),
            ),
          )
        ),
        // status bar 
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
          child: Container(
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly, 
              children: <Widget>[
                OutlineButton(
                  child: Text("Connected"), 
                  highlightedBorderColor: Colors.blue, 
                  onPressed: (connected) ? highlightRelationship : null),
                OutlineButton(
                  child: Text("Euler Cycle"), 
                  highlightedBorderColor: Colors.blue,
                  ),
                OutlineButton(child: Text("Euler Trail"), highlightedBorderColor: Colors.blue,),
              ],
            ),
          )
        ),
        // buttons for working with the nodes 
        Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 60),
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(width: 1.0, color: Colors.grey[300]),
                left: BorderSide(width: 5.0, color: Colors.grey[700]),
                right: BorderSide(width: 5.0, color: Colors.grey[700]),
                bottom: BorderSide(width: 1.0, color: Colors.grey[300]),
              )
            ),
            child: ButtonBar(
              alignment: MainAxisAlignment.spaceEvenly, 
              children: <Widget>[
                IconButton(icon: Icon(Icons.add), onPressed: addNode), 
                IconButton(icon: Icon(Icons.delete), onPressed: (focusNode == null) ? clearScreen : deleteNode), 
                IconButton(icon: Icon(Icons.content_copy), onPressed: copyMatrixToClipboard), 
                IconButton(icon: Icon(Icons.input), onPressed: () {print("Hello World");}), 
              ],
            ),
          )
        ),
    ],);}

    // for responsive sizing - height 
    double getScreenHeight(BuildContext context, {dividedBy = 1}) {
      return MediaQuery.of(context).size.height/dividedBy; 
    }

    // for responsive sizing - width 
    double getScreenWidth(BuildContext context, {dividedBy = 1}) {
      return MediaQuery.of(context).size.width/dividedBy; 
    }

    // resets the field
    void clearScreen() {
      if (nodes.length > 0) {
        nodes.clear();
        edges.clear();
        matrix.clear(); 
        coordinates.clear(); 
        nodeCount = 0; 
        connected = false; 
        setState(() {
          updateDrawingCoordinates();
        });
      }
    }

    // deletes an individual node from the screen
    void deleteNode() {
      bool repaint = false; 
      List<Edge> edgesToRemove = new List(); 
      if (focusNode != null) {
          // detects edges that contain the focus node 
          edges.forEach((Edge e) {
            if (e.edgeContains(focusNode)) {
              edgesToRemove.add(e); 
              repaint = true; 
              if (e.connected) {
                List ids = e.getIds(mustBeconnected: false);  
                // resets each connection in the matrix related to the given node
                matrix[ids[0]][ids[1]] = 0; 
                matrix[ids[1]][ids[0]] = 0; 
              }
            }
          });
        }
      // removes edges that were connected to the deleted node 
      edgesToRemove.forEach((Edge e) {
        edges.remove(e); 
      });
      edges.removeLast();   // accounts for the edge created by clicking the node
      setState(() {
        // removes the node itself from the list and clears focusNode
        nodes.remove(focusNode.id);
        focusNode = null;
        // if edges have been deleted, update drawing coordinates 
        if (repaint) {
          updateDrawingCoordinates();
        }
      });
    }

    // copies a string representation of the adjacency matrix to the clipboard 
    void copyMatrixToClipboard() {
      Clipboard.setData(ClipboardData(text: getMatrixString()));
    }

    // sets the focus node to the node that has been clicked last 
    void setFocus(Node node) {
      focusNode = node;
    }

    // returns a new line painter based on the current state 
    LinePainter getLinePainter() {
      return new LinePainter(highlight, coordinates);
    }

    // highlights the relationship between the given nodes 
    void highlightRelationship() {
      if (connected) {
        setState(() {
          highlight = true; 
        });
      }
    }
}

