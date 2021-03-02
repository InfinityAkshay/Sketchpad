import 'package:flutter/material.dart';

class DrawButton extends StatelessWidget {
  final List<Offset> drawing;
  final Function clear;
  final Function save;
  String txt = "";
  DrawButton(this.drawing, this.clear, this.save);
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Align(
          alignment: Alignment.centerRight,
          child: FloatingActionButton(
              tooltip: 'Clear Screen',
              backgroundColor: Colors.black,
              child: Icon(Icons.refresh),
              onPressed: clear)),
      Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
              tooltip: 'Save',
              backgroundColor: Colors.black,
              child: Icon(Icons.save),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => _buildPopupDialog(context),
                );
              }))
    ]);
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Save As'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(onChanged: (str) => txt = str),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () => Navigator.of(context).pop(),
          textColor: Theme.of(context).primaryColor,
          child: const Text('Cancel'),
        ),
        new FlatButton(
          onPressed: () {
            save(txt, drawing);
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
