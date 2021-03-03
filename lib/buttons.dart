import 'package:flutter/material.dart';
import './picture.dart';

class DrawButton extends StatelessWidget {
  final Function clear;
  final Function save;
  final List drawing;
  String txt;
  Picture currOpen;
  final List names;
  DrawButton(this.clear, this.save, this.drawing, this.currOpen, this.names);
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
                if (currOpen != null) {
                  save(currOpen.name, drawing);
                } else {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupDialog(context),
                  );
                }
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
            if (names.contains(txt)) {
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _buildPopupDialog2(context, "Filename already exists"),
              );
            } else if (txt == null || txt == "") {
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _buildPopupDialog2(context, "Invalid name"),
              );
            } else {
              save(txt, drawing);
              Navigator.of(context).pop();
            }
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _buildPopupDialog2(BuildContext context, String str) {
    return new AlertDialog(
      title: Text(str),
      content: FlatButton(
        onPressed: () => Navigator.of(context).pop(),
        textColor: Theme.of(context).primaryColor,
        child: const Text('Ok'),
      ),
    );
  }
}
