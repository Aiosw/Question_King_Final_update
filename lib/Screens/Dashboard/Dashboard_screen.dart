import 'package:flutter/material.dart';
import 'package:competitive_exam_app/Screens/Dashboard/Drawer.dart';
import 'package:competitive_exam_app/Screens/Dashboard/components/body.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:google_sign_in/google_sign_in.dart';

class DashBoardScreen extends StatefulWidget {
  @override
  _DashBoardScreen createState() => _DashBoardScreen();
}

class _DashBoardScreen extends State<DashBoardScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard"),
        backgroundColor: kPrimaryColor,
        foregroundColor: kPrimaryLightColor,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Constants.prefs.setString('langCd', '');
                Constants.prefs.setString('f_Name', '');
                Constants.prefs.setString('logId', '');
                Constants.prefs.setBool("loggedIn", false);
                GoogleSignIn _googleSignIn = GoogleSignIn();
                _googleSignIn.signOut();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  "/LoginScreen",
                  (route) => false,
                );
              })
        ],
      ),
      body: Body(),
      drawer: MDrawer(),
    );
  }
}
