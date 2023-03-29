import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:competitive_exam_app/Model/ExamMdl.dart';
import 'package:competitive_exam_app/Model/LedgerModel.dart';
import 'package:competitive_exam_app/Screens/Dashboard/RankScreen.dart';
import 'package:competitive_exam_app/Service/ExamService.dart';
import 'package:competitive_exam_app/Service/PaymentService.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter_pw_validator/Resource/MyColors.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:competitive_exam_app/Screens/Dashboard/components/background.dart';
import 'package:competitive_exam_app/interceptor/dio_connectivity_request_retrier.dart';
import 'package:competitive_exam_app/interceptor/retry_interceptor.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

class Body extends StatefulWidget {
  _Body createState() => _Body();
  Body({Key key}) : super(key: key);
}

String bdcategory, subCategory;

retnull() {
  return Container(
    child: Padding(
      padding: const EdgeInsets.only(top: 80.0),
      child: Center(
        child: Text("This Time not Start Exam!",
            style: new TextStyle(
                color: Colors.white70,
                fontWeight: FontWeight.w900,
                fontSize: 25)),
      ),
    ),
  );
}

retnullData() {
  return Container(
    child: Padding(
      padding: const EdgeInsets.only(top: 300.0, left: 12.0),
      child: Center(
        child: Text(
            "Exam Question are not set today please Try after some time!",
            style: new TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 25)),
      ),
    ),
  );
}

class _Body extends State<Body> with TickerProviderStateMixin {
  Dio dio;
  bool isloading;
  final _formKey = GlobalKey<FormState>();
  int touchedIndex;
  final Duration updateDuration = const Duration(minutes: 1);
  int col = 0;
  Timer _timer;

  String bal;
  List<ExamModel> qAData;
  int timcount = 10;
  int cnt = 0;
  String cont = "1";
  String result = "0";
  int totcnt = 0;
  int ansTr = 0;
  int ansFl = 0;
  int notAt = 0;
  int checkNotAt = 0;
  String winningPrice = "-1";
  bool stk = true;
  Color _colorContainer1 = Colors.orange[50];
  Color _colorContainer2 = Colors.orange[50];
  Color _colorContainer3 = Colors.orange[50];
  Color _colorContainer4 = Colors.orange[50];
  double Aniheight = 120;
  //   Color _colorContainer1 = colorAnimation.value;
  // Color _colorContainer2 = colorAnimation.value;
  // Color _colorContainer3 = colorAnimation.value;
  // Color _colorContainer4 = colorAnimation.value;
  List<LedgerModel> LedgerLst;
  String res = "0";
  int temp = 0;
  String q1, o1, o2, o3, o4, at, sessionNo, date, tym, userCd, dtAdd;
  DateTime dt;
  String StartTime;
  String EndTime;
  bool _slowAnimations = false;

  add(ExamModel ExAddModel) async {
    //  EasyLoading.show(status: 'Wait...');
    await Examservice().examAdd(ExAddModel).then((sucess) {
      getResults();
      print("Add Sucessfully");
      //  EasyLoading.dismiss();
    });
  }

  getResults() async {
    DateTime date = DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy');
    String dt = formatter.format(date);
    print("response.data : " + dt);
    // ExamModel exMdl =
    //     new ExamModel(sessionNo: sessionNo, Date: dt, userCd: userCd);
    ExamModel exMdl =
        new ExamModel(sessionNo: "2", Date: "25/01/2023", userCd: userCd);
    //  var data = await Examservice().getResults(exMdl);
    chekres(exMdl);
  }

  Future<String> chekres(ExamModel exMd) async {
    String st = await Examservice().getResults(exMd);
    if (st == "No Record Found") {
      String sts = await Examservice().setResult(exMd);
      if (sts == "success") {
        st = await Examservice().getResult(exMd);
      }
    }
    st = await Examservice().getResult(exMd);

    var decodedPrd = json.decode(st).cast<Map<String, dynamic>>();
    List<ExamModel> ledList = await decodedPrd
        .map<ExamModel>((json) => ExamModel.fromjson(json))
        .toList();

    List<ExamModel> resultList = ledList.where((element) {
      return (element.Date == exMd.Date && element.sessionNo == exMd.sessionNo);
    }).toList();

    String winningPriceLocal = "not found";
    if (resultList.isNotEmpty) {
      winningPriceLocal = resultList[0].Rst;
    }

    setState(() {
      winningPrice = winningPriceLocal;
    });

    print("winning price : " + winningPrice.toString());

    print("record data f312 : " + st);
  }

