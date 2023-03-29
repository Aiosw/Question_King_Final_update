import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class QBank extends StatefulWidget {

  @override
  _QBank createState() => _QBank();
}

class _QBank extends State<QBank> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //  appBar: AppBar(
      //   title: Text("Question Bank"),
      //   backgroundColor: kPrimaryColor,
      // ),
      body: Body(),
    );
  }
}
