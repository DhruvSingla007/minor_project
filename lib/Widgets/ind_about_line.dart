import 'package:flutter/material.dart';
import 'package:minor_project/constants.dart';

Widget aboutLine() {
  return Padding(
    padding: const EdgeInsets.only(
      top: 8.0,
    ),
    child: Center(
      child: Text(
        'About',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: greenColor,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
    ),
  );
}
