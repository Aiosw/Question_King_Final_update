import 'dart:convert';
import 'dart:ffi';
import 'package:competitive_exam_app/Model/LedgerModel.dart';
import 'package:competitive_exam_app/Model/TransModel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Utils/Constant.dart';
import '../providers/changeMoneyProvider.dart';

class PaymentService {
  var url = Uri.parse("https://3.6.153.237/Comp_Api/transacation.php");

  var getLedgUrl = Uri.parse("https://3.6.153.237/Comp_Api/getLedgerData.php");

  var Ledgerurl = Uri.parse("https://3.6.153.237/Comp_Api/paymentDtls.php");

  var LedgerBal = Uri.parse("https://3.6.153.237/Comp_Api/getbal.php");

  var payoutUrl = Uri.parse("https://api.razorpay.com/v1/payouts");

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
      // return List<LedgerModel>();
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

  // first create account then when you will get the fund id after creating account
  //   add that fund id and account number into the second api call which is payout api
  //      then payout will be done.

  final createAccountForPayoutAPI_URL = 'https://api.razorpay.com/v1/contacts';

  Future createPayoutAccount(String name, String email, String contact) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final username = 'rzp_live_WlWBLJLqc2rpR2';
    final password = 'lkQES0im1bDpkAmplTWLUwYW';
    final basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));
    print(basicAuth);
    final res = await http.post(
      Uri.parse(createAccountForPayoutAPI_URL),
      headers: {
        "Content-Type": "application/json",
        'authorization': basicAuth,
      },
      body: jsonEncode({
        "name": name,
        "email": email,
        "contact": contact,
        "type": "customer",
        "reference_id": "Acme Contact ID 12345",
        "notes": {"notes_key_1": "", "notes_key_2": ""}
      }),
    );

    print('CONTACT API RESPONSE --- ' + jsonDecode(res.body)['id'].toString());

    prefs.setString('contact_id', jsonDecode(res.body)['id'].toString());
  }

  Future<String> createFundAccount(BuildContext context, String contact_id,
      String accountHolderName, String ifscCode, String accountNumber) async {
    print('Contact id -- ' + contact_id);
    print('NAME  -- ' + accountHolderName);
    final username = 'rzp_live_WlWBLJLqc2rpR2';
    final password = 'lkQES0im1bDpkAmplTWLUwYW';
    final basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));
    print(basicAuth);
    final res = await http.post(
      Uri.parse("https://api.razorpay.com/v1/fund_accounts"),
      headers: {
        "Content-Type": "application/json",
        'authorization': basicAuth,
      },
      body: jsonEncode({
        "contact_id": contact_id,
        "account_type": "bank_account",
        "bank_account": {
          "name": accountHolderName,
          "ifsc": ifscCode,
          "account_number": accountNumber,
        }
      }),
    );

    print('FUND API RESPONSE --- ' + res.body);

    final responseData = jsonDecode(res.body);

    // print(responseData['id'].toString());

    if (responseData['id'] != null) {
      Constants.prefs.setString('userAccountNumber', accountNumber).toString();
      Constants.prefs.setString('userAccountIFSCcode', ifscCode).toString();
      Constants.prefs
          .setString('userAccountHolderName', accountHolderName)
          .toString();
      Constants.prefs.setString('fundAccountId', responseData['id'].toString());
    } else {
      Fluttertoast.showToast(
          msg: "There is some error while creating payout.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: kPrimaryColor,
          textColor: Colors.white,
          fontSize: 16.0);
      return 'ERROR';
    }

    print(Constants.prefs.getString('fundAccountId'));

    return responseData['id'].toString();
  }

  Future<bool> createPayout(
    BuildContext context,
    String accountNumber,
    String amount,
  ) async {
    final username = 'rzp_live_WlWBLJLqc2rpR2';
    final password = 'lkQES0im1bDpkAmplTWLUwYW';
    final basicAuth =
        'Basic ' + base64.encode(utf8.encode('$username:$password'));

    final funAccountId = Constants.prefs.getString('fundAccountId');

    print('amount  --- ' + amount.toString());

    final userEnteredAmount = (int.parse(amount));
    final covertedToPaisaNumber = userEnteredAmount * 100;
    print(basicAuth);
    final res = await http.post(
      Uri.parse("https://api.razorpay.com/v1/payouts"),
      headers: {
        "Content-Type": "application/json",
        'authorization': basicAuth,
      },
      body: jsonEncode({
        "account_number": "4564564638420382",

        /// this is not user's acount number it is razorpayx account number from where the amount is going to be debited
        "fund_account_id": funAccountId,
        "amount": covertedToPaisaNumber,
        "currency": "INR",
        "mode": "IMPS",
        "purpose": "refund",
        "queue_if_low_balance": true,
        "reference_id": "Acme Transaction ID 12345",
        "narration": "Acme Corp Fund Transfer",
        "notes": {
          "notes_key_1": "Tea, Earl Grey, Hot",
          "notes_key_2": "Tea, Earl Grey… decaf."
        }
      }),
    );
    print('PAYOUT API RESPONSE --- ' + res.body);

    if (jsonDecode(res.body)['id'] != null) {
      Fluttertoast.showToast(
        msg: "Payout is generated.",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      return true;
    } else {
      Fluttertoast.showToast(
        msg: "There is some error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 10,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0,
      );
      return false;
    }
  }
}
