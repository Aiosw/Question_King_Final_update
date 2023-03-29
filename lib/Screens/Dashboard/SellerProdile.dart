import 'package:competitive_exam_app/Screens/Dashboard/components/background.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher.dart';

class SellerProfile extends StatefulWidget {
  SellerProfile({Key key}) : super(key: key);

  @override
  _SellerProfileState createState() => _SellerProfileState();
}

class _SellerProfileState extends State<SellerProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Contact us"),
           backgroundColor: kPrimaryColor,
        foregroundColor: kPrimaryLightColor,
        ),
        body: Container(
          child: ListView(
            children: [
              Container(
                child: demoCard(
                  selectedcolor: Colors.amber,
                  body: "Questionking4010@gmail.com",
                  title: "Email us",
                  icon: Icons.email,
                  //  iconColor: colors.PRIMARY,
                  onTap: () {
                    launch(Uri.encodeFull("mailto:Questionking4010@gmail.com"));
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
                Container(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Center(
                    child: Icon(
                      widget.icon,
                      color: widget.iconColor,
                      size: 32.0,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.title,
                      // style: TextStyle(
                      //     fontSize: TextSize.subHeader,
                      //     color: colors.BLACK_800,
                      //     fontWeight: CustomeFontWeight.medium),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 4.0),
                    ),
                    Container(
                      child: Text(
                        widget.body,
                        // style: TextStyle(
                        //   fontSize: TextSize.body,
                        //   color: colors.BLACK_600,
                        // ),
                      ),
                      width: MediaQuery.of(context).size.width - 108.0,
                    )
                  ],
                )
              ],
            ),
            padding:
                EdgeInsets.only(top: 12.0, bottom: 12.0, left: 16.0, right: 16.0),
            decoration: BoxDecoration(
              color: widget.selectedcolor,
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