  addledger(LedgerModel LedgerModel) async {
    await PaymentService().LedgerAdd(LedgerModel).then((sucess) {
      print("Add Sucessfully");
      quesAns();
      timerstart();
    });
  }

  Future<double> getCurrentBal() async {
    String loginCd = Constants.prefs.getString('logId');
    LedgerModel ledMdl = LedgerModel(userCd: loginCd);
    print(ledMdl.userCd);
    LedgerLst = await PaymentService().getLedgerBal(ledMdl);
    if (LedgerLst != null) {
      LedgerModel ledMdl = LedgerLst[0];
      setState(() {
        bal = ledMdl.val == null ? "0" : ledMdl.val;
        TransDeductAmt();
      });
    }
  }

  @override
  void initState() {
    getCurrentBal();
    // TransDeductAmt();
    // controller =
    //     AnimationController(vsync: this, duration: Duration(seconds: 4));
    // colorAnimation = ColorTween(begin: Colors.orange[50], end: Colors.white)
    //     .animate(controller);
    // // sizeAnimation = Tween<double>(begin: 100.0, end: 150.0).animate(controller);

    // opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
    //     parent: controller,
    //     curve: Interval(0.40, 0.75, curve: Curves.easeOut)));
    //   controller.addListener(() {
    //   setState(() {});
    // });

    dio = Dio();
    isloading = true;
    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: dio,
          connectivity: Connectivity(),
        ),
      ),
    );
  }

  void timerstart() {
    DateTime date = DateTime.now();
    var formatterTime = DateFormat('hh:mm:ss');
    StartTime = formatterTime.format(date);
    const oneSec = const Duration(seconds: 1);
    const oneMIKSec = const Duration(milliseconds: 10);

    _timer = new Timer.periodic(
      // oneMIKSec,
      oneSec,
      (Timer timer) {
        if (qAData != null) {
          if (timcount == 0) {
            if (checkNotAt == 0) {
              notAt = notAt + 1;
            }

            if (cnt == 9) {
              saveData();
              timerstop();
              return;
            }

            setState(() {
              _colorContainer1 = Colors.orange[50];
              _colorContainer2 = Colors.orange[50];
              _colorContainer3 = Colors.orange[50];
              _colorContainer4 = Colors.orange[50];
              temp = 0;
              cnt = cnt + 1;
              checkNotAt = 0;
              if (cnt < 11) {
                // getQuickData();
              }
              timcount = 10;
            });
          } else {
            setState(() {
              timcount = timcount - 1;
            });
          }
        }
      },
    );
  }

  void TransDeductAmt() {
    userCd = Constants.prefs.getString('logId');
    if (double.parse(bal == null ? "0" : bal) > 0) {
      LedgerModel ledMdl = LedgerModel(
          val: "-1",
          Amt: "1",
          Desc: "3",
          userCd: userCd,
          vchDate: DateTime.now().toString(),
          vchType: "21");
      addledger(ledMdl);
    } else {
      // retnull();
      Fluttertoast.showToast(
          msg:
              "Your Wallet Balance is low First Add Money After eligible for Exam",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 10,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  void saveData() {
    DateTime date = DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy');
    dtAdd = formatter.format(date);
    ExamModel examMdl = ExamModel(
      sessionNo: sessionNo,
      Date: dtAdd.toString(),
      obtainMark: ansTr.toString(),
      AnsFl: ansFl.toString(),
      NotAttend: (10 - (ansFl + ansTr)).toString(),
      userCd: Constants.prefs.getString('logId'),
    );
    add(examMdl);

    setState(() {
      // winningPrice = winningPriceLocal;
      res = "2";
      // res = "1";
    });
  }

  Future<String> quesAns() async {
    tym = new DateTime.now().hour.toString();
    sessionNo = tym == "9"
        ? "1"
        : tym == "12"
            ? "2"
            : tym == "15"
                ? "3"
                : tym == "18"
                    ? "4"
                    : tym == "21"
                        ? "5"
                        : "1";
    DateTime date = DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy');
    String dt = formatter.format(date);
    String language = Constants.prefs.getString('langCd');
    ExamModel exm = ExamModel(sessionNo: sessionNo, Date: dt, langCd: language);
    if (sessionNo != null) {
      qAData = await Examservice().getQuestion(exm);
      setState(() {
        isloading = false;
      });
    }
  }

  setnull() {
    return Container();
  }

  timerstop() {
    _timer.cancel();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void setLstData() {
    if (qAData != null) {
      if (qAData.length > 0) {
        totcnt = qAData.length;
        cont = (cnt + 1).toString() + '/10';
        if (cnt < 10) if (cnt <= qAData.length) {
          for (int i = cnt; i < cnt + 1; i++) {
            q1 = qAData[i].Que;
            o1 = qAData[i].o1;
            o2 = qAData[i].o2;
            o3 = qAData[i].o3;
            o4 = qAData[i].o4;
            at = qAData[i].AnsNum;
            print("at : " + at.toString());
          }
        }
      }
    }
  }

  getQuickData(BuildContext context) {
    setLstData();
    return qAData.length != 0
        ? Padding(
            padding: const EdgeInsets.all(4.0),
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  AnimatedContainer(
                    // height: timcount<8?MediaQuery.of(context).size.height/5: Aniheight,
                    duration: Duration(seconds: 2),

                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(2, 2),
                            blurRadius: 12,
                            color: kPrimaryColor,
                          )
                        ],
                        // gradient: LinearGradient(
                        //     colors: [
                        //       Colors.orange[50],
                        //       Colors.orangeAccent,
                        //     ],
                        //     begin: const FractionalOffset(0.1, 0.1),
                        //     end: const FractionalOffset(1.0, 0.5),
                        //     stops: [0.2, 1.0],
                        //     tileMode: TileMode.clamp),
                        color: timcount < 8 ? Colors.amber : Colors.orange[50],
                        borderRadius: BorderRadius.all((Radius.circular(20))),
                        border: Border.all(width: 1, color: kPrimaryColor)),
                    child: Column(
                      children: [
                        Container(
                          // width: sizeAnimation.value,
                          decoration: new BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(2, 2),
                                blurRadius: 12,
                                color: kPrimaryColor,
                              )
                            ],
                            color: kPrimaryColor,
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0, bottom: 8.0),
                            child: Text("$timcount",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 45)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(q1.trim(),
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20)),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    child: AnimatedContainer(
                      duration: Duration(seconds: 0),
                      // color: myColor,
                      //   width: sizeAnimation.value,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(2, 2),
                              blurRadius: 12,
                              color: kPrimaryColor,
                            )
                          ],
                          color: _colorContainer1,
                          borderRadius: BorderRadius.all((Radius.circular(40))),
                          border: Border.all(width: 1, color: Colors.white)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                //      width: sizeAnimation.value,
                                child: new Text("A.",
                                    style: new TextStyle(
                                        color: Colors.purple[600],
                                        fontWeight: FontWeight.w900,
                                        fontSize: 20)),
                              ),
                              SizedBox(
                                width: 14,
                              ),
                              Expanded(
                                  child: Container(
                                child: Text(o1.trim(),
                                    textAlign: TextAlign.justify,
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20)),
                              )),
                            ]),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        if (temp == 0) {
                          if (at == "1") {
                            _colorContainer1 =
                                _colorContainer1 == Colors.orange[50]
                                    ? Colors.greenAccent
                                    : Colors.orange[50];
                            ansTr = ansTr + 1;
                            checkNotAt = 1;
                          } else {
                            _colorContainer1 =
                                _colorContainer1 == Colors.orange[50]
                                    ? Colors.redAccent
                                    : Colors.orange[50];
                            ansFl = ansFl + 1;
                            checkNotAt = 1;
                          }
                          temp = 1;
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    child: AnimatedContainer(
                      duration: Duration(seconds: 0),
                      //  color: myColor,
                      //  height: sizeAnimation.value,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(2, 2),
                              blurRadius: 12,
                              color: kPrimaryColor,
                            )
                          ],
                          color: _colorContainer2,
                          borderRadius: BorderRadius.all((Radius.circular(40))),
                          border: Border.all(width: 1, color: Colors.white)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(children: [
                          Container(
                            //    width: sizeAnimation.value,
                            child: new Text("B.",
                                style: new TextStyle(
                                    color: Colors.purple[600],
                                    fontWeight: FontWeight.w900,
                                    fontSize: 20)),
                          ),
                          SizedBox(
                            width: 14,
                          ),
                          Expanded(
                              child: Container(
                            child: Text(o2.trim(),
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20)),
                          )),
                        ]),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        if (temp == 0) {
                          if (at == "2") {
                            _colorContainer2 =
                                _colorContainer2 == Colors.orange[50]
                                    ? Colors.greenAccent
                                    : Colors.orange[50];
                            ansTr = ansTr + 1;
                            checkNotAt = 1;
                          } else {
                            ansFl = ansFl + 1;
                            _colorContainer2 =
                                _colorContainer2 == Colors.orange[50]
                                    ? Colors.redAccent
                                    : Colors.orange[50];
                            checkNotAt = 1;
                          }
                          temp = 1;
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    child: AnimatedContainer(
                      duration: Duration(seconds: 0),
                      //   color: myColor,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(2, 2),
                              blurRadius: 12,
                              color: kPrimaryColor,
                            )
                          ],
                          color: _colorContainer3,
                          borderRadius: BorderRadius.all((Radius.circular(40))),
                          border: Border.all(width: 1, color: Colors.white)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(children: [
                            Container(
                              //  width: sizeAnimation.value,
                              child: new Text("C.",
                                  style: new TextStyle(
                                      color: Colors.purple[600],
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20)),
                            ),
                            SizedBox(
                              width: 14,
                            ),
                            Expanded(
                                child: Container(
                              child: Text(o3.trim(),
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            )),
                          ]),
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        if (temp == 0) {
                          if (at == "3") {
                            _colorContainer3 =
                                _colorContainer3 == Colors.orange[50]
                                    ? Colors.greenAccent
                                    : Colors.orange[50];
                            ansTr = ansTr + 1;
                            checkNotAt = 1;
                          } else {
                            _colorContainer3 =
                                _colorContainer3 == Colors.orange[50]
                                    ? Colors.redAccent
                                    : Colors.orange[50];
                            ansFl = ansFl + 1;
                            checkNotAt = 1;
                          }
                          temp = 1;
                        }
                      });
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    child: AnimatedContainer(
                      duration: Duration(seconds: 0),
                      //   color: myColor,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(2, 2),
                              blurRadius: 12,
                              color: kPrimaryColor,
                            )
                          ],
                          color: _colorContainer4,
                          borderRadius: BorderRadius.all((Radius.circular(40))),
                          border: Border.all(width: 1, color: Colors.white)),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(children: [
                            Container(
                              //  width: sizeAnimation.value,
                              child: new Text("D.",
                                  style: new TextStyle(
                                      color: Colors.purple[600],
                                      fontWeight: FontWeight.w900,
                                      fontSize: 20)),
                            ),
                            SizedBox(
                              width: 14,
                            ),
                            Expanded(
                                child: Container(
                              child: Text(o4.trim(),
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            )),
                          ]),
                        ),
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        if (temp == 0) {
                          if (at == "4") {
                            _colorContainer4 =
                                _colorContainer4 == Colors.orange[50]
                                    ? Colors.greenAccent
                                    : Colors.orange[50];
                            ansTr = ansTr + 1;
                            checkNotAt = 1;
                          } else {
                            _colorContainer4 =
                                _colorContainer4 == Colors.orange[50]
                                    ? Colors.redAccent
                                    : Colors.orange[50];
                            ansFl = ansFl + 1;
                            checkNotAt = 1;
                          }
                          temp = 1;
                        }
                      });
                    },
                  ),
                ],
              ),
            ),
          )
        : retnullData();
  }

  showDialogwidget(BuildContext context) {
    Navigator.pop(context);

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

    return Container();
  }

  DateTime getNextIntervalTime() {
    DateTime currentTime = DateTime.now();
    DateTime timeOf9 = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 9, 2, 0, 0, 0);
    DateTime timeOf12 = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 12, 2, 0, 0, 0);
    DateTime timeOf15 = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 15, 2, 0, 0, 0);
    DateTime timeOf18 = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 20, 0, 0, 0, 0);
    DateTime timeOf21 = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 21, 2, 0, 0, 0);

    List<DateTime> listOfExamTime = [
      timeOf9,
      timeOf12,
      timeOf15,
      timeOf18,
      timeOf21,
    ];

    DateTime nextIntevalTime;

    for (int i = 0; i < listOfExamTime.length; i++) {
      if (listOfExamTime[i].millisecondsSinceEpoch >
          currentTime.millisecondsSinceEpoch) {
        nextIntevalTime = listOfExamTime[i];
        break;
      }
    }

    return nextIntevalTime;
  }

  @override
  buildCounter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 300,
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
            Center(
              child: TimerCountdown(
                format: CountDownTimerFormat.secondsOnly,
                endTime: getNextIntervalTime(),
                onEnd: () {
                  print("Timer finished");
                  getResults();
                  setState(() {
                    res = "1";
                  });
                },
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
          ]),
        ),
      ),
    );
  }

  showWaitDialogwidget(BuildContext context) {
    // Navigator.pop(context);

    Dialog diloag = Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.only(left: 18, right: 18),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: buildCounter(),
    ); //this right here

    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(context: context, builder: (BuildContext context) => diloag);
    });

    return Container(
      color: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    print("RES ---------------    " + res.toString());
    return Scaffold(
        body: Stack(fit: StackFit.expand, children: <Widget>[
      Background(
          child: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Row(
                      children: [
                        Text('No.: $cont',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20)),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(2, 2),
                          blurRadius: 12,
                          color: kPrimaryColor,
                        ),
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
                      borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(20), right: Radius.circular(0)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Text(
                        "₹ $bal",
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            isloading == false ? getQuickData(context) : setnull(),
            res == "1" && winningPrice != "-1"
                ? showDialogwidget(context)
                : res == "2" && winningPrice != "1"
                    ? showWaitDialogwidget(context)
                    : SizedBox()
          ],
        ),
      ))
    ]));
  }
}

