import 'package:competitive_exam_app/Screens/Dashboard/components/background.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';

class Sliders extends StatefulWidget {
  @override
  _Sliders createState() => _Sliders();
}

class _Sliders extends State<Sliders> {
  List<Slide> slides = [];

  @override
  void initState() {
    slides.add(
      Slide(
        title: "Login and Create Profile",
        description: "Add Some Basic Details and your Beautiful Picture.",
        pathImage: "asset/images/2.png",
        colorBegin: kPrimaryColor,
        colorEnd: Colors.orange,
      ),
    );
    slides.add(
      Slide(
        title: "Add Money to Wallet",
        description:
            "Add money from your bank to wallet. Don't Worry it's safe, secure and refundable",
        pathImage: "asset/images/3.png",
        // backgroundColor:   Colors.orange,kPrimaryColor,
        colorBegin: kPrimaryColor,
        colorEnd: Colors.orange,
      ),
    );
    slides.add(
      Slide(
        title: "Wait Till Exam Start",
        description:
            "there will be five session Everyday as shown in Dashboard. Exam will start at time. Participate has to pay 1 ₹ per session for play the game. keep your push notification turn on so you can aware for next session",
        pathImage: "asset/images/4.png",
        //   backgroundColor:   Colors.orange,kPrimaryColor,
        colorBegin: kPrimaryColor,
        colorEnd: Colors.orange,
      ),
    );
    slides.add(
      Slide(
        title: "Questions & Answer",
        description:
            "At The Time Of Exam there are 10 Question one by one will Display on Screen. Participant Get 10 second for Each Question .participant hast to Answer all the Questions. After The Exam Result Will Display participant will Get Score And Winning amount. Participant Can Share his/her Result in Social Media. Most Of Participant can Get His 1 Rupees Back In He/her Fulfill Criteria.",
        pathImage: "asset/images/5.png",
        //  backgroundColor: const Color(0xff9932CC),
        colorBegin: kPrimaryColor,
        colorEnd: Colors.orange,
      ),
    );
    slides.add(
      Slide(
        title: "Win Prize",
        description:
            "Check Your Wallet Your Winning Amount will Credit quickly.",
        pathImage: "asset/images/6.png",
        //  backgroundColor: const Color(0xff9932CC),
        colorBegin: kPrimaryColor,
        colorEnd: Colors.orange,
      ),
    );
  }

  void onDonePress() {
    // Do what you want
  //  print("End of slides");
     Navigator.pushReplacementNamed(context, "/Profile");
  }

  @override
  Widget build(BuildContext context) {
    return IntroSlider(
      slides: slides,
      onDonePress: onDonePress,
    );
  }
}
