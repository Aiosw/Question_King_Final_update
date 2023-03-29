import 'package:flutter/material.dart';
import 'package:competitive_exam_app/Screens/Login/login_screen.dart';
import 'package:competitive_exam_app/Screens/Signup/signup_screen.dart';
import 'package:competitive_exam_app/Screens/Dashboard/components/backgroundHt.dart';
import 'package:competitive_exam_app/components/rounded_button.dart';


class Body extends StatefulWidget {
  @override
  _Body createState() => _Body();
}
 var color1 = Color.fromARGB(255, 154, 127, 163);
  var color2 = Color.fromARGB(255, 170, 168, 166);
  var color3 = Color.fromARGB(255, 59, 45, 29);
  
class _Body extends State<Body> {
 
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Scaffold(
      body:Container(
        decoration: BoxDecoration(
           gradient: LinearGradient(
              colors: [
                color1,
                color2,
              ],
              begin: const FractionalOffset(0.1, 0.1),
              end: const FractionalOffset(1.0, 0.5),
              stops: [0.2, 1.0],
              tileMode: TileMode.clamp),
        ),
        child:Background(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "WELCOME TO QUESTION KING APP",
                  style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,)
                ),
                SizedBox(height: size.height * 0.05),
               Image.asset(
                    "asset/12333.gif",
                    height: size.height * 0.35,
                  ),
                SizedBox(height: size.height * 0.05),
                RoundedButton(
                  text: "LOGIN",
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
                RoundedButton(
                  text: "SIGN UP",
                  //color: kPrimaryLightColor,
                  textColor: Colors.white,
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
