import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/Widgets/mentor_listview.dart';
import 'package:minor_project/constants.dart';

class MentorListPage extends StatefulWidget {
  final String sub;

  MentorListPage({
    @required this.sub,
  });

  @override
  _MentorListPageState createState() => _MentorListPageState();
}

class _MentorListPageState extends State<MentorListPage> {
  bool isLoading = false;
  bool contactLoading = false;
  List mentorList;

  Future<void> getMentorList() async {
    setState(() {
      isLoading = true;
    });

    DocumentReference documentReference =
        Firestore.instance.collection('mentors').document(widget.sub);
    DocumentSnapshot documentSnapshot = await documentReference.get();

    setState(() {
      mentorList = documentSnapshot.data['mentor_list'];
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMentorList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mentors'),
        centerTitle: true,
      ),
      body: isLoading == false
          ? ListView.builder(
              itemCount: mentorList.length,
              itemBuilder: (context, index) {
                List<String> mentorInfo =
                    mentorList[index].toString().split("_");
                return MentorListView(mentorInfo: mentorInfo);
              })
          : Container(
              child: Center(
                child: Text("Unexpected error occurred"),
              ),
            ),
    );
  }
}
