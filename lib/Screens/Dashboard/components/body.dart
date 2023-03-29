import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:competitive_exam_app/Model/ExamMdl.dart';
import 'package:competitive_exam_app/Model/LedgerModel.dart';
import 'package:competitive_exam_app/Model/ProfileMdl.dart';
import 'package:competitive_exam_app/Screens/Dashboard/components/background.dart';
import 'package:competitive_exam_app/Service/ExamService.dart';
import 'package:competitive_exam_app/Service/PaymentService.dart';
import 'package:competitive_exam_app/Service/ProfileAddService.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:competitive_exam_app/components/loader.dart';
import 'package:competitive_exam_app/components/rounded_button.dart';
import 'package:competitive_exam_app/interceptor/dio_connectivity_request_retrier.dart';
import 'package:competitive_exam_app/interceptor/retry_interceptor.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';

class Body extends StatefulWidget {
  _Body createState() => _Body();

  Body({Key key}) : super(key: key);
}

String bdcategory, subCategory;

@override
retnull() {
  return Container();
}

class _Body extends State<Body> with SingleTickerProviderStateMixin {
  Dio dio;
  DateTime dt15;
  bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  int touchedIndex;
  final Duration updateDuration = const Duration(seconds: 1);
  DateTime currentTime;
  int colS1 = 0;
  int colS2 = 0;
  int colS3 = 0;
  int colS4 = 0;
  int colS5 = 0;
  Timer _timer;
  List ledList;
  List qAData;
  DateTime dt;
  double all;
  List<ProfileModel> Pflst;
  String bal, tym, sessionno, cdt;
  double participate;
  List<LedgerModel> LedgerLst;
  List<ExamModel> winnerLst;
  List parti;
  int time;
  double nonparticipate;

  Future<Double> getParticipate() async {
    // isloading=true;
    tym = new DateTime.now().hour.toString();
    time = new DateTime.now().hour;
    sessionno = time > 9 && time < 12
        ? "1"
        : time > 12 && time < 15
            ? "2"
            : time > 15 && time < 18
                ? "3"
                : time > 18 && time < 21
                    ? "4"
                    : time > 21 && time < 24
                        ? "5"
                        : "5";
    DateTime date = DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy');
    cdt = formatter.format(date);
    ExamModel exmdl = ExamModel(sessionNo: sessionno, Date: cdt);
    final data = await Examservice().getParticipate(exmdl);
    if (data != '"No Record Found"') {
      parti = json.decode(data);
      setState(() {
        participate = double.parse(parti[0]['Rst']);
        all = double.parse(parti[0]['sesNo']);
        nonparticipate = all - participate;
      });
    }
  }

  Future<Double> getCurrentBal() async {
    String loginCd = Constants.prefs.getString('logId');
    if (loginCd != null) {
      LedgerModel ledMdl = LedgerModel(userCd: loginCd);
      print(ledMdl.userCd);
      LedgerLst = await PaymentService().getLedgerBal(ledMdl);
      if (LedgerLst != null) {
        LedgerModel ledMdl = LedgerLst[0];
        print("$LedgerLst");
        setState(() {
          bal = ledMdl.val == null ? "0" : ledMdl.val;
        });
      }
    }
  }

  Future<String> getWinnerData() async {
    // isloading=true;
    ExamModel exmdl = ExamModel(sessionNo: sessionno, Date: cdt);
    final data = await Examservice().getTop3Result(exmdl);
    if (data != '"No Record Found"') {
      isloading = false;
      print("$data");
      setState(() {
        var datas = json.decode(data);
        ledList = datas;
      });
    }
  }

