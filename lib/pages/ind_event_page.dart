import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/Widgets/info_column.dart';
import 'package:minor_project/constants.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class IndEventPage extends StatefulWidget {

  static const String routeName = "/ind-event-page";

  final DocumentSnapshot documentSnapshot;

  IndEventPage({
    @required this.documentSnapshot,
  });

  @override
  _IndEventPageState createState() => _IndEventPageState();
}

class _IndEventPageState extends State<IndEventPage> {

  String studentID  = "";
  SharedPreferences sharedPreferences;

  bool isLoading = false;

  Future<void> updateAttendedStudentsArray() async {

    setState(() {
      isLoading = true;
    });

    DocumentReference docRef = Firestore.instance.collection('events').document(widget.documentSnapshot.data[firestoreNameLabel]);
    DocumentSnapshot docSnapshot = await docRef.get();
    List attendedStudents = docSnapshot.data['studentsAttended'];

    if(attendedStudents.contains(studentID) == true){
      Toast.show("Attendance already marked", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

    } else {
      //print("+++++++++++++++++++++++++++++++++++++++++");
      //print(attendedStudents.contains(studentID) == true);
      docRef.updateData({
        'studentsAttended' : FieldValue.arrayUnion([studentID])
      });

      Toast.show("Attendance marked successfully", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

    }


    setState(() {
      isLoading = false;
    });
  }

  Future<void> scan() async{
    String barcode = await BarcodeScanner.scan();
    if(barcode.toString().toLowerCase().trim() == widget.documentSnapshot.data[fireStoreAttendanceUniqueKey]){
      updateAttendedStudentsArray();
    } else {
      Toast.show("Invalid QR Code", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }
    //UniqueKey
    //print(barcode);
  }

  Future<void> _getInfo() async {
    sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      studentID = sharedPreferences.getString("studentSID");
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
        title: Text('Event'),
        centerTitle: true,
      ),
      body: infoListView(
        context: context,
        imageUrl : widget.documentSnapshot.data[firestoreImageUrl],
        name: widget.documentSnapshot.data[firestoreNameLabel],
        hostName: widget.documentSnapshot.data[firestoreHostNameLabel] ,
        time:  widget.documentSnapshot.data[firestoreTimeLabel],
        date: widget.documentSnapshot.data[firestoreDateLabel],
        location: widget.documentSnapshot.data[firestoreLocationLabel],
        description: widget.documentSnapshot.data[firestoreDescriptionLabel],
        attendanceButtonFunction: () => scan(),
      ),
    );
  }
}
