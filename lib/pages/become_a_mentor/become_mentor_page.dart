import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/Widgets/build_profile_card.dart';
import 'package:minor_project/Widgets/ind_news_tile.dart';
import 'package:minor_project/Widgets/mentors_form_details.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import '../../constants.dart';

class MentorsPage extends StatefulWidget {
  static const String routeName = "/become-mentors-page";

  @override
  _MentorsPageState createState() => _MentorsPageState();
}

class _MentorsPageState extends State<MentorsPage> {
  final _fireStore = Firestore.instance;

  // Student Information
  String studentName = "";
  String pecMailID = "";
  String studentSID = "";
  String studentContact = "";
  bool isLoading = false;

  // Dropdown default option
  String sub = "ECN 201";

  // Shared Preferences to get the details of the user
  SharedPreferences preferences;

  // Update the Mentor List
  Future<void> uploadMentors({
    String mentorName,
    String mentorSID,
    String subject,
    String mentorMailID,
    String mentorContactNumber,
  }) async {
    setState(() {
      isLoading = true;
    });

    String mentorInfo = mentorSID + "_" + mentorName + "_" + mentorContactNumber + "_" + mentorMailID;

    DocumentReference docRef = Firestore.instance
        .collection('mentors')
        .document(subject.toString().trim());
    DocumentSnapshot documentSnapshot = await docRef.get();
    List mentorsList = documentSnapshot.data['mentor_list'];

    if (mentorsList.contains(mentorInfo) == true) {
      Toast.show("You are already a mentor of this subject", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    } else {
      docRef.updateData({
        'mentor_list': FieldValue.arrayUnion([mentorInfo])
      });

      Toast.show("Done", context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
    }

    setState(() {
      isLoading = false;
    });
  }

  // Get the user information from the Shared Preferences
  Future<void> _getInfo() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      studentName = preferences.getString("studentName");
      studentSID = preferences.getString("studentSID");
      pecMailID = preferences.getString("pecMailID");
      studentContact = preferences.getString("contactNumber");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Become a mentor'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
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
              height: 50.0,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                top: 20.0,
                bottom: 10.0,
              ),
              child: Text(
                "Other Details",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.0,
                  color: greenColor,
                ),
              ),
            ),
            ProfileCard(text: studentName),
            ProfileCard(text: studentSID),
            ProfileCard(text: pecMailID),
            SizedBox(
              height: 25.0,
            ),
            Center(
              child: RaisedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  uploadMentors(
                    mentorName: studentName,
                    mentorSID: studentSID,
                    subject: sub,
                    mentorContactNumber: studentContact,
                    mentorMailID: pecMailID,
                  );
                  setState(() {
                    isLoading = false;
                  });
                },
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
      ),
    );
  }
}
