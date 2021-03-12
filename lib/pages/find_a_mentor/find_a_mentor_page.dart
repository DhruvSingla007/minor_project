import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/Widgets/sponsors_gridTile.dart';
import 'package:minor_project/constants.dart';
import 'package:minor_project/pages/mentors_list/mentors_list_page.dart';
import 'package:toast/toast.dart';

class FindMentorPage extends StatefulWidget {
  static const String routeName = "/find-mentor-page";

  @override
  _FindMentorPageState createState() => _FindMentorPageState();
}

class _FindMentorPageState extends State<FindMentorPage> {
  String sub = "ECN 201";

  Future<void> showMentors() async {
    DocumentReference docRef = Firestore.instance.collection('mentors').document(sub.toString().trim());
    DocumentSnapshot documentSnapshot = await docRef.get();
    List mentorList = documentSnapshot.data['mentor_list'];

    if(mentorList.length == 0){
      Toast.show("No mentors found for this subject",context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (context) => MentorListPage(sub: sub,)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find a Mentor'),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              top: 20.0,
              bottom: 10.0,
            ),
            child: Text(
              "Please select the subject",
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 5.0,
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: greenColor),
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
          ),
          SizedBox(
            height: 25.0,
          ),
          Center(
            child: RaisedButton(
              onPressed: () => showMentors(),
              color: greenColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  'Done',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
