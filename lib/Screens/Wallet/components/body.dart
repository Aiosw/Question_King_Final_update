// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart' as EmailSender;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:competitive_exam_app/Model/LedgerModel.dart';
import 'package:competitive_exam_app/Model/TransModel.dart';
import 'package:competitive_exam_app/Screens/Dashboard/components/backgroundHt.dart';
import 'package:competitive_exam_app/Service/PaymentService.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:competitive_exam_app/components/rounded_input_fieldAmt.dart';
import 'createPayoutContact.dart';
import 'showDialod.dart';

class Body extends StatefulWidget {
  _Body createState() => _Body();
  Body({Key? key}) : super(key: key);
}

retnull() {
  return Container();
}

class _Body extends State<Body> {
  late Razorpay _razorpay;
  String bal;
  String addmoney, name, contactNo, Email, userCd;
  TextEditingController addMoney = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<LedgerModel> ledList = <LedgerModel>[];
  LedgerDataSource ledgerDataSource;
  List<LedgerModel> LedgerLst;
  TextEditingController accountNumberController;
  TextEditingController bankIFSCController;
  TextEditingController bankHolderNameController;

  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  addledger(LedgerModel ledMdl) async {
    await PaymentService().LedgerAdd(ledMdl).then((sucess) {
      print("erro 12 : " + sucess.toString());
      getCurrentBal();
    }, onError: (error) {
      print("erro : " + error.toString());
    });
  }

  add(TransModel payMdl) async {
    // isloading = true;
    await PaymentService().PaymentAdd(payMdl).then((sucess) {
      LedgerModel ledMdl = LedgerModel(
          val: addMoney.text,
          Amt: addMoney.text,
          Desc: "1",
          userCd: userCd,
          vchDate: DateTime.now().toString(),
          vchType: "20");
      addledger(ledMdl);
      //
    });
  }

  withdraw(String amount) async {
    userCd = Constants.prefs.getString('logId');
    print("withdraw : " + userCd.toString());

    String amt = addMoney.text;

    print("Amt : " + amt);

    LedgerModel ledMdl = LedgerModel(
        val: '-' + amt,
        Amt: amt,
        Desc: "2",
        userCd: userCd,
        vchDate: DateTime.now().toString(),
        vchType: "21");
    addledger(ledMdl);
  }

  Future<Double> getCurrentBal() async {
    String loginCd = Constants.prefs.getString('logId');
    LedgerModel ledMdl = LedgerModel(userCd: loginCd);
    print(ledMdl.userCd);
    LedgerLst = await PaymentService().getLedgerBal(ledMdl);
    if (LedgerLst != null) {
      LedgerModel ledMdl = LedgerLst[0];
      setState(() {
        bal = ledMdl.val == null ? "0" : ledMdl.val;
      });
    }
  }

//
//lvuhMjMCumDiI41ifdVWxOYv     //key
//rzp_test_Z6z4Bj6ypD4eEN //test
//IYWihMWcufOKJ5
  void openCheckout() async {
    double addmoneys = double.parse(addmoney) * 100;
    name = Constants.prefs.getString("FName");
    contactNo = Constants.prefs.getString("ContactNo");
    Email = Constants.prefs.getString("Email");
    userCd = Constants.prefs.getString('logId');
    var options = {
      // 'key': 'rzp_live_EJqjpLMJTuNFxL',
      'key': 'rzp_live_WlWBLJLqc2rpR2',
      'amount': '$addmoneys',
      'name': '$name',
      'description': 'Add Money From Bank',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'timeout': 100,
      'prefill': {'contact': '$contactNo', 'email': '$Email'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, toastLength: Toast.LENGTH_SHORT);
    TransModel transMdl = TransModel(
        paymentId: response.paymentId, signature: 'SUCCESS', userCd: userCd);
    add(transMdl);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName,
        toastLength: Toast.LENGTH_SHORT);
  }

