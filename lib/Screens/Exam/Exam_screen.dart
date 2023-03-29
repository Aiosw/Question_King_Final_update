import 'package:competitive_exam_app/Screens/Exam/components/body.dart';
import 'package:flutter/material.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';


class ExamScreen extends StatefulWidget {

  @override
  _ExamScreen createState() => _ExamScreen();
}

class _ExamScreen extends State<ExamScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text("Exam Screen"),
        backgroundColor: kPrimaryColor,
        foregroundColor: kPrimaryLightColor,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                // Constants.prefs.setBool("loggedIn", false);
                // Navigator.pushNamed(context, "/LoginScreen");
              })
        ],
      ),
      body: Body(
        
      ),
    );
  }
}
