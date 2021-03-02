import 'package:flutter/material.dart';

class DrawButton extends StatelessWidget {
  final List<Offset> points;
  final Function clear;
  DrawButton(this.points,this.clear);
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
    tooltip: 'clear Screen',
    backgroundColor: Colors.black,
    child: Icon(Icons.refresh),
    onPressed: clear
    );
  }
}
