import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:minor_project/Widgets/build_profile_card.dart';
import 'package:minor_project/constants.dart';
import 'package:minor_project/pages/login_page.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_page.dart';

class MyProfilePage extends StatefulWidget {

  static const String routeName = "/my-profile-page";

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {

  // Student Information
  String studentName = "";
  String pecMailID = "";
  String studentSID = "";
  bool isLoading = false;

  final GoogleSignIn googleSignIn = GoogleSignIn();
  SharedPreferences preferences;

  // Sign out function
  Future<Null> handleSignOut() async {
    this.setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    this.setState(() {
      isLoading = false;
    });
  }

  _onAlertButtonsPressed(context) {
    Alert(
      style: AlertStyle(
        backgroundColor: Colors.black,
        titleStyle: TextStyle(color: Colors.white),
        descStyle: TextStyle(color: Colors.white),
      ),
      context: context,
      type: AlertType.warning,
      title: "LOG OUT",
      desc: "Do you want to log out your ID ?",
      buttons: [
        DialogButton(
          child: Text(
            "Cancel",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          gradient: LinearGradient(colors: [
            Color(0xFF20BF55),
            Color(0xFF01BAEF),
          ]),
        ),
        DialogButton(
          child: Text(
            "Log Out",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () {
            handleSignOut().then((val) {
              preferences.clear().then((val) {
                exit(0);
              });
            });
          },
          gradient: LinearGradient(colors: [
            Color.fromRGBO(116, 116, 191, 1.0),
            Color.fromRGBO(52, 138, 199, 1.0)
          ]),
        )
      ],
    ).show();
  }

  Widget _buildMyProfileLogo(String imagePath) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        child: CircleAvatar(
          radius: 50.0,
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  Future<void> _getInfo() async {
    preferences = await SharedPreferences.getInstance();
    setState(() {
      studentName = preferences.getString("studentName");
      studentSID = preferences.getString("studentSID");
      pecMailID = preferences.getString("pecMailID");
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
      appBar: AppBar(
        elevation: 0.0,
        title: Text('My Profile'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {}, //=> _onAlertButtonsPressed(context),
            tooltip: "Log Out",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          alignment: Alignment.center,
          child: ListView(
//            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildMyProfileLogo(myProfilePageLogoPath),
              SizedBox(
                height: 50.0,
              ),
              ProfileCard(text: studentName),
              ProfileCard(text: studentSID),
              ProfileCard(text: pecMailID),
              SizedBox(
                height: 25.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
