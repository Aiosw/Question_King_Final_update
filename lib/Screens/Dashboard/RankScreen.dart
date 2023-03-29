import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

import '../../Utils/Constant.dart';
import '../Exam/components/body.dart';

class RankScreen extends StatefulWidget {
  const RankScreen({Key key}) : super(key: key);

  @override
  State<RankScreen> createState() => _RankScreenState();
}

class _RankScreenState extends State<RankScreen> {
  int ansTr = 0;
  String res = "1";
  String winningPrice = "-1";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callIt();
  }

  callIt() async {
    String name = Constants.prefs.getString("FName");
    String profPic = Constants.prefs.getString("profileImg") == null
        ? 'default.png'
        : Constants.prefs.getString("profileImg");

    Dialog diloag = Dialog(
        insetPadding: EdgeInsets.only(left: 18, right: 18),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0)), //this right here
        child: ResultDialogBoxWidget(
            name, profPic, ansTr.toString(), winningPrice));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(context: context, builder: (BuildContext context) => diloag);
    });
  }

  // return Container();

  @override
  buildCounter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 400,
        // height: timcount<8?MediaQuery.of(context).size.height/5: Aniheight,
        // duration: Duration(seconds: 2),
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
                Colors.orange[100],
                Colors.orangeAccent,
              ],
              begin: const FractionalOffset(0.1, 0.1),
              end: const FractionalOffset(1.0, 0.5),
              stops: [0.2, 1.0],
              tileMode: TileMode.clamp),
          //color: Colors.amber,
          borderRadius: BorderRadius.circular(29),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(children: [
            Text(
                "When you have a dream, you've got to grab it and never let go."),
            Text("— Carol Burnett"),
            SizedBox(
              height: 50,
            ),
            res == "1" && winningPrice != "-1"
                ? InkWell(
                    onTap: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(
                        builder: (context) {
                          return RankScreen();
                        },
                      ));
                    },
                    child: Container(
                      color: kPrimaryLightColor,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
                      child: Text("Show Rank"),
                    ),
                  )
                : Center(
                    child: TimerCountdown(
                      format: CountDownTimerFormat.secondsOnly,
                      // endTime: getNextIntervalTime(),
                      // onEnd: () async {
                      //   print("Timer finished");
                      //   await getResults();
                      //   setState(() {
                      //     res = "1";
                      //   });
                      // },
                      timeTextStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                      colonsTextStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                      descriptionTextStyle: TextStyle(
                        color: Colors.black87,
                        fontSize: 18,
                      ),
                      spacerWidth: 5,
                    ),
                  ),
            SizedBox(
              height: 50,
            ),
            Text(
              "Please Wait we are getting your Result Ready...",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            // res == "1" && winningPrice != "-1"
            //     ? InkWell(
            //         onTap: () {
            //           Navigator.pushReplacement(context, MaterialPageRoute(
            //             builder: (context) {
            //               return RankScreen();
            //             },
            //           ));
            //         },
            //         child: Container(
            //           color: kPrimaryLightColor,
            //           padding: const EdgeInsets.symmetric(
            //               horizontal: 30, vertical: 10),
            //           child: Text("Show Rank"),
            //         ),
            //       )
            //     : Container(
            //         child: Text("Should not show ${res}"),
            //       ),
          ]),
        ),
      ),
    );
  }

  dialog() {
    Dialog diloag = Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.only(left: 18, right: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: buildCounter(),
    ); //this right here

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(context: context, builder: (BuildContext context) => diloag);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
            child: Container(
          child: Text("HELLO"),
        )),
      ),
    );
  }
}
