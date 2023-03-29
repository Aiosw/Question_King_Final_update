
import 'package:competitive_exam_app/Screens/Result/components/body.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:flutter/material.dart';

class Result extends StatefulWidget {

  @override
  _Result createState() => _Result();
}

class _Result extends State<Result> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text("Result"),
        backgroundColor: kPrimaryColor,
        actions: <Widget>[
        ],
      ),
      body: Body(),
    );
  }
}
