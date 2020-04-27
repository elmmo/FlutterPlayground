import 'package:flutter/material.dart';
import 'VisualComponents.dart';

void main() => runApp(EulerSim());

class EulerSim extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Euler Simulator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VisualComponents(),
    );
  }
}
