import 'package:flutter/material.dart';

class loaders {
  Widget get apiLoader {
    return Container(
      color: Colors.black,
      child: Center(
        child: Container(
          height: 200,
          width: 200,
          //width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("asset/icons/QKIcon.png"), fit: BoxFit.cover),
          ),
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF006064))),
        ),
      ),
    );
  }
}
