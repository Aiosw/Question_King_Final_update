import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;
  const Background({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            offset: Offset(2, 2),
            blurRadius: 12,
            color: kPrimaryColor,
          )
        ],
        gradient: LinearGradient(
            colors: [
              Colors.orange,
              kPrimaryColor,
            ],
            begin: const FractionalOffset(0.1, 0.1),
            end: const FractionalOffset(1.0, 0.5),
            stops: [0.2, 1.0],
            tileMode: TileMode.clamp),
      ),
      width: size.width,
      height: size.height,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            child: Image.asset(
              "asset/images/main_top.png",
              width: size.width * 0.35,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
