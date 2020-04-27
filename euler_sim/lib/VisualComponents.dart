import 'package:flutter/material.dart';
import 'Node.dart';

class VisualComponents extends StatefulWidget {

  @override
  _VisualComponents createState() => _VisualComponents();
}

class _VisualComponents extends State<VisualComponents> {
  List<List<int>> edges; // adjacency matrix that keeps track of connections between nodes 
  List<Widget> nodes; 
  int nodeCount; 

  @override
  void initState() {
    super.initState(); 
    nodes = new List<Widget>(); 
    edges = new List<List<int>>(); 
    nodeCount = 0; 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(50),
                child: SizedBox.expand(
                  child: Stack(
                    children: nodes
                  )
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
            nodes.add(Node());
            nodeCount++; 
            addNodeToMatrix(); 
            print("\n" + getMatrixString());
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
}
