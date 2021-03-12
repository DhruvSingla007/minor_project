import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MentorForm extends StatefulWidget {
  @override
  _MentorFormState createState() => _MentorFormState();
}

class _MentorFormState extends State<MentorForm> {
  String sub = "ECN 201";

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.0,
        vertical: 5.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.greenAccent),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: DropdownButton<String>(
            value: sub,
            elevation: 16,
            style: TextStyle(color: Colors.white, fontSize: 18.0),
            onChanged: (String newValue) {
              setState(() {
                sub = newValue;
              });
            },
            items: <String>['ECN 201', 'ECN 202', 'ECN 203', 'ECN 204']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
