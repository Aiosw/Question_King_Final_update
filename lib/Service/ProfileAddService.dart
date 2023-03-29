import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:competitive_exam_app/Model/ProductMdl.dart';
import 'package:competitive_exam_app/Model/ProfileAddMdl.dart';
import 'package:competitive_exam_app/Model/ProfileContactUs.dart';
import 'package:competitive_exam_app/Model/ProfileMdl.dart';

class Profileservice {
  var url = Uri.parse(
      "https://3.6.153.237/Comp_Api/ProfileAdd.php"); // https://3.6.153.237/Comp_Api/ProfileAdd.php

  var urlDelete =
      Uri.parse("https://3.6.153.237/Comp_Api/ProfileImgDelete.php");

  var geturl = Uri.parse("https://3.6.153.237/Comp_Api/getProfile.php");

  var AddProduct = Uri.parse("https://3.6.153.237/Comp_Api/AddProduct.php");

  var getContacturl =
      Uri.parse("https://3.6.153.237/Comp_Api/getprofileContactUs.php");

  var getProAddurl =
      Uri.parse("https://3.6.153.237/Comp_Api/getProfileAdd.php");

  var updateurl = Uri.parse("https://3.6.153.237/Comp_Api/ProfileUpdate.php");

  var bnkurl = Uri.parse("https://3.6.153.237/Comp_Api/BnkUpdate.php");

  var proAddurl =
      Uri.parse("https://3.6.153.237/Comp_Api/ProfileAddressAdd.php");

  var proContactAddurl =
      Uri.parse("https://3.6.153.237/Comp_Api/profileContactUsAdd.php");

  var proUpurl =
      Uri.parse("https://3.6.153.237/Comp_Api/ProfileAddressUpdate.php");

  List<ProfileModel> logFromComJson(String list) {
    print("list ------  " + list.toString());
    final data = json.decode(list);
    if (data == null) return null;
    if (data == "No Record Found") return null;
    return List<ProfileModel>.from(
        data.map((item) => ProfileModel.fromjson(item)));
  }

  List<ProfileCountactUs> ProfContactComJson(String list) {
    final data = json.decode(list);
    if (data == null) return null;
    if (data == "Error") return null;
    return List<ProfileCountactUs>.from(
        data.map((item) => ProfileCountactUs.fromjson(item)));
  }

  List<ProfileAddMdl> logFromProAddComJson(String list) {
    final data = json.decode(list);
    if (data == null) return null;
    if (data == "Error") return null;
    return List<ProfileAddMdl>.from(
        data.map((item) => ProfileAddMdl.fromjson(item)));
  }

  List<ProductMdl> ProductGetJson(List list) {
    if (list == null) return null;
    if (list == "Error") return null;
    return List<ProductMdl>.from(list.map((item) => ProductMdl.fromjson(item)));
  }

  Future<List> proGet(ProfileModel proAddModel) async {
    print("***    proAddModel" + proAddModel.toString());
    var response = await http.post(geturl, body: proAddModel.toJsonProFeth());
    print("$response");
    if (response.statusCode == 200) {
      print("RESPONSE BODY  ----     " + response.body.toString());
      List<ProfileModel> list = logFromComJson(response.body);
      return list;
    } else {
      return List<ProfileModel>();
    }
  }

  Future<List> proContactGet(ProfileCountactUs proAddModel) async {
    var response =
        await http.post(getContacturl, body: proAddModel.toJsonProFeth());
    if (response.statusCode == 200) {
      List<ProfileCountactUs> list = ProfContactComJson(response.body);
      return list;
    } else {
      return List<ProfileCountactUs>();
    }
  }

  Future<List> proAddGet(ProfileAddMdl proAddModel) async {
    var response =
        await http.post(getProAddurl, body: proAddModel.toJsonProAddFeth());
    if (response.statusCode == 200) {
      List<ProfileAddMdl> list = logFromProAddComJson(response.body);
      return list;
    } else {
      return List<ProfileModel>();
    }
  }

