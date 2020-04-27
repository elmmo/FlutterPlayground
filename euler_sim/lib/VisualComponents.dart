import 'package:flutter/material.dart';
import 'Node.dart';

class VisualComponents extends StatefulWidget {

  @override
  _VisualComponents createState() => _VisualComponents();
}

class _VisualComponents extends State<VisualComponents> {
  List<Widget> nodes; 

  @override
  void initState() {
    super.initState(); 
    nodes = new List<Widget>(); 
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
          })
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
