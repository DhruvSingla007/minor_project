import 'package:flutter/material.dart';
import 'package:minor_project/constants.dart';

Widget buttons({Function function, Widget widget}) {
  return RaisedButton(
    onPressed: function,
    child: widget,
    shape: RoundedRectangleBorder(
      borderRadius: new BorderRadius.circular(30.0),
    ),
    color: greenColor,
    elevation: 6.0,
  );
}