  Future<List> productGetMaxNo(ProductMdl proAddModel) async {
    var response = await Dio().post(
        "https://3.6.153.237/Api/getMaxProductNo.php",
        data: {"userCd": proAddModel.userCd});
    if (response.statusCode == 200) {
      List<ProductMdl> list = ProductGetJson(response.data);
      return list;
    } else {
      return List<ProductMdl>();
    }
  }

//productAdd
  Future<String> productAdd(ProductMdl proAddModel) async {
    final response = await http.post(AddProduct, body: proAddModel.toJsonAdd());
    if (response.statusCode == 200) {
      print("res" + response.body);
      toastPass("Add Sucessfully!");
      return response.body;
    } else {
      toastFaill("Data not Update!");
      return "Error";
    }
  }

  Future<String> proAdd(ProfileModel proAddModel) async {
    print("MODEL RESPONSE " + proAddModel.toString());
    final response = await http.post(
      url,
      body: proAddModel.toJsonAdd(),
    );
    if (response.statusCode == 200) {
      print("res" + response.body);
      toastPass("Add Sucessfully!");
      return response.body;
    } else {
      toastFaill("Data not Update!");
      return "Error";
    }
  }

  Future<String> proPicDelete(ProfileModel proAddModel) async {
    final response =
        await http.post(urlDelete, body: proAddModel.toJsonProFeth());
    if (response.statusCode == 200) {
      print("res" + response.body);
      toastPass("update Sucessfully!");
      return response.body;
    } else {
      toastFaill("Data not Update!");
      return "Error";
    }
  }

  Future<String> proUpdate(ProfileModel proAddModel) async {
    final response =
        await http.post(updateurl, body: proAddModel.toJsonUpdate());
    if (response.statusCode == 200) {
      print("res" + response.body);
      toastPass("update Sucessfully!");
      return response.body;
    } else {
      toastFaill("Data not Update!");
      return "Error";
    }
  }

  Future<String> BnkUpdate(ProfileModel proAddModel) async {
    final response =
        await http.post(bnkurl, body: proAddModel.toJsonBnkUpdate());
    if (response.statusCode == 200) {
      print("res" + response.body);
      toastPass("update Sucessfully!");
      return response.body;
    } else {
      toastFaill("Data not Update!");
      return "Error";
    }
  }

  toastPass(String messge) {
    // Fluttertoast.showToast(
    //     msg: messge,
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Color(0xFF006064),
    //     textColor: Colors.white,
    //     fontSize: 16.0);
  }

  toastFaill(String messge) {
    // Fluttertoast.showToast(
    //     msg: messge,
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Color(0xFF006064),
    //     textColor: Colors.white,
    //     fontSize: 16.0);
  }

  Future<String> proAddressAdd(ProfileAddMdl proAddModel) async {
    final response = await http.post(proAddurl, body: proAddModel.toJsonAdd());
    if (response.statusCode == 200) {
      print("res" + response.body);
      toastPass("Add Sucessfully!");
      return response.body;
    } else {
      toastFaill("Data not Saved!");
      return "Error";
    }
  }

  Future<String> proContactAdd(ProfileCountactUs proAddModel) async {
    final response =
        await http.post(proContactAddurl, body: proAddModel.toJsonFeth());
    if (response.statusCode == 200) {
      print("res" + response.body);
      toastPass("Add Sucessfully!");
      return response.body;
    } else {
      toastFaill("Data not Saved!");
      return "Error";
    }
  }

  Future<String> proAddressUpdate(ProfileAddMdl proAddModel) async {
    final response =
        await http.post(proUpurl, body: proAddModel.toJsonUpdate());
    if (response.statusCode == 200) {
      print("res" + response.body);
      toastPass("update Sucessfully!");
      return response.body;
    } else {
      toastFaill("Data not Saved!");
      return "Error";
    }
  }
}
