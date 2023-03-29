import 'dart:io';
import 'package:competitive_exam_app/Model/ProfileMdl.dart';
import 'package:competitive_exam_app/Screens/Dashboard/components/backgroundHt.dart';
import 'package:competitive_exam_app/Screens/Profile/User_Model.dart';
import 'package:competitive_exam_app/Service/ProfileAddService.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:competitive_exam_app/components/Apiloader.dart';
import 'package:competitive_exam_app/components/loader.dart';
import 'package:competitive_exam_app/components/rounded_button.dart';
import 'package:competitive_exam_app/components/rounded_input_field.dart';
import 'package:dio/dio.dart';
import 'package:path/path.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Body extends StatefulWidget {
  _Body createState() => _Body();
  Body({Key key}) : super(key: key);
}

retnull() {
  return Container();
}

class _Body extends State<Body> {
  final _formKey = GlobalKey<FormState>();
  String bcode, BankName, AcName, AcNo, IFFCNo, userCd;

  TextEditingController bankName = TextEditingController();
  TextEditingController acName = TextEditingController();
  TextEditingController acNo = TextEditingController();
  TextEditingController iFFCNo = TextEditingController();

  List<ProfileModel> profLst;
  bool isloading = true;

  Future<List<ProfileModel>> getOldProfileData() async {
    userCd = Constants.prefs.getString('logId');
    print("$userCd");
    ProfileModel prof = ProfileModel(userCd: userCd);
    if (userCd != null) {
      profLst = await Profileservice().proGet(prof);
      setState(() {
        isloading = false;
      });
      print("$profLst.length");
      if (profLst != null) {
        ProfileModel profMdl = profLst[0];
        setState(() {
          bankName.text = profMdl.bankNm;
          acName.text = profMdl.acNm;
          acNo.text = profMdl.acNo;
          iFFCNo.text = profMdl.iffcCd;
          bcode = profMdl.code;
        });
      }
    } else {
      isloading = false;
    }

    return [];
  }

  add(ProfileModel profileMdl, BuildContext context) async {
    isloading = true;
    await Profileservice().BnkUpdate(profileMdl).then((sucess) {
      setState(() {
        Navigator.pop(context);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getOldProfileData();
    //isloading = false;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: <Widget>[
        Form(
          key: _formKey,
          child: isloading
              ? loaders().apiLoader
              : SingleChildScrollView(
                  child: Background(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(height: size.height * 0.001),
                            RoundedInputField(
                              controllers: bankName,
                              maxleng: 45,
                              hintText: "Bank Full Name",
                              icon: Icons.comment_bank,
                              onChanged: (value) {
                                BankName = value;
                              },
                              validator: (String value) {
                                return value.isEmpty
                                    ? 'Enter Your Bank Full Name'
                                    : null;
                              },
                            ),
                            // SizedBox(height: size.height * 0.001),
                            RoundedInputField(
                              controllers: acName,
                              maxleng: 30,
                              hintText: "Account Name",
                              icon: Icons.person,
                              onChanged: (value) {
                                AcName = value;
                              },
                              validator: (String value) {
                                return value.isEmpty
                                    ? 'Enter Your Account Name'
                                    : null;
                              },
                            ),
                            RoundedInputField(
                              controllers: acNo,
                              maxleng: 25,
                              hintText: "Account No",
                              icon: Icons.ad_units,
                              onChanged: (value) {
                                AcNo = value;
                              },
                              validator: (String value) {
                                return value.isEmpty
                                    ? 'Enter Your A/c No'
                                    : null;
                              },
                            ),
                            RoundedInputField(
                              controllers: iFFCNo,
                              maxleng: 10,
                              hintText: "IFFC Code",
                              icon: Icons.mobile_screen_share,
                              onChanged: (value) {
                                IFFCNo = value;
                              },
                              validator: (String value) {
                                return value.isEmpty
                                    ? 'Enter Your IFFC Code'
                                    : null;
                              },
                            ),
                            SizedBox(height: size.height * 0.001),
                            RoundedButton(
                                text: "Submit",
                                press: () {
                                  if (_formKey.currentState.validate()) {
                                    ProfileModel pfm = new ProfileModel(
                                      userCd:
                                          Constants.prefs.getString('logId'),
                                      bankNm: bankName.text,
                                      iffcCd: iFFCNo.text,
                                      acNm: acName.text,
                                      acNo: acNo.text,
                                    );
                                    showLoaderDialog(context);
                                    add(pfm, context);
                                  }
                                }),
                          ]),
                    ),
                  ),
                ),
        ),
      ]),
    );
  }
}
