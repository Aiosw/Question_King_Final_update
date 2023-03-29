import 'package:competitive_exam_app/Screens/Wallet/components/body.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:flutter/material.dart';

class Wallet extends StatefulWidget {

  @override
  _Wallet createState() => _Wallet();
}

class _Wallet extends State<Wallet> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text("Wallet"),
        backgroundColor: kPrimaryColor,
        actions: <Widget>[
        ],
      ),
      body: Body(),
    );
  }
}
