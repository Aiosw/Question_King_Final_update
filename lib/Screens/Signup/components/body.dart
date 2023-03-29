import 'dart:convert';
import 'package:competitive_exam_app/Screens/Login/login_screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:competitive_exam_app/Model/LoginModel.dart';
import 'package:competitive_exam_app/Service/LoginService.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:competitive_exam_app/components/already_have_an_account_acheck.dart';
import 'package:competitive_exam_app/components/rounded_button.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'or_divider.dart';

class Body extends StatefulWidget {
  const Body({Key key}) : super(key: key);

  @override
  _Body createState() => _Body();
}

@override
retnull() {
  return Container();
}

class _Body extends State<Body> {
  final TextEditingController controller = new TextEditingController();
  bool _isLoggedIn = false, isloading = false;
//  GoogleSignInAccount _userObj;
  // GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount _currentUser;
  String _contactText = '';
  String userName, password, fname, email, request;
  bool obsecure = true;
  Icon icon = Icon(Icons.visibility_off);

  var color1 = Colors.orange;
  var color2 = kPrimaryColor;

  final _formKey = GlobalKey<FormState>();
  GoogleSignIn _googleSignIn = GoogleSignIn(
    // Optional clientId
    // clientId: '479882132969-9i9aqik3jfjd7qhci1nqf0bm2g71rm1u.apps.googleusercontent.com',
    scopes: <String>['email'],
  );

  add(LoginModel loginMdl, BuildContext context, bool fromGoogle) async {
    isloading = true;

    print("result : " + "do add");

    String result = await Loginservice().logAdd(loginMdl);

    print(" THIS IS result : " + result.toString());
    if (result.toString() == "Sucess" || result.toString() == "Exist") {
      // request = "Add Sucessfully";

      // if (request == "Add Sucessfully") {
      // if (fromGoogle) {
      setState(() {
        Navigator.pushReplacementNamed(context, "/Sliders");
      });

      // }
      // Navigator.pushNamed(context, "/LoginScreen");
      // }
    } else {
      toastMasg(result.toString());
      _googleSignIn.signOut();
    }
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

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleGetContact(GoogleSignInAccount user) async {
    setState(() {
      _contactText = 'Loading contact info...';
    });
    final http.Response response = await http.get(
      Uri.parse('https://people.googleapis.com/v1/people/me/connections'
          '?requestMask.includeField=person.names'),
      headers: await user.authHeaders,
    );
    if (response.statusCode != 200) {
      setState(() {
        _contactText = 'People API gave a ${response.statusCode} '
            'response. Check logs for details.';
      });
      print('People API ${response.statusCode} response: ${response.body}');
      return;
    }
    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;
    final String namedContact = _pickFirstNamedContact(data);
    setState(() {
      if (namedContact != null) {
        _contactText = 'I see you know $namedContact!';
      } else {
        _contactText = 'No contacts to display.';
      }
    });
  }

  Future<void> _handleSignOut() => _googleSignIn.signOut();

  String _pickFirstNamedContact(Map<String, dynamic> data) {
    final List<dynamic> connections = data['connections'] as List<dynamic>;
    final Map<String, dynamic> contact = connections?.firstWhere(
      (dynamic contact) => contact['names'] != null,
      orElse: () => null,
    ) as Map<String, dynamic>;
    if (contact != null) {
      final Map<String, dynamic> name = contact['names'].firstWhere(
        (dynamic name) => name['displayName'] != null,
        orElse: () => null,
      ) as Map<String, dynamic>;
      if (name != null) {
        return name['displayName'] as String;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Container(
          height: double.maxFinite,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [color1, color2],
                begin: const FractionalOffset(0.1, 0.1),
                end: const FractionalOffset(1.0, 0.5),
                stops: [0.2, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  // SizedBox(
                  //   height: 400,
                  // ),
                  SizedBox(height: size.height * 0.06),
                  Text(
                    "SIGNUP",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: size.height * 0.03),
                  Image.asset(
                    "asset/12333.gif",
                    height: size.height * 0.35,
                  ),
                  SizedBox(height: size.height * 0.03),
                  Padding(
                    padding: EdgeInsets.only(right: 20, left: 20),
                    child: TextFormField(
                      cursorColor: kPrimaryColor,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.email,
                          color: kPrimaryColor,
                        ),
                        filled: true,
                        fillColor: kPrimaryLightColor,
                        border: UnderlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryLightColor),
                            borderRadius: BorderRadius.circular(29)),
                        hintText: "Email",
                      ),
                      onChanged: (value) {
                        userName = value;
                      },
                      validator: (String value) {
                        final bool isValid = EmailValidator.validate(value);
                        return value.isEmpty
                            ? 'Enter User Name'
                            : isValid
                                ? null
                                : 'Please Enter Proper Email Id';

                        //  print('Email is valid? ' + (isValid ? 'yes' : 'no'));
                      },
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 20, left: 20),
                    child: TextFormField(
                      obscureText: obsecure,
                      controller: controller,
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
                  new SizedBox(
                    height: 3,
                  ),
                  new FlutterPwValidator(
                    controller: controller,
                    minLength: 8,
                    uppercaseCharCount: 1,
                    width: 400,
                    height: 60,
                    onSuccess: () {
                      print("MATCHED");
                      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                          content: new Text("Password is matched")));
                    },
                    onFail: () {
                      print("NOT MATCHED");
                    },
                  ),
                  RoundedButton(
                    text: "SIGNUP",
                    press: () {
                      if (_formKey.currentState.validate()) {
                        LoginModel log = LoginModel(
                          userName: userName,
                          password: password,
                        );
                        add(log, context, false);
                      }
                    },
                  ),
                  //  SizedBox(height: size.height * 0.03),
                  AlreadyHaveAnAccountCheck(
                    login: false,
                    press: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return LoginScreen();
                          },
                        ),
                      );
                    },
                  ),
                  OrDivider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () async {
                          try {
                            GoogleSignInAccount _googleSignInAccount =
                                await _googleSignIn.signIn();

                            if (_googleSignInAccount != null) {
                              String email =
                                  _googleSignInAccount.email.toString();
                              String password =
                                  _googleSignInAccount.id.toString();

                              print("user data :- " + email);
                              print("user data :- " + password);

                              LoginModel log = LoginModel(
                                userName: email,
                                password: password,
                              );
                              add(log, context, true);
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
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
