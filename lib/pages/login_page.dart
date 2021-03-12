import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:minor_project/Widgets/buttons.dart';
import 'package:minor_project/constants.dart';
import 'package:minor_project/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = "/login-page";

  @override
  _LoginPageState createState() => _LoginPageState();
}

Widget mainLogoLoginPage(String imagePath) {
  return Padding(
    padding: EdgeInsets.all(30.0),
    child: Container(
      height: 180.0,
      width: 180.0,
      child: Hero(
        tag: 'logo',
        child: Image.asset(
          imagePath,
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}

Widget formFields(
    {String errorMessage,
    String hintText,
    Icon preIcon,
    TextEditingController editingController}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      validator: (value) {
        if (value.isEmpty) {
          return errorMessage;
        }
        return null;
      },
      controller: editingController,
      decoration: InputDecoration(
        prefixIcon: preIcon,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
    ),
  );
}

class _LoginPageState extends State<LoginPage> {
  // text Editing Controllers
  final TextEditingController _nameInputController = TextEditingController();
  final TextEditingController _contactInputController = TextEditingController();
  final TextEditingController _SIDInputController = TextEditingController();
  final TextEditingController _pecMailIDController = TextEditingController();

  // Check the connection
  bool isConnected = false;

  List achievementsList = [];

  // Student Info
  String studentName = "";
  String studentSID = "";
  String studentContact = "";
  String pecMailID = "";

  // Form Key of Login Page
  final _studentLoginFormKey = GlobalKey<FormState>();

  // loading state
  bool isLoading = false;

  // logging state
  bool isLoggedIn = false;

  // login credentials
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  FirebaseUser currentUser;
  SharedPreferences prefs;

  // Check the internet connection
  // if the connect valid then check credentials
  _checkInternetConnection() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      _showConnectionErrorDialog();
    } else {
      setState(() {
        isConnected = true;
      });
    }
  }

  // if connection not valid then show connection error dialogue box
  _showConnectionErrorDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Internet Connection Error'),
            content: Text('Please check your internet connection'),
            actions: <Widget>[
              FlatButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
          );
        });
  }

  // Checks if the user is already signed in
  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();
    String loggedUserName = prefs.get('studentName');

    isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn && loggedUserName != null) {
      Navigator.pushReplacementNamed(
        context,
        HomePage.routeName,
      );
    }

    this.setState(() {
      isLoading = false;
    });
  }

  // sign in function
  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });

    GoogleSignInAccount googleUser = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    AuthResult _authResult =
        await firebaseAuth.signInWithCredential(credential);
    FirebaseUser firebaseUser = _authResult.user;

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance
            .collection('users')
            .document(_SIDInputController.text.toString().trim())
            .setData({
          'studentName': _nameInputController.text.toString().trim(),
          'studentSID': _SIDInputController.text.toString().trim(),
          'firebaseID': firebaseUser.uid,
          'contactNumber': _contactInputController.text.toString().trim(),
          'pecMailID': _pecMailIDController.text.toString().trim(),
          'achievements': achievementsList,
        });

        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString(
          'studentName',
          _nameInputController.text.toString().trim(),
        );
        await prefs.setString(
          'studentSID',
          _SIDInputController.text.toString().trim(),
        );
        await prefs.setString('firebaseID', currentUser.uid);
        await prefs.setString(
          'contactNumber',
          _contactInputController.text.toString().trim(),
        );
        await prefs.setString(
          'pecMailID',
          _pecMailIDController.text.toString().trim(),
        );
      } else {
        // Write data to local
        await prefs.setString('studentName', documents[0]['studentName']);
        await prefs.setString('studentSID', documents[0]['studentSID']);
        await prefs.setString('firebaseID', documents[0]['firebaseID']);
        await prefs.setString('contactNumber', documents[0]['contactNumber']);
        await prefs.setString('pecMailID', documents[0]['pecMailID']);
      }
      this.setState(() {
        isLoading = false;
      });

      Navigator.pushReplacementNamed(
        context,
        HomePage.routeName,
      );
    } else {
      this.setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.symmetric(
          vertical: 50.0,
          horizontal: 10.0,
        ),
        children: <Widget>[
          mainLogoLoginPage('assets/images/minor_logo.png'),
          Form(
            key: _studentLoginFormKey,
            child: Column(
              children: <Widget>[
                formFields(
                  editingController: _nameInputController,
                  errorMessage: 'Please enter your name',
                  hintText: 'Username',
                  preIcon: Icon(Icons.person),
                ),
                formFields(
                  editingController: _contactInputController,
                  errorMessage: 'Please enter your contact number',
                  hintText: 'Contact Number',
                  preIcon: Icon(Icons.phone_android),
                ),
                formFields(
                  editingController: _pecMailIDController,
                  errorMessage: 'Please enter your PEC mail ID',
                  hintText: 'PEC email ID',
                  preIcon: Icon(Icons.mail),
                ),
                formFields(
                  editingController: _SIDInputController,
                  errorMessage: 'Please enter your SID/College ID',
                  hintText: 'SID/College ID',
                  preIcon: Icon(Icons.contacts),
                ),
                SizedBox(
                  height: 30.0,
                ),
                buttons(
                  function: () {
                    _checkInternetConnection();
                    if (_studentLoginFormKey.currentState.validate() &&
                        isConnected) {
                      //print("Valid");
                      handleSignIn();
                    }
                  },
                  widget: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: isLoading
                          ? CircularProgressIndicator(
                              backgroundColor: Colors.white,
                            )
                          : Text(
                              'Login',
                              style: TextStyle(fontSize: 15.0),
                            ),
                    ),
                  ),
                ),
                isLoading
                    ? Container(
                        child: Text(
                          'Please wait',
                          style: TextStyle(
                            color: greenColor,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
