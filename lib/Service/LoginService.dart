import 'dart:convert';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:competitive_exam_app/Model/LoginModel.dart';

class Loginservice {
  var url = Uri.parse("https://3.6.153.237/Comp_Api/login.php");
  var getuserNm = Uri.parse("https://3.6.153.237/Comp_Api/userNmGet.php");
  var urlAdd = Uri.parse("https://3.6.153.237/Comp_Api/loginAdd.php");
  var urlupdate = Uri.parse("https://3.6.153.237/Comp_Api/loginUpdate.php");

  List<LoginModel> logFromComJson(String jsonstring) {
    final data = json.decode(jsonstring);
    if (data == "No Record Found") return null;
    return List<LoginModel>.from(data.map((item) => LoginModel.fromjson(item)));
  }

  Future<List> logincheck(LoginModel loginModel) async {
    print("gf sdG:" + loginModel.userName.toString());
    print("gf sdG:" + loginModel.password.toString());
//hetthummar1234@gmail.com
//103855529870981612901

    final response = await http.post(url, body: loginModel.toJsonAdd());
    debugPrint("res" + response.body.toString());

    if (response.statusCode == 200) {
      List<LoginModel> list = logFromComJson(response.body);
      //   LoginModel().res=list;
      // loginModel.result=response.body;
      return list;
    } else {
      return [];
    }
  }

  Future<List> loginGet(LoginModel loginModel) async {
    final response = await http.post(getuserNm, body: loginModel.toJsonget());
    if (response.statusCode == 200) {
      print("res" + response.body);
      List<LoginModel> list = logFromComJson(response.body);
      //   LoginModel().res=list;
      // loginModel.result=response.body;
      return list;
    } else {
      return [];
    }
  }

  Future<String> logAdd(LoginModel proAddModel) async {
    print("proAddModel.toJsonAdd() : " + proAddModel.toJsonAdd().toString());

    // final response = await http.post(urlAdd, body: proAddModel.toJsonAdd());
    final response = await Dio()
        .post("https://3.6.153.237/Comp_Api/loginAdd.php", data: {
      "userName": proAddModel.userName,
      "Password": proAddModel.password
    });

    if (response.statusCode == 200) {
      print("res" + response.data);
      // Fluttertoast.showToast(
      //     msg: "Add Sucessfully!",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: kPrimaryColor,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      return response.data;
    } else {
      // Fluttertoast.showToast(
      //     msg: "Data not Saved!",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: kPrimaryColor,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      //   Constants.prefs.setBool("Data not Saved", false);
      return "Error";
    }
  }

  Future<String> logUpdate(LoginModel proAddModel) async {
    final response =
        await http.post(urlupdate, body: proAddModel.toJsonUpdate());
    if (response.statusCode == 200) {
      print("res" + response.body);
      // Fluttertoast.showToast(
      //     msg: "Add Sucessfully!",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: kPrimaryColor,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      return response.body;
    } else {
      // Fluttertoast.showToast(
      //     msg: "Data not Saved!",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: kPrimaryColor,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      //   Constants.prefs.setBool("Data not Saved", false);
      return "Error";
    }
  }
}
