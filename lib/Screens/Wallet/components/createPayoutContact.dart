import 'package:competitive_exam_app/Screens/Dashboard/components/background.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../Model/ProfileMdl.dart';
import '../../../Service/PaymentService.dart';
import '../../../Service/ProfileAddService.dart';
import '../../../Utils/Constant.dart';

class PayoutContact extends StatefulWidget {
  const PayoutContact({Key key}) : super(key: key);

  @override
  State<PayoutContact> createState() => _PayoutContactState();
}

class _PayoutContactState extends State<PayoutContact> {
  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _phoneNumberController;
  String stateNm,
      rectype = "0",
      stateCd,
      FName,
      fileName,
      language,
      languageCd,
      setStatus,
      userCd,
      cities,
      request,
      imageNm,
      email,
      mobNo,
      profileCode,
      acHolderName,
      acNumber,
      ifsc;
  List<ProfileModel> profLst;
  bool isloading = false;
  ProfileModel profMdl;

  Future<List<ProfileModel>> getOldProfileData() async {
    setState(() {
      isloading = true;
    });
    userCd = Constants.prefs.getString('logId');
    ProfileModel prof = ProfileModel(userCd: userCd);
    if (userCd != null && userCd != '') {
      profLst = await Profileservice().proGet(prof);

      print("$profLst.length");
      if (profLst != null) {
        profMdl = profLst[0];
        _nameController.text = profMdl.f_Name;
        _emailController.text = profMdl.Email;
        _phoneNumberController.text = profMdl.contactNo;
        // setState(() {
        //   rectype = "1";
        //   flNm = profMdl.f_Name;
        //   _nameController.text = profMdl.f_Name;
        //   languageCd = profMdl.langCd;
        //   stateCd = profMdl.stateCd;
        //   stateNm = profMdl.stateNm;
        //   Email.text = profMdl.Email;
        //   MobNo.text = profMdl.contactNo;
        //   city.text = profMdl.city;
        //   imageNm = profMdl.imgCd == "" ? 'default.png' : profMdl.imgCd;
        //   profileCode = profMdl.code;
        //   if (languageCd == "0") {
        //     language = "Hindi";
        //   } else if (languageCd == "1") {
        //     language = "English";
        //   } else if (languageCd == "2") {
        //     language = "Gujarati";
        //   }
        // });
      }
    } else {}

    setState(() {
      isloading = false;
    });

    return [];
  }

  @override
  void initState() {
    super.initState();
    getOldProfileData();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneNumberController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
        color: Colors.white, fontSize: 16, fontWeight: FontWeight.w400);
    return Scaffold(
      body: SafeArea(
        child: Background(
          child: isloading
              ? Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                  ),
                )
              : Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        child: Text(
                          "Enter folowing details to create a contact id to send money :",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(height: 50),
                      Container(
                        child: Text(
                          "Enter name",
                          style: textStyle,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: TextField(
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Name",
                            enabled: true,
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        child: Text(
                          "Enter email",
                          style: textStyle,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: TextField(
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "email",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        child: Text(
                          "Enter phone number",
                          style: textStyle,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 13),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        child: TextField(
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                          controller: _phoneNumberController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "phone number",
                            hintStyle: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () async {
                          if (_nameController.text.isNotEmpty &&
                              _emailController.text.isNotEmpty &&
                              _phoneNumberController.text.isNotEmpty) {
                            if (_phoneNumberController.text.length < 10) {
                              Fluttertoast.showToast(
                                  msg: "Please enter right phone number",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: kPrimaryColor,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            } else {
                              PaymentService().createPayoutAccount(
                                _nameController.text,
                                _emailController.text,
                                _phoneNumberController.text,
                              );
                              Fluttertoast.showToast(
                                  msg: "Your contact id is being created.",
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: kPrimaryColor,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                              Navigator.pushNamed(context, '/wallet');
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please provide all details",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: kPrimaryColor,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        child: Container(
                          alignment: Alignment.center,
                          color: Colors.white,
                          width: double.infinity,
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 10),
                          child: Text('Submit'),
                        ),
                      )
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
