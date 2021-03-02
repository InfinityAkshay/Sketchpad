import 'package:flutter/material.dart';

import './buttons.dart';
import './sketcher.dart';
import './picture.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sketcher App',
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
  var state = "list";
  List pictures = [];
  var names = [];
  List seenPics = [];
  List<Offset> points = <Offset>[];
  Picture currOpen;

  @override
  Widget build(BuildContext context) {
    void draw(details) {
      setState(() {
        RenderBox box = context.findRenderObject();
        Offset point = box.globalToLocal(details.globalPosition);
        point = point.translate(0.0, -(AppBar().preferredSize.height));

        points = List.from(points)..add(point);
      });
    }

    void clear() => setState(() => points.clear());

    void save(name, drawing) {
      if (currOpen != null) {
        currOpen.name = name;
        currOpen.drawing = List.of(points);
        clear();
        state = "list";
      } else if (!names.contains(name) && name != null && name != "") {
        setState(() {
          pictures.add(Picture(name, drawing));
          names.add(name);
          points.clear();
          seenPics = List.of(pictures);
          state = "list";
        });
      }
    }

    void search(String str) {
      setState(() {
        if (str == '') {
          seenPics = List.of(pictures);
        } else {
          seenPics = [];
          for (var i = 0; i < pictures.length; i++) {
            if (pictures[i].name.contains(str)) {
              seenPics.add(pictures[i]);
            }
          }
        }
      });
    }

    void open(picture) => setState(() {
          currOpen = picture;
          points = List.of(picture.drawing);
          state = "draw";
        });

    void newOpen() => setState(() {
          currOpen = null;
          state = "draw";
        });

    final Container sketchArea = Container(
      margin: EdgeInsets.all(1.0),
      alignment: Alignment.topLeft,
      color: Colors.blueGrey[50],
      child: CustomPaint(
        painter: Sketcher(points),
      ),
    );

    return state == "draw"
        ? Scaffold(
            appBar: AppBar(title: Text('Sketcpad')),
            body: Sketch(points, sketchArea, draw),
            floatingActionButton:
                DrawButton(clear, save, List<Offset>.of(points), currOpen))
        : Scaffold(
            appBar: AppBar(title: Text('Sketcher')),
            body: ListView(
                children: <Widget>[TextField(onChanged: (str) => search(str))] +
                    seenPics.map((picture) {
                      return RaisedButton(
                        onPressed: () => open(picture),
                        child: Text(picture.name),
                      );
                    }).toList()),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add), onPressed: newOpen));
  }
}