  Future<String> quesAns() async {
    String language = Constants.prefs.getString('langCd');
    if (language != null) {
      ExamModel exm =
          ExamModel(sessionNo: sessionno, Date: cdt, langCd: language);

      if (sessionno != null) {
        var data = await Examservice().getAnsQuestion(exm);
        if (data != null) {
          print("$data");
          var qAns = json.decode(data);
          setState(() {
            qAData = qAns;
            isloading = false;
          });
        }
      }
    } else {
      String userCd = Constants.prefs.getString('logId');
      if (userCd != null) {
        ProfileModel pfMdl = ProfileModel(userCd: userCd);
        Pflst = await Profileservice().proGet(pfMdl);
        if (Pflst != null) {
          ProfileModel profMdl = Pflst[0];
          language = profMdl.langCd;
          if (language != null) {
            ExamModel exm =
                ExamModel(sessionNo: sessionno, Date: cdt, langCd: language);
            if (sessionno != null) {
              var data = await Examservice().getAnsQuestion(exm);
              if (data != null) {
                var qAns = json.decode(data);
                setState(() {
                  qAData = qAns;
                  isloading = false;
                });
              }
            }
          }
        }
      }
    }
  }

  @override
  initState() {
    super.initState();
    isloading = true;
    getCurrentBal();
    getParticipate();
    getWinnerData();
    quesAns();
    setState(() {
      currentTime = new DateTime.now();
      this._timer = new Timer.periodic(updateDuration, setTime);

      dt = new DateTime.now();
      this._timer = new Timer.periodic(updateDuration, setTime);
      controller = TabController(length: 3, vsync: this);
    });
    dio = Dio();
    dio.interceptors.add(
      RetryOnConnectionChangeInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
          dio: dio,
          connectivity: Connectivity(),
        ),
      ),
    );
  }

  void setTime(Timer timer) {
    setState(() {
      currentTime = new DateTime.now();
      dt = new DateTime.now();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  var color1 = kPrimaryColor;
  var color2 = const Color(0xFFdd7c24);
  var color3 = const Color.fromARGB(255, 255, 218, 175);

  final colorList = <Color>[
    Color.fromARGB(255, 189, 79, 16),
    Color.fromARGB(255, 255, 218, 175),
    Color.fromARGB(255, 216, 62, 116),
    Color.fromARGB(255, 190, 94, 69),
    Color.fromARGB(255, 61, 52, 128),
  ];

  // List<int> listOfTime =

  @override
  buildCounter() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
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
          borderRadius: BorderRadius.circular(29),
        ),
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: TimerCountdown(
            format: CountDownTimerFormat.hoursMinutesSeconds,
            endTime: getNextIntervalTime(),
            onEnd: () {
              print("Timer finished");
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
      ),
    );
  }

  DateTime getNextIntervalTime() {
    DateTime timeOf9 = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 9, 0, 0, 0, 0);
    DateTime timeOf12 = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 12, 0, 0, 0, 0);
    DateTime timeOf15 = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 15, 0, 0, 0, 0);
    DateTime timeOf18 = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 18, 0, 0, 0, 0);
    DateTime timeOf21 = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 21, 0, 0, 0, 0);
    DateTime timeOf24 = DateTime(
        currentTime.year, currentTime.month, currentTime.day, 24, 0, 0, 0, 0);

    List<DateTime> listOfExamTime = [
      timeOf9,
      timeOf12,
      timeOf15,
      timeOf18,
      timeOf21,
      timeOf24,
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

  buildChart(BuildContext context) {
    final dataMap = <String, double>{
      "Participants": participate == null ? 1 : participate,
      "Non Participants": nonparticipate == null ? 1 : nonparticipate,
    };
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
      child: PieChart(
        dataMap: dataMap,
        animationDuration: const Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 2,
        colorList: colorList,
        initialAngleInDegree: 0,
        chartType: ChartType.disc,
        legendOptions: const LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
          legendShape: BoxShape.rectangle,
          legendTextStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: false,
          showChartValues: true,
          showChartValuesInPercentage: false,
          showChartValuesOutside: false,
          decimalPlaces: 0,
        ),
      ),
    );
  }

  @override
  buildButton(BuildContext context) {
    return RoundedButton(
      color: Colors.green,
      press: () {
        Navigator.pushNamed(context, '/Exam');
        getCurrentBal();
      },
      text: ' Start Exam At 1₹',
    );
  }

  @override
  buildRefButton() {
    return RoundedButton(
      press: () {
        getCurrentBal();
        getParticipate();
        getWinnerData();
        quesAns();
      },
      text: 'Refresh',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isloading == true
          ? loaders().apiLoader
          : Background(
              child:
                  //Container(),
                  Column(children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        child: Container(
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
                                left: Radius.circular(20),
                                right: Radius.circular(0)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              "₹ $bal",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                        onTap: () {
                          Navigator.pushNamed(context, '/wallet');
                        },
                      ),
                    ],
                  ),
                ),
                buildCounter(),
                dt.hour == 9 &&
                        dt.minute == 0 &&
                        (dt.second > 0 && dt.second < 15)
                    ? buildButton(context)
                    : dt.hour == 12 &&
                            dt.minute == 0 &&
                            (currentTime.second > 0 && currentTime.second < 15)
                        ? buildButton(context)
                        : dt.hour == 15 &&
                                dt.minute == 0 &&
                                (dt.second > 0 && dt.second < 15)
                            ? buildButton(context)
                            : dt.hour == 18 &&
                                    dt.minute == 0 &&
                                    (dt.second > 0 && dt.second < 15)
                                ? buildButton(context)
                                : dt.hour == 21 &&
                                        dt.minute == 0 &&
                                        (dt.second > 0 && dt.second < 15)
                                    ? buildButton(context)
                                    : buildRefButton(),
                // : buildButton(context),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: TabBar(
                      indicatorColor: kPrimaryLightColor,
                      unselectedLabelColor: Colors.white,
                      labelColor: Colors.amber[300],
                      controller: controller,
                      tabs: const [
                        Tab(
                          child: Text('Chart'),
                        ),
                        Tab(
                          child: Text('Winner'),
                        ),
                        Tab(
                          child: Text('AnswerKey'),
                        )
                      ]),
                ),
                Expanded(
                  child: TabBarView(
                    controller: controller,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          buildChart(context),
                        ],
                      ),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: ledList == null ? 0 : ledList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01,
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        0.1,
                                    width: MediaQuery.of(context).size.width *
                                        0.18,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 1.5,
                                        ),
                                        color: color3,
                                        image: new DecorationImage(
                                            image: new NetworkImage(
                                                "https://3.6.153.237/Comp_Api/uploads/${ledList[index]['NotAttend']}"),
                                            fit: BoxFit.cover)),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        ledList[index]['obtainMark'],
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                45,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01),
                                      Text(
                                        '₹  ${ledList[index]['Rst']}',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .height /
                                                50,
                                            fontWeight: FontWeight.w900),
                                      ),
                                    ],
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    color: Colors.white,
                                    size:
                                        MediaQuery.of(context).size.width / 20,
                                  ),
                                ],
                              ),
                            );
                          }),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: qAData == null ? 0 : qAData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                                height:
                                    MediaQuery.of(context).size.height / 8.0,
                                width: MediaQuery.of(context).size.width / 2.5,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(color: color1, blurRadius: 10)
                                    ],
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                        colors: [color2, color1],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight)),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(0, 5, 5, 0),
                                      child: Row(children: [
                                        Expanded(
                                          child: Text(
                                            'Q.${qAData[index]['Que'].toString().trim()}',
                                            textAlign: TextAlign.justify,
                                            overflow: TextOverflow.fade,
                                            style: TextStyle(
                                                color: kPrimaryLightColor,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    45,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ]),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Ans.${qAData[index]['Ans'].toString().trim()}',
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: kPrimaryLightColor,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .height /
                                                    45,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              ]),
            ),
    );
  }

  TabController controller;
}
