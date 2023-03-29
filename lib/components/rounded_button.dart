import 'package:flutter/material.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color  color,textColor;
  const RoundedButton({
    Key key,
    this.text,
    this.press,
    this.color = kPrimaryColor,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      //  decoration: BoxDecoration(
      //                   // boxShadow: [
      //                   //   BoxShadow(
      //                   //     offset: Offset(2, 2),
      //                   //     blurRadius: 12,
      //                   //     color: Colors.yellowAccent,
      //                   //   )
      //                   // ],
      //                   color: kPrimaryColor,
      //                    gradient: LinearGradient(
      //                   colors: [
      //             const Color(0xFFF1E6FF),kPrimaryColor,
      //           ],
      //           begin: const FractionalOffset(0.1, 0.1),
      //           end: const FractionalOffset(1.0, 0.5),
      //           stops: [0.2, 1.0],
      //           tileMode: TileMode.clamp),
      //           ),
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: MaterialButton(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
          color:  color,
          onPressed: press,
            shape: RoundedRectangleBorder(side: BorderSide(
            color: Colors.white,
            width: 1,
            style: BorderStyle.solid
          ), borderRadius: BorderRadius.circular(50)),
          child: Text(
            text,
            style: TextStyle(color: textColor),
          ),
        ),
      ),
    );
  }
}
