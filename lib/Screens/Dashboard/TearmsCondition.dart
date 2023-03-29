import 'package:competitive_exam_app/Screens/Dashboard/components/background.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:flutter/material.dart';

class TearmsCondition extends StatefulWidget {
  TearmsCondition({Key key}) : super(key: key);

  @override
  _TearmsCondition createState() => _TearmsCondition();
}

class _TearmsCondition extends State<TearmsCondition> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Tearms and Condition"),
           backgroundColor: kPrimaryColor,
        foregroundColor: kPrimaryLightColor,
        ),
        body: Container(
          child: ListView(
            children: [
              Container(
                child: demoCard(
                  selectedcolor: Colors.white,
                  body: "\n 1.Now that you’ve Installed the app you’re already halfway to playing your first round of Question king – Congratulations !"
                      +"\n\n 2.Question king is Always Live so It’s Important to Keep the push notification activated so that you won’t miss any round.Each round consist of 10 Questions.you move forward by giving answers.An Incoreect answer can creat trouble for your score.if you answer all 10 question correctly or  other participant also score same. Questin King  will rendomly select 1st,2nd and 3rd winners and pot will Distribut among them"
                      +"\n\n 3.The app,or the contestin app,is sponsored,endorsed or any way affiliated with Question king Only.All Content in Question king and Related domains (collectively,the app or site)are covered by these rules. The app is open to anyone who is at least 18+year old as the date of entry.it is your responsibility to comply with the contest laws of your jurisdictions.Question king is Offered to you for your personal and non-personal use only.commerial use of Question king is strictly prohibited."
                      +"\n\n 4.We reserve the sole right to either modify or discountiue the game.including any of the site’s features,at any  time with or without notice to you.We will not be liable to you or any third party should we ecercise such right.any new features that augment or enhance the then-current sevices on this site shall also be subject to these terms of use."
                      +"\n\n 5.By registering you agree that all information provided is true and accurate and that  you will maintain and update this information as required in order to keep it current,complete and accurate."
                      +"\n\n 6.you must not use Question king for any unlawful purposes."
                      +"\n\n 7.ALL MATERIALS AND SERVICES IN THIS APP ARE PROVIDED ON AN AS IS AND AS AVAILABLE BASIS WITHOUT WARRANTY OF ANY KIND,EITHER EXPRESS OR IMPLIED,INCLUDING,BUT NOT LIMITED TO,THE IMPLIED WARRANTIES OF MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE,OR THE WARRANTY OF NON-INFRIGEMENT.WITHOUT LIMITING THE FOREGOING,WE MAKE NO WARRANTY THAN (A) THE SERVICE AND MATERIALS WILL MEET YOUR REQUIREMENTS,(B) THE SERVICE AND MATERIALS WILL BE UNNINTERRUPTED,TIMELY,SECURE,OR ERROR FREE,(C) THE RESULTS THAT MAY BE OBTAINED FROM THE USE OF THE SERVICES OR MATERIALS WILL BE EFFECTIVE,ACCURATE OR RELIABLE,OR (D) THE QUALITY OF ANY PRODUCTS,SERCVICES,OR INFORMATION PURCHASED OR OBTAINED BY YOU FROM THE SITE FROM US OR OUR AFFILIATES WILL MEET YOUR EXPECTATIONS OR BE FREE FROM MISTAKES,ERRORS OR DEFECT.",
                 // title: "Tearms and Condition",
                  // icon:,
                  //  iconColor: colors.PRIMARY,
                  onTap: () {
                    // launch(Uri.encodeFull("mailto:Questionking4010@gmail.com"));
                  },
                ),
                padding: EdgeInsets.only(top: 12.0),
              ),
            ],
          ),
        ));
  }
}

class demoCard extends StatefulWidget {
  final Color selectedcolor;
  final Color iconColor;
  final String title;
  final String body;
  final IconData icon;
  final Function onTap;

  demoCard(
      {this.selectedcolor,
      this.iconColor,
      this.title,
      this.body,
      this.onTap,
      this.icon});

  @override
  _demoCardState createState() => _demoCardState();
}

class _demoCardState extends State<demoCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Background(
        child: Card(
          elevation: 2.0,
          color: widget.selectedcolor,
          margin: EdgeInsets.all(0.0),
          child: Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // Center(
                    //   child: Text(widget.title,
                    //       textAlign: TextAlign.center,
                    //       style: TextStyle(
                    //           color: Colors.black,
                    //           fontWeight: FontWeight.bold,
                    //           fontSize: 20)),
                    // ),
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                    ),
                    Container(
                      child: Text(widget.body,
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15)
                          ),
                      width: MediaQuery.of(context).size.width-60,
                    )
                  ],
                )
              ],
            ),
            padding:
                EdgeInsets.only(top: 12.0, bottom: 12.0, left: 16.0, right: 16.0),
            decoration: BoxDecoration(
             // color: kPrimaryColor,
              borderRadius: BorderRadius.all(
                Radius.circular(5.0),
              ),
            ),
          ),
        ),
      ),
      onTap: () {
        widget.onTap();
      },
    );
  }
}
