import 'dart:convert';

import 'package:competitive_exam_app/Model/LedgerModel.dart';
import 'package:competitive_exam_app/Model/TransModel.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:competitive_exam_app/Model/RegMdl.dart';

class PaymentService {
  var url = Uri.parse("https://3.6.153.237/Comp_Api/transacation.php");

  var getLedgUrl =
      Uri.parse("https://3.6.153.237/Comp_Api/getLedgerData.php");

  var Ledgerurl = Uri.parse("https://3.6.153.237/Comp_Api/paymentDtls.php");

  var LedgerBal = Uri.parse("https://3.6.153.237/Comp_Api/getbal.php");

  Future<String> PaymentAdd(TransModel PaymentAddModel) async {
    final response = await http.post(url, body: PaymentAddModel.toJsonAdd());
    if (response.statusCode == 200) {
      print("res" + response.body);
      //  Fluttertoast.showToast(
      //   msg: "Add Sucessfully!",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.red,
      //   textColor: Colors.white,
      //   fontSize: 16.0);
      //  return response.body;
    } else {
      Fluttertoast.showToast(
          msg: "Data not Saved!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
      return "Error";
    }
  }

  List<LedgerModel> logFromComJson(List jsonstring) {
    if (jsonstring == null) return null;
    if (jsonstring == "Error") return null;
    return List<LedgerModel>.from(
        jsonstring.map((item) => LedgerModel.fromjson(item)));
  }

  List<LedgerModel> logFromCompuJson(String jsonstring) {
    final data = json.decode(jsonstring);
    return List<LedgerModel>.from(
        data.map((item) => LedgerModel.fromjson(item)));
  }

  Future getLedgerDt(LedgerModel ExamMdl) async {
    // final response =await Dio().post("https://bd.aiosws.com/Comp_Api/getLedgerData.php",
    // data: {"userCd":ExamMdl.userCd});
    final response = await http.post(getLedgUrl, body: ExamMdl.togetUserCd());
    //  if(response.statusCode==200)
    // {
    //   List<LedgerModel> list=logFromComJson(response.data);
    //   return list;
    // }
    // else
    // {
    //    return List<LedgerModel>();
    // }
    if (response.statusCode == 200) {
      if (response.body == "Error") return null;
      // var jsonData = json.decode(response.data);
      return response.body;
    }
  }

  Future<List> getLedgerBal(LedgerModel ExamMdl) async {
    final response = await http.post(LedgerBal, body: ExamMdl.togetUserCd());
    if (response.statusCode == 200) {
      List<LedgerModel> list = logFromCompuJson(response.body);
      return list;
    } else {
      return List<LedgerModel>();
    }
  }

  Future LedgerAdd(LedgerModel PaymentAddModel) async {
    final response =
        await http.post(Ledgerurl, body: PaymentAddModel.toJsonAdd());
    if (response.body == "success") {
      print("res" + response.body);
      // Fluttertoast.showToast(
      //     msg: "Add Sucessfully!",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.black,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      return response.body;
    } else {
      // Fluttertoast.showToast(
      //     msg: "Data not Saved!",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.red,
      //     textColor: Colors.white,
      //     fontSize: 16.0);
      return "Error";
    }
  }
}
