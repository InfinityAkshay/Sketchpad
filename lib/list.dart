import 'package:flutter/material.dart';

class Listing extends StatelessWidget {
  final Function search;
  final Function open;
  final List seenPics;
  final Function remove;
  String txt;
  final Function rename;
  Listing(this.search, this.open, this.seenPics, this.remove, this.rename);
  @override
  Widget build(BuildContext context) {
    return ListView(
        children: <Widget>[TextField(onChanged: (str) => search(str))] +
            seenPics.map((picture) {
              return Dismissible(
                  key: Key(picture.name),
                  onDismissed: (direction) {
                    remove(picture);
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text(picture.name + " deleted")));
                  },
                  background: Container(color: Colors.red),
                  child: Container(
                      width: double.infinity,
                      child: RaisedButton(
                        color: Colors.black,
                        textColor: Colors.white,
                        onPressed: () => open(picture),
                        onLongPress: () => showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              _buildPopupDialog(context, picture),
                        ),
                        child: Text(picture.name),
                      )));
            }).toList());
  }

  Widget _buildPopupDialog(BuildContext context, picture) {
    return new AlertDialog(
      title: const Text('Rename'),
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
            rename(picture, txt);
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Rename'),
        ),
      ],
    );
  }
}
