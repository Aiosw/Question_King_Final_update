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
        //color: kPrimaryColor,
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
      // color: Colors.black87.withOpacity(0.5),
      width: size.width,
      //  color: Colors.black87.withOpacity(0.5),
      //  width: double.infinity,
      height: 750,
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
              // colorBlendMode: BlendMode.darken,
            ),
          ),
          // Positioned(
          //   bottom: 50,
          //   right: 2,
          //   left: 2,
          //   top: 50,
          //   child: Image.asset(
          //     "asset/bdDashborad.jpg",
          //     width: size.width * 2,
          //     color: Colors.black.withOpacity(0.5),
          //     colorBlendMode: BlendMode.darken,
          //   ),
          // ),
          // Positioned(
          //   bottom: 0,
          //   right: 0,
          //   child: Image.asset(
          //     "asset/images/login_bottom.png",
          //     width: size.width * 0.4,
          //     color: Colors.black.withOpacity(0.5),
          //    // colorBlendMode: BlendMode.darken,
          //   ),
          // ),
          child,
        ],
      ),
    );
  }
}
