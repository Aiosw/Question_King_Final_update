import 'dart:math';
import 'package:competitive_exam_app/Model/ProfileMdl.dart';
import 'package:competitive_exam_app/Screens/Dashboard/components/backgroundHt.dart';
import 'package:competitive_exam_app/Service/ProfileAddService.dart';
import 'package:competitive_exam_app/components/Apiloader.dart';
import 'package:flutter/material.dart';
import 'package:competitive_exam_app/Model/LoginModel.dart';
import 'package:competitive_exam_app/Screens/Signup/signup_screen.dart';
import 'package:competitive_exam_app/Service/LoginService.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:competitive_exam_app/components/already_have_an_account_acheck.dart';
import 'package:competitive_exam_app/components/rounded_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class Body extends StatefulWidget {
  Body({Key key}) : super(key: key);
  @override
  _Body createState() => _Body();
}

toastMasg(String Msg) {
  Fluttertoast.showToast(
      msg: "$Msg",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: kPrimaryColor,
      textColor: Colors.white,
      fontSize: 16.0);
}

class _Body extends State<Body> {
  static String userName, password;
  bool obsecure = true;
  bool isloading;
  List<LoginModel> loginlst;
  List<ProfileModel> Pflst;
  List<LoginModel> logLst;
  String logId, Email, fromEmail, pass, bodymessage, usrCd;
  int randomNumber;

  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
    scopes: <String>['email'],
  );

  add(LoginModel loginModel, BuildContext context) async {
    // await Loginservice().logincheck(loginModel).then((sucess) {

    loginlst = await Loginservice().logincheck(loginModel);
    // print("gf sdG: 12 " + loginlst[0].fName.toString());

    setState(() {
      print("loginlst[0].login :: " + loginlst[0].toString());
      if (loginlst[0].login == "0") {
        toastMasg("Login Failed!");
        _googleSignIn.signOut();
        Constants.prefs.setBool("loggedIn", false);
        Navigator.pop(context);
      } else {
        toastMasg("Login Successfull...");
        Constants.prefs.setBool("loggedIn", true);
        Constants.prefs.setString('logId', loginlst[0].logId);

        getProfile(loginlst[0].logId);
        Navigator.pop(context);
      }
    });
  }

  Future sendMail() async {
    Random random = new Random();
    randomNumber = random.nextInt(10000);
    // showLoaderDialog(context);
    // fromEmail = "questionking.pass01@gmail.com";
    // pass = "Als@372200";
    // String username = fromEmail.trim();
    // String password = pass.trim();

    // final smtpServer = gmail(username, password);

    // final message = Message()
    //   ..from = Address(username)
    //   ..recipients.add(Email)
    //   ..subject = 'Quetion King App Reset Password'
    //   //..text = 'Please use this New Password to reset the password for the Question King Account.\n Here is your New Password: Qk@$randomNumber \n If you dont recognise the Quetion King account, you can click here to remove your email address from that account.\n Thanks.'
    //   ..html =
    //       "<h1>Here is your New Password: Qk@$randomNumber</h1>\n<p>Please use this New Password to reset the password for the Question King Account.\n If you dont recognise the Quetion King account, you can click here to remove your email address from that account.\n Thanks.</p>";

    // try {
    //   final sendReport = await send(message, smtpServer);
    //   // setState(() {
    //   //    Navigator.pop(context);
    //   // });

    FlutterToastr.show('Here is your New Password: Qk@$randomNumber', context,
        duration: FlutterToastr.lengthLong, position: FlutterToastr.center);
    //   print('Message sent: ' + sendReport.toString());
    // } on MailerException catch (e) {
    //   print('Message not sent.$e');
    //   toastMasg('$e');
    //   for (var p in e.problems) {
    //     print('Problem: ${p.code}: ${p.msg}');
    //   }
    // }
  }

  getProfile(String userCd) async {
    print("userCd : " + userCd.toString());
    ProfileModel pfMdl = await ProfileModel(userCd: userCd);
    print("pfMdl : - " + pfMdl.toString());
    Pflst = await Profileservice().proGet(pfMdl);
    print("Pflst --- " + Pflst.toString());
    // setState(() {
    if (Pflst != null) {
      print("Pflst ----------- : " + Pflst[0].f_Name.toString());

      Constants.prefs.setString('langCd', Pflst[0].langCd);
      Constants.prefs.setString('f_Name', Pflst[0].f_Name.toString());

      Navigator.pushNamedAndRemoveUntil(
        context,
        "/dashBoard",
        (Route<dynamic> route) => false,
      );
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context,
        "/Sliders",
        (Route<dynamic> route) => false,
      );
      // Navigator.pushReplacementNamed(context, "/Profile");
    }
    //  });
  }

  getProfiles(String userNm, BuildContext context) async {
    //
    LoginModel pfMdl = LoginModel(userName: userNm);

    logLst = await Loginservice().loginGet(pfMdl);
    // setState(() async {
    if (logLst != null) {
      showLoaderDialog(context);
      usrCd = logLst[0].logId;
      ProfileModel pfMdl = ProfileModel(userCd: usrCd);
      Pflst = await Profileservice().proGet(pfMdl);
      if (Pflst != null) {
        ProfileModel profMdl = Pflst[0];
        Email = profMdl.Email;
        sendMail();
        saveNewPassword(context);
        //  setState(() async {
        // Navigator.pop();
        // });
      }
    }
    //  });
    else {
      toastMasg('This userName Not store over Databse Please Try other!!!');
      // setState(() async {
      //   Navigator.pop(context);
      // });
    }
  }

  saveNewPassword(BuildContext context) async {
    LoginModel ldMdl = LoginModel(
        logId: usrCd, userName: userName, password: 'Qk@$randomNumber');
    String request = await Loginservice().logUpdate(ldMdl);
    if (request == "success") {
      setState(() {
        Navigator.pop(context);
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print("BUILLLDSF");

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: <Widget>[
        Form(
          key: _formKey,
          child: Background(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "LOGIN",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: size.height * 0.01),
                  Image.asset(
                    "asset/12333.gif",
                    height: size.height * 0.35,
                  ),
                  SizedBox(height: size.height * 0.01),
                  Container(
                    padding: EdgeInsets.only(right: 20, left: 20),
                    child: TextFormField(
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person,
                            color: kPrimaryColor,
                          ),
                          filled: true,
                          fillColor: kPrimaryLightColor,
                          border: UnderlineInputBorder(
                              borderSide: BorderSide(color: kPrimaryLightColor),
                              borderRadius: BorderRadius.circular(29)),
                          hintText: "username",
                          suffixIcon: Icon(
                            Icons.person,
                          )),
                      onChanged: (value) {
                        userName = value;
                      },
                      validator: (String value) {
                        return value.isEmpty ? 'Enter User Name' : null;
                      },
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // Container(
                  //   margin: EdgeInsets.symmetric(vertical: 10),
                  //   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 1),
                  //   child: RoundedInputField(
                  //     hintText: "userName",
                  //     icon: Icons.person,
                  //     onChanged: (value) {
                  //       userName = value;
                  //     },
                  //     validator: (String value) {
                  //       return value.isEmpty ? 'Enter Email' : null;
                  //     },
                  //   ),
                  // ),
                  Container(
                    padding: EdgeInsets.only(right: 20, left: 20),
                    child: TextFormField(
                      obscureText: obsecure,
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.lock,
                          color: kPrimaryColor,
                        ),
                        filled: true,
                        fillColor: kPrimaryLightColor,
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryLightColor),
                            borderRadius: BorderRadius.circular(29)),
                        hintText: "Password",
                        suffixIcon: IconButton(
                            icon: Icon(obsecure
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                obsecure = !obsecure;
                              });
                            }),
                      ),
                      onChanged: (value) {
                        password = value;
                      },
                      validator: (String value) {
                        return value.isEmpty ? 'Enter Password' : null;
                      },
                    ),
                  ),
                  SizedBox(height: size.height * 0.01),
                  RoundedButton(
                    text: "LOGIN",
                    press: () {
                      if (_formKey.currentState.validate()) {
                        LoginModel loginmodel =
                            LoginModel(userName: userName, password: password);
                        showLoaderDialog(context);
                        add(loginmodel, context);
                      }
                    },
                  ),
                  // RoundedButton(
                  //   text: "Slider",
                  //   press: () {
                  //     Navigator.pushReplacementNamed(context, "/Sliders");
                  //   },
                  // ),
                  SizedBox(height: size.height * 0.001),
                  TextButton(
                    onPressed: () {
                      //  logId = Constants.prefs.getString('logId');
                      userName == null
                          ? toastMasg("Please Enter userName!!")
                          : getProfiles(userName, context);

                      // Random random = new Random();
                      // int randomNumber = random.nextInt(100000);
                      // sendMail(randomNumber, context);
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  AlreadyHaveAnAccountCheck(
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return SignUpScreen();
                          },
                        ),
                      );
                    },
                  ),
                  // OrDivider(),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // SocalIcon(
                      //   iconSrc: "asset/icons/facebook.svg",
                      //   press: () async {
                      //     _checkIsLoggedIn();
                      //   },
                      // ),
                      // SocalIcon(
                      //   iconSrc: "asset/icons/twitter.svg",
                      //   press: () {

                      //     // _isLoggedIn?userName=_userObj.displayName,
                      //     //             email=_userObj.email,
                      //     //             fname=_userObj.photourl:

                      //   },
                      // ),

                      GestureDetector(
                        onTap: () async {
                          print("tapped");
                          try {
                            GoogleSignInAccount _googleSignInAccount =
                                await _googleSignIn.signIn();

                            if (_googleSignInAccount != null) {
                              String email =
                                  _googleSignInAccount.email.toString();
                              String password =
                                  _googleSignInAccount.id.toString();

                              LoginModel log = LoginModel(
                                userName: email,
                                password: password,
                              );

                              print("user email 12345:- " +
                                  log.userName.toString());

                              add(log, context);
                            }
                          } catch (e) {
                            print("error : " + e.toString());
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.white),
                          padding: EdgeInsets.all(8),
                          child: Container(
                              width: 48,
                              height: 48,
                              child:
                                  Image.asset("asset/icons/google_icon.png")),
                        ),
                      ),

                      // SocalIcon(
                      //   iconSrc: "asset/icons/google-plus.svg",
                      //   press: () async {
                      //     await _googleSignIn.signIn().then((userData) {
                      //       setState(() {
                      //         _isLoggedIn = true;
                      //         _handleSignIn();
                      //         print(email);
                      //       });
                      //     }).catchError((e) {
                      //       print(e);
                      //     });
                      //   },
                      // ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
