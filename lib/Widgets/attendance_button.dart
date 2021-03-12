import 'package:flutter/material.dart';
import 'package:minor_project/constants.dart';

Widget attendanceButton({@required Function function}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Center(
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        onPressed: function,
        color: greenColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Contact',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    ),
  );
}
