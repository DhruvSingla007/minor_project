import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:minor_project/Widgets/achievements_listview.dart';
import 'package:minor_project/pages/app_coordinators/add_achievements_page.dart';

class AchievementsListPage extends StatefulWidget {
  final String SID;

  AchievementsListPage({
    this.SID,
  });

  @override
  _AchievementsListPageState createState() => _AchievementsListPageState();
}

class _AchievementsListPageState extends State<AchievementsListPage> {
  bool isLoading = false;
  List achievementsList;

  Future<void> _getAchievementsList() async {
    setState(() {
      isLoading = true;
    });

    DocumentReference documentReference =
        Firestore.instance.collection("users").document(widget.SID);
    DocumentSnapshot documentSnapshot = await documentReference.get();

    setState(() {
      achievementsList = documentSnapshot.data["achievements"];
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAchievementsList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Achievements"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AddAchievementsPage(
              SID: widget.SID,
            ),
          ),
        ),
        child: Icon(Icons.add),
        elevation: 10.0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: isLoading == false
          ? SafeArea(
              child: ListView.builder(
                itemCount: achievementsList.length,
                itemBuilder: (context, index) {
                  List<String> achievementInfo =
                      achievementsList[index].toString().split("_");
                  return AchievementsListView(achievementInfo: achievementInfo);
                },
              ),
            )
          : Container(
              child: Center(
                child: Text("No Achievements Available"),
              ),
            ),
    );
  }
}
