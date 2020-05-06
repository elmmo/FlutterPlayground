import 'package:flutter/material.dart';
import 'Node.dart';

class Edge {
  List<Node> nodes; 
  Map<Node, Offset> locations;
  List<Function> callbacks;
  bool connected; 

  Edge(Node node, Offset location, Function callback) {
    nodes = new List(); 
    nodes.add(node); 
    locations = new Map<Node, Offset>(); 
    setLocation(node, location); 
    callbacks = new List(); 
    callbacks.add(callback); 
    connected = false; 
  }

  void addNode(Node node, Offset location, Function callback) {
    if (nodes.length == 1) {
      nodes.add(node);
      setLocation(node, location); 
      callbacks.add(callback); 
      connected = true; 
    }
  }

  void setLocation(Node node, Offset newLocation) {
    locations[node] = newLocation; 
  }

  void closeConnection() {
    for (int i = 0; i < callbacks.length; i++) {
      callbacks[i](); 
    }
  }

  bool edgeContains(Node node) {
    return nodes.contains(node); 
  }

  List<int> getIds({bool mustBeconnected}) {
    List<int> ids = new List(); 
    for (int i = 0; i < nodes.length; i++) {
      ids.add(nodes[i].id);
    }
    // check if connectedness matters 
    if (mustBeconnected) {
      return (connected) ? ids : null; 
    } else {
      return ids; 
    }
  }
}