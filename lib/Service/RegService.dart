import 'package:flutter/material.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
//import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:competitive_exam_app/Model/RegMdl.dart';

class RegAddservice {
  var url =
      Uri.parse("https://cosmographic-craft.000webhostapp.com/RegAdd.php");

  var upurl =
      Uri.parse("https://cosmographic-craft.000webhostapp.com/RegUpdate.php");

  var proUpurl =
      Uri.parse("https://cosmographic-craft.000webhostapp.com/proUpdate.php");
// FltterToastrWidget
//   Future<String> regAdd(RegAddModel regAddModel) async {
//     print("gf sdG:" + regAddModel.userName.toString());
//     print("gf sdG:" + regAddModel.password.toString());

//     print("regAddModel toJsonAdd : " + regAddModel.toJsonAdd().toString());

//     final response = await http.post(url, body: regAddModel.toJsonAdd());
//     if (response.statusCode == 200) {
//       print("res" + response.body);
//       //  Fluttertoast.showToast(
//       //   msg: "Add Sucessfully!",
//       //   toastLength: Toast.LENGTH_SHORT,
//       //   gravity: ToastGravity.BOTTOM,
//       //   timeInSecForIosWeb: 1,
//       //   backgroundColor: Colors.red,
//       //   textColor: Colors.white,
//       //   fontSize: 16.0);
//       return response.body;
//     } else {
//       //  Fluttertoast.showToast(
//       //   msg: "Data not Saved!",
//       //   toastLength: Toast.LENGTH_SHORT,
//       //   gravity: ToastGravity.BOTTOM,
//       //   timeInSecForIosWeb: 1,
//       //   backgroundColor: Colors.red,
//       //   textColor: Colors.white,
//       //   fontSize: 16.0);
//       return "Error";
//     }
//   }

  Future<String> regProfileUpdate(RegAddModel regAddModel) async {
    final response =
        await http.post(proUpurl, body: regAddModel.toJsonProUpDate());
    if (response.statusCode == 200) {
      print("res" + response.body);
      //  Fluttertoast.showToast(
      //   msg: "update Sucessfully!",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.red,
      //   textColor: Colors.white,
      //   fontSize: 16.0);
      return response.body;
    } else {
      //  Fluttertoast.showToast(
      //   msg: "Data not Saved!",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.red,
      //   textColor: Colors.white,
      //   fontSize: 16.0);
      return "Error";
    }
  }

  Future<String> regUpdate(RegAddModel regAddModel) async {
    final response = await http.post(upurl, body: regAddModel.toJsonUpDate());
    if (response.statusCode == 200) {
      print("res" + response.body);
      //  Fluttertoast.showToast(
      //   msg: "update Sucessfully!",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.red,
      //   textColor: Colors.white,
      //   fontSize: 16.0);
      return response.body;
    } else {
      //  Fluttertoast.showToast(
      //   msg: "Data not update!",
      //   toastLength: Toast.LENGTH_SHORT,
      //   gravity: ToastGravity.BOTTOM,
      //   timeInSecForIosWeb: 1,
      //   backgroundColor: Colors.red,
      //   textColor: Colors.white,
      //   fontSize: 16.0);
      return "Error";
    }
  }
}
