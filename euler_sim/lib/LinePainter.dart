import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  bool highlight; 
  List<List<Offset>> coordinates; 

  LinePainter(bool highlight, this.coordinates);

  @override 
  void paint(Canvas canvas, Size size) {
    Color paintIt = Colors.black; 
    if (highlight != null) paintIt = Colors.red;
    final paint = Paint()
      ..color = paintIt
      ..strokeWidth = 3; 
    if (coordinates.length > 0) {
      for (int i = 0; i < coordinates.length; i++) {
        canvas.drawLine(coordinates[i][0], coordinates[i][1], paint);
      }
    }
  }

  @override 
  bool shouldRepaint(LinePainter oldDelegate) => true; 
}