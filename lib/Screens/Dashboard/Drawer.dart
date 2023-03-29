import 'package:flutter/material.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:url_launcher/url_launcher.dart';

class MDrawer extends StatefulWidget {
  @override
  _MDrawerState createState() => _MDrawerState();

  //SharedPreferences perfLang=await SharedPreferences.getInstance();
}

class _MDrawerState extends State<MDrawer> {
  @override
  void initState() {
    // getprofil();
    super.initState();

    setState(() {
      //  email =Constants.prefs.getString("Email");
      id = Constants.prefs.getString("logId");
      name = Constants.prefs.getString("FName");
      profPic = Constants.prefs.getString("profileImg") == null
          ? 'default.png'
          : Constants.prefs.getString("profileImg");
    });
  }

  static const _url =
      'https://play.google.com/store/apps/details?id=com.QuestionKing';
  void _launchURL() async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';

  String email;
  String name;
  String id;
  String profPic;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: kPrimaryColor),
              currentAccountPicture: new Container(
                width: 100.0,
                height: 100.0,
                decoration: new BoxDecoration(
                  shape: BoxShape.circle,
                  image: new DecorationImage(
                    fit: BoxFit.cover,
                    image: new NetworkImage(
                      "https://3.6.153.237/Comp_Api/uploads/$profPic",
                    ),
                  ),
                ),
              ),
              accountName: Text(name == null ? "" : name,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25)),
            ),
          ),
          InkWell(
            child: ListTile(
              leading: Icon(Icons.person),
              title: Text("Profile"),
              trailing: Icon(Icons.edit),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/Profile');
            },
          ),
          InkWell(
            child: ListTile(
              leading: Icon(Icons.library_books),
              title: Text("Question Bank"),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/QBank');
            },
          ),
          InkWell(
            child: ListTile(
              leading: Icon(Icons.score),
              title: Text("Result"),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/Result');
            },
          ),
          InkWell(
            child: ListTile(
              leading: Icon(Icons.monetization_on),
              title: Text("Transacation Wallet"),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/wallet');
            },
          ),
          InkWell(
            child: ListTile(
              leading: Icon(Icons.insert_invitation),
              title: Text("Tearm & Conditions"),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/TearmCondition');
            },
          ),
          InkWell(
            child: ListTile(
              leading: Icon(Icons.rate_review),
              title: Text("Rating & Review"),
            ),
            onTap: () {
              _launchURL();
            },
          ),
          InkWell(
            child: ListTile(
              leading: Icon(Icons.connect_without_contact),
              title: Text("About us"),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/SellerProfile');
            },
          ),
        ],
      ),
    );
  }
}
