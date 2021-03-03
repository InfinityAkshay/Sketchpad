import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:path_provider/path_provider.dart';

import './buttons.dart';
import './sketcher.dart';
import './picture.dart';
import './list.dart';
import './saving.dart';

void main() async => runApp(MyApp());

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

  Future<String> _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_int_key';
    final value = prefs.getString(key) ?? "[[],[]]";
    print(0);
    print(value);
    return value;
  }

  _saveAs(str) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_int_key';
    prefs.setString(key, str);
    print('saved');
  }

  void getList() async {
    String s = await _read();
    var lst = await jsonDecode(s);
    names = lst[0];
    pictures = stringToPics(lst[0], lst[1]);
    seenPics = List.of(pictures);
  }

  @override
  void initState() {
    getList();
    super.initState();
  }

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

    void save(name, drawing) async {
      if (currOpen != null) {
        setState(() {
          currOpen.drawing = List.of(points);
          clear();
          state = "list";
        });
      } else {
        setState(() {
          var picture = Picture(name, drawing);
          pictures.add(picture);
          names.add(name);
          points.clear();
          seenPics = List.of(pictures);
          state = "list";
        });
      }
      _saveAs(picsToString(pictures));
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

    void remove(item) => setState(() {
          seenPics.remove(item);
          pictures.remove(item);
          names.remove(item.name);
        });

    void rename(currOpen, name) => setState(() {
          names.remove(currOpen.name);
          names.add(name);
          currOpen.name = name;
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
            appBar: AppBar(
                title: Container(
                    child: Text('Sketchpad', textAlign: TextAlign.center),
                    width: double.infinity),
                backgroundColor: Colors.black),
            body: Sketch(points, sketchArea, draw),
            floatingActionButton: DrawButton(
                clear, save, List<Offset>.of(points), currOpen, names))
        : Scaffold(
            appBar: AppBar(
                title: Container(
                    child: Text('Sketcher', textAlign: TextAlign.center),
                    width: double.infinity),
                backgroundColor: Colors.black),
            body: Listing(search, open, seenPics, remove, rename, names),
            floatingActionButton: FloatingActionButton(
                child: Icon(Icons.add),
                onPressed: newOpen,
                backgroundColor: Colors.black));
  }
}

