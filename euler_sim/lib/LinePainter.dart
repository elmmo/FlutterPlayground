import 'package:flutter/material.dart';
import 'Node.dart';

class LinePainter extends CustomPainter {
  List<List<Node>> coordinates; 

  LinePainter(this.coordinates);

  @override 
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 2; 
    for (int i = 0; i < coordinates.length; i++) {
      //canvas.drawLine(coordinates[i][0].position, coordinates[i][1], paint);
    };
  }

  @override 
  bool shouldRepaint(LinePainter oldDelegate) => true; 
}