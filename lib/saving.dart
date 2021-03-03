import 'dart:ui';
import './picture.dart';

List listToOffset(List l) {
  List lst = [];
  for (var i = 0; i < l.length; i++) {
    lst.add(Offset(l[i][0], l[i][1]));
  }
  return lst;
}

List offsetToList(List l) {
  List lst = [];
  for (var i = 0; i < l.length; i++) {
    lst.add([l[i].dx, l[i].dy]);
  }
  return lst;
}

String picsToString(List l) {
  List names = [];
  List pics = [];
  for (var i = 0; i < l.length; i++) {
    names.add(l[i].name);
    pics.add(l[i].drawing);
  }
  return [names.toString(), offsetToList(pics).toString()].toString();
}

List stringToPics(List names, List pics) {
  List lst = [];
  pics = listToOffset(pics);
  for (var i = 0; i < names.length; i++) {
    lst.add(Picture(names[i], pics[i]));
  }
  return lst;
}
