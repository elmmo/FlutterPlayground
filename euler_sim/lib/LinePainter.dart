import 'package:flutter/material.dart';

class LinePainter extends CustomPainter {
  List<List<Offset>> coordinates; 

  LinePainter(this.coordinates);

  @override 
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3; 
    if (coordinates.length > 0) {
      for (int i = 0; i < coordinates.length; i++) {
        canvas.drawLine(coordinates[i][0], coordinates[i][1], paint);
      };
    }
  }

  @override 
  bool shouldRepaint(LinePainter oldDelegate) => true; 
}