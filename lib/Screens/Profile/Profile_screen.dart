import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class Profile extends StatefulWidget {

  @override
  _Profile createState() => _Profile();
}

class _Profile extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text("Profile"),
        backgroundColor: kPrimaryColor,
        actions: <Widget>[
        ],
      ),
      body: Body(),
    );
  }
}