class ResultDialogBoxWidget extends StatelessWidget {
  String name;
  String image;
  String score;
  String winningPrice;

  ResultDialogBoxWidget(this.name, this.image, this.score, this.winningPrice);

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy');
    String dt = formatter.format(date);

    ScreenshotController screenshotController = ScreenshotController();

    print("name 0 : " + name.toString());
    print("name 1 : " + image.toString());
    print("name 2 : " + score.toString());
    print("name 2 : " + winningPrice.toString());

    Widget insideScreenShotWidget(double opacity) {
      return Container(
        width: 400,
        child: Stack(
          children: [
            Container(
              child: Image.asset(
                "asset/images/result_bg.jpg",
                fit: BoxFit.fitWidth,
              ),
            ),
            Positioned(
              top: 12,
              left: 12,
              child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Score",
                        style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        score + "/10",
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 16,
                        ),
                      ),
                    ]),
              ),
            ),
            Positioned(
              right: 12,
              bottom: 12,
              child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        name ?? "",
                        style: TextStyle(
                            color: Colors.yellow,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        dt,
                        style: TextStyle(
                          color: Colors.yellow,
                          fontSize: 14,
                        ),
                      ),
                    ]),
              ),
            ),
            Positioned(
              right: 12,
              top: 12,
              child: Container(
                // margin: const EdgeInsets.only(bottom: 1.0),
                width: 46.0,
                height: 46.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Color(0xE5ffd700), width: 3),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xA5ffd700), //color of shadow
                      spreadRadius: 8, //spread radius
                      blurRadius: 7, // blur radius
                      offset: Offset(0, 0), // changes position of shadow
                    ),
                  ],
                  image: new DecorationImage(
                    fit: BoxFit.fill,
                    image: new NetworkImage(
                      "https://3.6.153.237/Comp_Api/uploads/$image",
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              right: 100,
              top: 18,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.zero,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            winningPrice + " ₹",
                            style: TextStyle(
                                fontSize: 50,
                                color: Color(0xffFFD700),
                                fontWeight: FontWeight.w600,
                                letterSpacing: .4),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 24,
                      ),
                    ]),
              ),
            )
          ],
        ),
      );
    }

    Widget screenShotWidget = Screenshot(
      controller: screenshotController,
      child: Container(
        child: insideScreenShotWidget(.8),
        color: Colors.white,
      ),
    );

    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          insideScreenShotWidget(.25),
          SizedBox(
            width: double.maxFinite,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, bottom: 14, top: 10),
              child: ElevatedButton(
                  onPressed: () async {
                    try {
                      Uint8List imageUintList = await screenshotController
                          .captureFromWidget(screenShotWidget);

                      if (imageUintList != null) {
                        String fileName = "question_king" +
                            DateTime.now().microsecondsSinceEpoch.toString();

                        final directory =
                            await getApplicationDocumentsDirectory();
                        String directoryPath =
                            p.join(directory.path, (fileName + ".png"));
                        final imagePath = await File(directoryPath).create();
                        File _file =
                            await imagePath.writeAsBytes(imageUintList);

                        await Share.shareFiles(
                          [_file.path],
                          subject: 'Exam Score Card',
                          text:
                              'https://play.google.com/store/apps/details?id=com.QuestionKing',
                        );
                      }
                    } catch (e) {
                      print("ERROR :- " + e.toString());
                    }
                  },
                  child: Text("SHARE")),
            ),
          )
        ],
      ),
    );
  }
}