  Future getSharedPreferenceData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    print('isFundIdAvailable ==>>>>>>>>>>>>>>  ' +
        prefs.getString('fundAccountId').toString());
  }

  @override
  void initState() {
    super.initState();
    getCurrentBal();
    getSharedPreferenceData();

    accountNumberController = TextEditingController();
    bankIFSCController = TextEditingController();
    bankHolderNameController = TextEditingController();

    // name=
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<LedgerDataSource> getLedgerDataSource() async {
    var ledgerList = await getLedgerData();
    if (ledgerList != null) {
      return LedgerDataSource(ledgerList);
    }
  }

  List<GridColumn> getcoloumns() {
    return <GridColumn>[
      GridColumn(
        columnName: 'Date',
        width: 160,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            'Date',
            overflow: TextOverflow.clip,
            softWrap: true,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Particular',
        width: 160,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.centerLeft,
          child: Text(
            'Particular',
            overflow: TextOverflow.clip,
            softWrap: true,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
      GridColumn(
        columnName: 'Amount',
        // width: 100,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
          child: Text(
            'Amount',
            overflow: TextOverflow.clip,
            softWrap: true,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    ];
  }

  Future<List<LedgerModel>> getLedgerData() async {
    String loginCd = Constants.prefs.getString('logId');
    LedgerModel ledMdl = LedgerModel(userCd: loginCd);
    print(ledMdl.userCd);
    final data = await PaymentService().getLedgerDt(ledMdl);
    if (data != '"No Record Found"') {
      var decodedPrd = json.decode(data).cast<Map<String, dynamic>>();
      List<LedgerModel> ledList = await decodedPrd
          .map<LedgerModel>((json) => LedgerModel.fromjson(json))
          .toList();
      return ledList;
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(fit: StackFit.loose, children: <Widget>[
          SingleChildScrollView(
            child: Background(
              child: Form(
                key: _formKey,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 6),
                                width: MediaQuery.of(context).size.width,
                                child: RoundedInputFieldAmt(
                                  controllers: addMoney,
                                  hintText: "Add/Send Money",
                                  onChanged: (value) {
                                    addmoney = value;
                                  },
                                  validator: (String value) {
                                    return value.isEmpty
                                        ? 'Enter Add Money to Wallet'
                                        : null;
                                  },
                                ),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.01),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        if (addMoney.text.isEmpty) {
                                          Fluttertoast.showToast(
                                              msg: "Enter Add Money to Wallet",
                                              toastLength: Toast.LENGTH_SHORT,
                                              gravity: ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor: kPrimaryColor,
                                              textColor: Colors.white,
                                              fontSize: 16.0);
                                        } else {
                                          if (_formKey.currentState
                                              .validate()) {
                                            openCheckout();
                                            //  Navigator.of(context).pop();

                                            // Navigator.pushNamed(
                                            //     context, '/dashBoard');
                                          }
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: kPrimaryColor,
                                        child: Text(
                                          "Add",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: InkWell(
                                      onTap: _withdrawFunction,
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12.0),
                                        color: kPrimaryColor,
                                        child: Text("Withdraw",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Container(
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(2, 2),
                                          blurRadius: 12,
                                          color: kPrimaryColor,
                                        ),
                                      ],
                                      gradient: LinearGradient(
                                          colors: [
                                            Colors.orange[100],
                                            Colors.orangeAccent,
                                          ],
                                          begin:
                                              const FractionalOffset(0.1, 0.1),
                                          end: const FractionalOffset(1.0, 0.5),
                                          stops: [0.2, 1.0],
                                          tileMode: TileMode.clamp),
                                      borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular(20),
                                          right: Radius.circular(0)),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Text(
                                        bal == null ? "₹0.0" : "₹ $bal",
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                      ),
                      //   Text('minimum send Rupees 100/-',
                      //   textAlign: TextAlign.left,
                      //  style: TextStyle(
                      //      color: Colors.white,
                      //       fontWeight: FontWeight.bold,
                      //       fontSize: 12)),
                      Flexible(
                        child: FutureBuilder(
                          future: getLedgerDataSource(),
                          builder: (BuildContext context,
                              AsyncSnapshot<dynamic> snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return snapshot.hasData
                                  ? Container(
                                      // color: Colors.red,
                                      child: SfDataGrid(
                                          allowColumnsResizing: true,
                                          source: snapshot.data,
                                          columns: getcoloumns()),
                                    )
                                  : Center(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 100),
                                        child: Text(
                                          "No Data Found",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: .5,
                                              fontSize: 28),
                                        ),
                                      ),
                                    );
                            } else {
                              return Padding(
                                padding: const EdgeInsets.only(top: 38.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 3,
                                  ),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ]),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  bool showMoneyDebitedDialog = false;

  void _withdrawFunction() async {
    {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      final isContactAvailable = prefs.getString('contact_id');
      final isFundIdAvailable = prefs.getString('fundAccountId');

      print("isFundIdAvailable ++++++++++++++++++++++++++++++++  " +
          isFundIdAvailable.toString());

      if (addMoney.text.isEmpty) {
        Fluttertoast.showToast(
          msg: "Enter Add Money to Wallet",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 10,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0,
        );
      } else {
        if (isContactAvailable == null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return PayoutContact();
              },
            ),
          );
        } else {
          if (isFundIdAvailable == null) {
            int intAmount = int.tryParse(addMoney.text);
            var intbal = double.tryParse(bal);

            if (intAmount == null) {
              Fluttertoast.showToast(
                  msg: "Enter Valid Amount", toastLength: Toast.LENGTH_LONG);
            } else if (intAmount < 0) {
              print("Bal : " + intbal.toString());

              Fluttertoast.showToast(
                msg: "Number should not be negative:",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 10,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            } else if (intAmount > intbal) {
              print("Bal : " + intbal.toString());

              Fluttertoast.showToast(
                msg: "Not enough balance:",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 10,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0,
              );
            } else {
              _displayAddAccountInputDialog(
                context,
                addMoney.text,
                accountNumberController,
                bankIFSCController,
                bankHolderNameController,
                (String mail, String selectedPaymentMethod) async {
                  final fundId = PaymentService().createFundAccount(
                    // fund account api
                    context,
                    isContactAvailable,
                    bankHolderNameController.text,
                    bankIFSCController.text,
                    accountNumberController.text,
                  );

                  print("mail : " + addmoney);

                  String intAmount = addmoney;

                  String mailBody = "I earned " +
                      addmoney +
                      "₹ in question king. " +
                      "Please Send me that amount from " +
                      selectedPaymentMethod +
                      ".";

                  try {
                    EmailSender.Email email = EmailSender.Email(
                        body: mailBody,
                        subject: "Payout request in question king",
                        recipients: ["Questionking4010@gmail.com"],
                        isHTML: false);

                    final status = await PaymentService().createPayout(
                      context,
                      accountNumberController.text,
                      addMoney.text,
                    );

                    if (status) {
                      final ProgressDialog pr = ProgressDialog(context);
                      await pr.show();

                      await pr.hide();

                      await EmailSender.FlutterEmailSender.send(email);

                      showDialog(
                        context: context,
                        builder: (context) {
                          return ShowDialogWhenPayout(
                            intAmount: int.parse(addMoney.text),
                          );
                        },
                      );

                      await withdraw(addmoney);
                      await getCurrentBal();
                      await Future.delayed(Duration(seconds: 3));
                      // await withdraw(accountNumberController.text);
                      // await getCurrentBal();
                      Navigator.of(context).pop();
                      Fluttertoast.showToast(
                          msg: "Payout succesful, amount will be credited soon",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: kPrimaryColor,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    } else {
                      Fluttertoast.showToast(
                          msg: "Payout Failed",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: kPrimaryColor,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  } catch (e) {
                    print("error : " + e.toString());
                  }
                },
              );
            }
          } else {
            print('isFundIdAvailable _____>>>>>>>>>>>>>      ' +
                isFundIdAvailable.toString());
            if (_formKey.currentState.validate()) {
              int intAmount = int.tryParse(addmoney);
              var intbal = double.tryParse(bal);

              if (intAmount == null) {
                Fluttertoast.showToast(
                    msg: "Enter Valid Amount", toastLength: Toast.LENGTH_LONG);
              } else if (intAmount < 0) {
                print("Bal : " + intbal.toString());

                Fluttertoast.showToast(
                  msg: "Number should not be negative:",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 10,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } else if (intAmount > intbal) {
                print("Bal : " + intbal.toString());

                Fluttertoast.showToast(
                  msg: "Not enough balance:",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 10,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              } else {
                String withdrawAmount = intAmount.toString();

                if (_formKey.currentState.validate()) {
                  await showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Container(
                          height: 300,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25.0),
                              color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                  "This is the account number where money will be credited.",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "XXXX XXXX ${prefs.getString('userAccountNumber').toString().substring(prefs.getString('userAccountNumber').toString().length - 4, prefs.getString('userAccountNumber').toString().length)}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                      onTap: () async {
                                        final status =
                                            await PaymentService().createPayout(
                                          context,
                                          accountNumberController.text,
                                          withdrawAmount,
                                        );

                                        if (status == true) {
                                          await withdraw(
                                              accountNumberController.text);
                                          await getCurrentBal();
                                          setState(() {
                                            showMoneyDebitedDialog = true;
                                          });
                                        } else {
                                          setState(() {
                                            showMoneyDebitedDialog = false;
                                          });
                                        }
                                        await Future.delayed(
                                            Duration(seconds: 2));
                                        Navigator.pop(context);
                                        // Navigator.pop(context);
                                      },
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: 80,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                          color: Colors.green.shade400,
                                          child: Text(
                                            "OK",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      )),
                                  InkWell(
                                      onTap: () async {
                                        setState(() {
                                          showMoneyDebitedDialog = false;
                                        });
                                        Navigator.pop(context);
                                      },
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Container(
                                          width: 80,
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black),
                                              color: Colors.white),
                                          child: Text(
                                            "Cancel",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  if (showMoneyDebitedDialog == true) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ShowDialogWhenPayout(
                          msg:
                              'Within 2 hours your money will be credited to your bank account. ',
                          intAmount: int.parse(addMoney.text),
                        );
                      },
                    );

                    setState(() {
                      showMoneyDebitedDialog = false;
                    });
                    await Future.delayed(Duration(seconds: 5));

                    Navigator.pop(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ShowDialogWhenPayout(
                          msg: 'There is some error while creating payout.',
                          intAmount: int.parse(addMoney.text),
                        );
                      },
                    );

                    setState(() {
                      showMoneyDebitedDialog = false;
                    });
                    await Future.delayed(Duration(seconds: 2));
                    Navigator.pop(context);
                  }
                }
              }
            }
          }
        }
      }
    }
  }
}

class LedgerDataSource extends DataGridSource {
  LedgerDataSource(this.LedgerLst) {
    buildDataGridRow();
  }
  List<DataGridRow> dataGridRows;
  List<LedgerModel> LedgerLst;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(cells: [
      Container(
        child: Text(
          row.getCells()[0].value.toString(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Text(
          row.getCells()[1].value.toString(),
          overflow: TextOverflow.ellipsis,
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
      ),
      Container(
        child: Center(
          child: Text(
            row.getCells()[2].value.toString(),
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.all(8.0),
      ),
    ]);
  }

  @override
  List<DataGridRow> get rows => dataGridRows;

  void buildDataGridRow() {
    dataGridRows = LedgerLst.map<DataGridRow>((datagridRows) {
      return DataGridRow(cells: [
        DataGridCell<String>(columnName: 'Date', value: datagridRows.vchDate),
        DataGridCell<String>(columnName: 'Desc', value: datagridRows.Desc),
        DataGridCell<String>(
            columnName: 'Amount',
            value: datagridRows.vchType == "20"
                ? '(+)' + datagridRows.Amt
                : '(-)' + datagridRows.Amt),
      ]);
    }).toList(growable: false);
  }
}

Future<void> _displayAddAccountInputDialog(
  BuildContext context,
  String withdrawAmount,
  TextEditingController accountNumberController,
  TextEditingController bankIFSCController,
  TextEditingController bankHolderNameController,
  Function(String phoneNumber, String selectedPaymentMethod) mailIdCallback,
) async {
  print(withdrawAmount.toString());

  String mailId = GoogleSignIn().currentUser != null
      ? GoogleSignIn().currentUser.email
      : "";
  TextEditingController _textEditingController =
      TextEditingController(text: mailId);

  String selectedPaymentMethod = "Gpay";

  var _formKey = GlobalKey<FormState>();

  // List<DropdownMenuItem> listOfUpiApps = [
  //   DropdownMenuItem(value: "Gpay"),
  //   DropdownMenuItem(value: "Paytm"),
  //   DropdownMenuItem(value: "PhonePay")
  // ];

  List<String> listOfUpiApps = [
    "UPI_ID",
    "Bank",
  ];

  String selectedItem = "UPI_ID";

  return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Enter Details'),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Please make sure you are entering right Details',
                    style: TextStyle(
                        fontSize: 14, color: Colors.black54, letterSpacing: .6),
                  ),
                ],
              ),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    TextFormField(
                      controller: accountNumberController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          hintText: "Enter Bank Account number"),
                      validator: (String value) {
                        return value.isEmpty
                            ? 'Enter Bank account number'
                            : value.length < 5
                                ? "bank account length should be more than 5."
                                : null;
                      },
                    ),
                    TextFormField(
                      controller: bankIFSCController,
                      decoration:
                          InputDecoration(hintText: "Enter Bank IFSC code"),
                      validator: (String value) {
                        return value.isEmpty
                            ? 'Enter IFSC code'
                            : value.length < 1
                                ? "Enter proper ifsc code."
                                : null;
                      },
                    ),
                    TextFormField(
                      controller: bankHolderNameController,
                      decoration: InputDecoration(
                          hintText: "Enter Account holder name"),
                      validator: (String value) {
                        return value.isEmpty
                            ? 'Enter Account Holder name'
                            : value.length < 1
                                ? "Enter proper Account Holder name."
                                : null;
                      },
                    ),
                    SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                MaterialButton(
                  color: Colors.green,
                  textColor: Colors.white,
                  child: Text('OK'),
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      print('acc no. VALUE --- ' +
                          accountNumberController.text.toString());
                      print('IFSC VALUE --- ' +
                          bankIFSCController.text.toString());
                      print('HOLDER  VALUE --- ' +
                          bankHolderNameController.text.toString());
                      print("_formKey : " +
                          _formKey.currentState.validate().toString());

                      // mailIdCallback(
                      //     _textEditingController.value.text, selectedPaymentMethod);

                      final isContactAvailable =
                          Constants.prefs.getString('contact_id');

                      if (Constants.prefs.getString('fundAccountId') == null ||
                          Constants.prefs.getString('fundAccountId').isEmpty)
                        await PaymentService().createFundAccount(
                          // fund account api
                          context,
                          isContactAvailable,
                          bankHolderNameController.text,
                          bankIFSCController.text,
                          accountNumberController.text,
                        );

                      // await Future.dela

                      if (Constants.prefs.getString('fundAccountId') != null ||
                          Constants.prefs
                              .getString('fundAccountId')
                              .isNotEmpty) {
                        await PaymentService().createPayout(
                          context,
                          accountNumberController.text,
                          withdrawAmount,
                        );
                      }

                      Navigator.pop(context);

                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child:
                              CircularProgressIndicator(color: Colors.yellow),
                        ),
                      );

                      Future.delayed(Duration(seconds: 2));
                    }
                  },
                ),
              ],
            );
          },
        );
      });
}
