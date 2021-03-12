import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/Widgets/textFormFields.dart';
import 'package:minor_project/constants.dart';
import 'package:toast/toast.dart';

class AddAchievementsPage extends StatefulWidget {
  final String SID;

  AddAchievementsPage({
    this.SID,
  });

  @override
  _AddAchievementsPageState createState() => _AddAchievementsPageState();
}

class _AddAchievementsPageState extends State<AddAchievementsPage> {
  final _addAchievementsFormKey = GlobalKey<FormState>();

  String position = "First";

  final TextEditingController _nameInputController = TextEditingController();
  final TextEditingController _dateInputController = TextEditingController();
  final TextEditingController _locationInputController =
      TextEditingController();

  bool isLoading = false;

  Future<void> uploadAchievement(String userSID) async {
    String achievementInfo = position +
        "_" +
        _nameInputController.text.toString() +
        "_" +
        _dateInputController.text.toString() +
        "_" +
        _locationInputController.text.toString();

    DocumentReference docRef = Firestore.instance
        .collection('users')
        .document(userSID);

    DocumentSnapshot documentSnapshot = await docRef.get();
    List achievementList = documentSnapshot.data['achievements'];
    docRef.updateData({
      'achievements': FieldValue.arrayUnion([achievementInfo])
    });

    Toast.show("Done", context, duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Events'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(8.0),
        children: <Widget>[
          Form(
            key: _addAchievementsFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                buildTextFormsField(
                  hintText: "Event Name",
                  errorMessage: "Please enter the name of the event",
                  editingController: _nameInputController,
                  preIcon: Icon(Icons.event),
                ),
                buildTextFormsField(
                  hintText: "Event Date",
                  errorMessage: "Please enter the date of the event",
                  editingController: _dateInputController,
                  preIcon: Icon(Icons.date_range),
                ),
                buildTextFormsField(
                  hintText: "Event Location",
                  errorMessage: "Please enter the location of the event",
                  editingController: _locationInputController,
                  preIcon: Icon(Icons.location_on),
                ),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: DropdownButton<String>(
                    value: position,
                    elevation: 16,
                    style: TextStyle(color: Colors.white, fontSize: 18.0),
                    onChanged: (String newValue) {
                      setState(() {
                        position = newValue;
                      });
                    },
                    items: <String>['First', 'Second', 'Third']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                Container(
                  child: Center(
                    child: RaisedButton(
                      onPressed: () {
                        if (_addAchievementsFormKey.currentState.validate()) {
                          setState(() {
                            isLoading = true;
                          });

                          uploadAchievement(widget.SID);

                          setState(() {
                            isLoading = false;
                          });
                        }
                      },
                      child: Text("Add"),
                      color: greenColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
