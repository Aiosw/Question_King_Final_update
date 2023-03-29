import 'dart:convert';
import 'package:competitive_exam_app/Model/ExamMdl.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class Examservice {
  var geturl = Uri.parse("https://3.6.153.237/Comp_Api/getQuestions.php");

  var getRslturl = Uri.parse("https://3.6.153.237/Comp_Api/checkResult.php");

  var ExResultAddurl = Uri.parse("https://3.6.153.237/Comp_Api/examAdd.php");

  var rst = Uri.parse("https://3.6.153.237/Comp_Api/getResult.php");

  var rstTop = Uri.parse("https://3.6.153.237/Comp_Api/getTopResult.php");

  var rstParti = Uri.parse("https://3.6.153.237/Comp_Api/getParticipate.php");

  var Setrst = Uri.parse("https://3.6.153.237/Comp_Api/setResult.php");

  List<ExamModel> logFromComJson(String jsonstring) {
    final data = json.decode(jsonstring);
    // for(int i = 0 ; i<data)
    if (data == "No Record Found.") return null;
    return List<ExamModel>.from(data.map((item) => ExamModel.fromjson(item)));
  }

  Future<String> examAdd(ExamModel regAddModel) async {
    final response =
        await http.post(ExResultAddurl, body: regAddModel.toJsonAdd());
    print(response);
    if (response.statusCode == 200) {
      print("res" + response.body);
      Fluttertoast.showToast(
          msg: "Exam Complete Sucessfully!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return response.body;
    } else {
      Fluttertoast.showToast(
          msg: "Exam not Complete!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return "Error";
    }
  }

  Future getQuestion(ExamModel ExamMdl) async {
    final response = await http.post(geturl, body: ExamMdl.toGet());
    if (response.statusCode == 200) {
      List<ExamModel> list = logFromComJson(response.body);
      return list;
    } else {
      return List<ExamModel>();
    }
  }

 

  Future getAnsQuestion(ExamModel ExamMdl) async {
    final response = await http.post(geturl, body: ExamMdl.toGet());
    if (response.statusCode == 200) {
      if (response != null) {
        print("${response.body}");
        return response.body;
      }
    }
  }

  Future getResult(ExamModel ExamMdl) async {
    print("response : " + "send");

    try {

    print("response 99 : " +  ExamMdl.toJsonFeth().toString());

      final response = await http.post(rst, body: ExamMdl.toJsonFeth());

      print("response : " + response.body.toString());
      print("response : " + response.statusCode.toString());

      if (response.statusCode == 200) {
        if (response.body == "Error") return null;
        return response.body;
      }
    } catch (error) {
      print("error : " + error.toString());
    }
  }

  Future getTop3Result(ExamModel exMdl) async {
    final response = await http.post(rstTop, body: exMdl.toSet());
    if (response.statusCode == 200) {
      if (response.body == "Error") return null;
      var jsonData = response.body;
      return jsonData;
    }
  }

  Future getParticipate(ExamModel exMdl) async {
    final response = await http.post(rstParti, body: exMdl.togetParti());
    if (response.statusCode == 200) {
      if (response.body == "Error") return null;
      return response.body;
    }
  }

  Future getResults(ExamModel exMd) async {
    final response = await http.post(getRslturl, body: exMd.toSet());
    print("response response : " + response.body.toString());
    if (response.statusCode == 200) {
      if (response.body == "Error") return null;
      final data = json.decode(response.body);
      if (data == "No Record Found") {
        return data;
      } else {
        return null;
      }
    }
  }

  Future setResult(ExamModel exMd) async {
    final response = await http.post(Setrst, body: exMd.toSet());
    print("response.bod 0 : " + response.body.toString());
    print("response.bod 1 : " + response.statusCode.toString());

    if (response.statusCode == 200) {
      if (response.body == "Error") return null;
      return response.body;
    }
  }
}
