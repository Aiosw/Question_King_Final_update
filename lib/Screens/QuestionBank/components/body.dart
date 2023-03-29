import 'dart:convert';
import 'dart:math';
import 'package:competitive_exam_app/Model/ExamMdl.dart';
import 'package:competitive_exam_app/Service/ExamService.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:competitive_exam_app/components/loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:competitive_exam_app/Screens/Dashboard/components/background.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:path/path.dart';

class Body extends StatefulWidget {
  _Body createState() => _Body();
  Body({Key key}) : super(key: key);
}

retnull() {
  return Container();
}

class _Body extends State<Body> with SingleTickerProviderStateMixin {
  var color1 = kPrimaryColor;
  var color2 = const Color(0xFFdd7c24);
  var color3 = const Color.fromARGB(255, 255, 218, 175);
  DateTime date = new DateTime.now();
  DateTime selectDates;
  bool value = false;
  String selectDate;
  List<ExamModel> profLst;
  bool isloading = true;
  List qAData;
  int sessionNo = 1;

  Future<List<ExamModel>> getQuestionData() async {
    String language = Constants.prefs.getString('langCd');
    var st = DateTime.now();
    if (selectDate == null) {
      selectDates = st;
      var st11 = st.add(Duration(days: -1));
      var dts = st11.toString().split(" ");
      String st1 = dts[0].toString();
      var dts1 = st1.split("-");
      selectDate = dts1[2] + '/' + dts1[1] + '/' + dts1[0];
      if (language != null) {
        ExamModel prof = ExamModel(
            sessionNo: sessionNo.toString(),
            Date: selectDate,
            langCd: language);
        if (prof != null) {
          var data = await Examservice().getAnsQuestion(prof);
          if (data != null) {
            // print("$data");
            var qAns = json.decode(data);
            setState(() {
              qAData = qAns;
              isloading = false;
            });
          }
        }
      }
    } else {
      if (selectDates.isBefore(st)) {
        var dts = st.toString().split(" ");
        DateTime st1 = DateTime.parse(dts[0]);
        if (selectDates.compareTo(st1) == 0) {
          toastFaill('Selected Date is now date Please select Before Date');
        } else {
          if (language != null) {
            ExamModel prof = ExamModel(
                sessionNo: sessionNo.toString(),
                Date: selectDate,
                langCd: language);
            if (prof != null) {
              var data = await Examservice().getAnsQuestion(prof);
              if (data != null) {
                // print("$data");
                var qAns = json.decode(data);
                setState(() {
                  qAData = qAns;
                  isloading = false;
                });
              }
            }
          }
        }
      } else {
        toastFaill('Selected Date not Upload Question');
      }
    }
    return [];
  }

  toastPass(String messge) {
    Fluttertoast.showToast(
        msg: messge,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: kPrimaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  toastFaill(String messge) {
    Fluttertoast.showToast(
        msg: messge,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: kPrimaryColor,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  void initState() {
    super.initState();
    getQuestionData();
    //isloading = false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (Buildcontext, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverAppBar(
              backgroundColor: kPrimaryColor,
              title: Text('Question Bank'),
              flexibleSpace: Container(),
              pinned: true,
              floating: true,
              snap: true,
              bottom: PreferredSize(
                  child: Container(
                    height: 055,
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Row(
                        children: [
                          InkWell(
                              child: Container(
                                margin: const EdgeInsets.all(04),
                                child: Image.asset(
                                  "asset/Prev.png",
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                              onTap: () {
                                if (sessionNo == 1) {
                                  toastFaill(
                                      "No More Question Available in this Date");
                                } else {
                                  setState(() {
                                    sessionNo = sessionNo - 1;
                                  });
                                  getQuestionData();
                                }
                              }),
                          const Spacer(),
                          Text(
                            'No:$sessionNo',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 20),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Colors.black,
                            ),
                            child: selectDate == null
                                ? Text("Select Date")
                                : Text('Select Date: $selectDate'),
                            onPressed: () async {
                              selectDates = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime(2023),
                                lastDate: DateTime(2030),
                                currentDate: DateTime.now(),
                              );
                              setState(() {
                                var st = selectDates.toString().split(" ");
                                var st1 = st[0].toString();
                                var dts1 = st1.split("-");
                                selectDate =
                                    dts1[2] + '/' + dts1[1] + '/' + dts1[0];
                                // selectDates;
                              });
                              if (selectDates != null) {
                                getQuestionData();
                              }
                            },
                          ),
                          const Spacer(),
                          InkWell(
                              child: Container(
                                margin: const EdgeInsets.all(04),
                                child: Image.asset(
                                  "asset/Next.png",
                                  height: 50,
                                  width: 50,
                                ),
                              ),
                              onTap: () {
                                if (sessionNo == 5) {
                                  toastFaill(
                                      "No More Question Available in this Date");
                                } else {
                                  setState(() {
                                    sessionNo = sessionNo + 1;
                                  });
                                  getQuestionData();
                                }
                              }),
                        ],
                      ),
                    ),
                  ),
                  preferredSize: Size.fromHeight(0055.055))),
        ];
      },
      body: Scrollbar(
        isAlwaysShown: false,
        // thickness: 20,
        child: Background(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: qAData == null ? 0 : qAData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(10, 0, 5, 0),
                          height: MediaQuery.of(context).size.height / 8.0,
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 5, 0),
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
        ),
      ),
    ));
  }
}
