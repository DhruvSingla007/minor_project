import 'package:flutter/material.dart';

import '../constants.dart';

class MentorListView extends StatelessWidget {

  final List<String> mentorInfo;

  MentorListView({
    @required this.mentorInfo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          title: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Icon(
                  Icons.person,
                  color: greenColor,
                ),
              ),
              Text(mentorInfo[1] + " (" + mentorInfo[0] + ")")
            ],
          ),
          subtitle: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 4.0,
                  top: 8.0,
                  bottom: 4.0,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.call,
                      color: greenColor,
                      size: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: Text(mentorInfo[2]),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 4.0,
                  top: 4.0,
                  bottom: 8.0,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.mail,
                      color: greenColor,
                      size: 15.0,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                      ),
                      child: Text(mentorInfo[3]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
