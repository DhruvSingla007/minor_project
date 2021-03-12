import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:minor_project/pages/about_page.dart';
import 'package:minor_project/pages/app_coordinators/app_coordinators_page.dart';
import 'package:minor_project/pages/become_a_mentor/become_mentor_page.dart';
import 'package:minor_project/pages/find_a_mentor/find_a_mentor_page.dart';
import 'package:minor_project/pages/my_profile_page.dart';
import 'package:minor_project/pages/sessions/sessions_page.dart';
import 'package:minor_project/pages/team_members/members_page.dart';
import 'package:minor_project/pages/workshops/workshops_page.dart';
import 'pages/events_page.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'pages/splash_screen_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      home: LoginPage(),
      theme: ThemeData.dark(),
      title: 'Campus Guide',
      debugShowCheckedModeBanner: false,
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        HomePage.routeName: (context) => HomePage(),
        EventsPage.routeName: (context) => EventsPage(),
        WorkshopsPage.routeName: (context) => WorkshopsPage(),
        SessionsPage.routeName: (context) => SessionsPage(),
        FindMentorPage.routeName: (context) => FindMentorPage(),
        AboutPage.routeName: (context) => AboutPage(),
        TeamMembersPage.routeName: (context) => TeamMembersPage(),
        MentorsPage.routeName: (context) => MentorsPage(),
        AppCoordinatorsPage.routeName: (context) => AppCoordinatorsPage(),
        MyProfilePage.routeName: (context) => MyProfilePage(),
      },
    );
  }
}
