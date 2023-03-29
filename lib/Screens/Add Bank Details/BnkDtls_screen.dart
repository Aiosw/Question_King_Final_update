import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:flutter/material.dart';

import 'components/body.dart';

class BnkDtls extends StatefulWidget {

  @override
  _BnkDtls createState() => _BnkDtls();
}

class _BnkDtls extends State<BnkDtls> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text("Your Bank Details"),
        backgroundColor: kPrimaryColor,
        actions: <Widget>[
        ],
      ),
      body: Body(),
    );
  }
}
