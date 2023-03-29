import 'package:flutter/material.dart';

class loaders {
  Widget get apiLoader {
    return Container(
      color: Colors.transparent,
      child: Center(
        child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF006064))),
      ),
    );
  }
}
