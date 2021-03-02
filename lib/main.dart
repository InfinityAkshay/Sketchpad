import 'package:flutter/material.dart';

import './buttons.dart';
import './sketcher.dart';
import '';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Offset> points = <Offset>[];

  @override
  Widget build(BuildContext context) {
    final Container sketchArea = Container(
      margin: EdgeInsets.all(1.0),
      alignment: Alignment.topLeft,
      color: Colors.blueGrey[50],
      child: CustomPaint(
        painter: Sketcher(points),
      ),
    );


    void draw(details) {
      setState(() {
        RenderBox box = context.findRenderObject();
        Offset point = box.globalToLocal(details.globalPosition);
        point = point.translate(0.0, -(AppBar().preferredSize.height));

        points = List.from(points)..add(point);
      });
    }

    void clear()=>setState(()=>points.clear());

    return Scaffold(
      appBar: AppBar(
        title: Text('Sketcher'),
      ),
      body: Sketch(points,sketchArea,draw),
      floatingActionButton: DrawButton(points,clear),
    );
  }
}

