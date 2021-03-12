import 'package:flutter/material.dart';

import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = "/splash-screen-page";

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

Widget mainLogo(String mainLogoPath){
  return Hero(
    tag: 'logo',
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Image.asset(
        mainLogoPath,
        height: 250.0,
        width: 250.0,
        fit: BoxFit.contain,
      ),
    ),
  );
}

Widget subLogos(String subLogosPath){
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Image.asset(
        subLogosPath,
        fit: BoxFit.contain,
      ),
    ),
  );
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    new Future.delayed(Duration(milliseconds: 5000)).then((val) {
      Navigator.pushReplacementNamed(
        context,
        LoginPage.routeName,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          mainLogo('assets/images/IEEE_main_logo.png'),
          Row(
            children: <Widget>[
              subLogos('assets/images/ieee_cs.png'),
              subLogos('assets/images/ieee_wie.png'),
              subLogos('assets/images/ieee_pes.png'),
            ],
          ),
        ],
      ),
    );
  }
}
