import 'dart:convert';
import 'dart:ffi';
import 'dart:ui';
import 'package:competitive_exam_app/Model/LedgerModel.dart';
import 'package:competitive_exam_app/Model/TransModel.dart';
import 'package:competitive_exam_app/Screens/Dashboard/components/backgroundHt.dart';
import 'package:competitive_exam_app/Service/PaymentService.dart';
import 'package:competitive_exam_app/Utils/Constant.dart';
import 'package:competitive_exam_app/components/rounded_input_fieldAmt.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_toastr/flutter_toastr.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart' as EmailSender;
import 'package:progress_dialog/progress_dialog.dart';

class Body extends StatefulWidget {
  _Body createState() => _Body();
  Body({Key key}) : super(key: key);
}

retnull() {
  return Container();
}

class _Body extends State<Body> {
  Razorpay _razorpay;
  String bal;
  String addmoney, name, contactNo, Email, userCd;
  TextEditingController addMoney = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<LedgerModel> ledList = <LedgerModel>[];
  LedgerDataSource ledgerDataSource;
  List<LedgerModel> LedgerLst;

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

  withdraw() async {
    userCd = Constants.prefs.getString('logId');
    print("withdraw : " + userCd.toString());

    String Amt = addMoney.text;

    print("Amt : " + Amt);

    LedgerModel ledMdl = LedgerModel(
        val: '-' + Amt,
        Amt: Amt,
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
      'key': 'rzp_live_L8cLumx40zrwKJ',
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

  @override
  void initState() {
    super.initState();
    getCurrentBal();
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
        width: 150,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
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
        width: 150,
        label: Container(
          padding: EdgeInsets.all(8),
          alignment: Alignment.center,
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
      body: Stack(fit: StackFit.expand, children: <Widget>[
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
                              margin: const EdgeInsets.symmetric(horizontal: 6),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.01),
                                MaterialButton(
                                    color: kPrimaryColor,
                                    child: Text(
                                      "Add",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      if (addMoney.text.isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: "Enter Add Money to Wallet",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 10,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      } else {
                                        if (_formKey.currentState.validate()) {
                                          openCheckout();
                                          //  Navigator.of(context).pop();

                                          Navigator.pushNamed(
                                              context, '/dashBoard');
                                        }
                                      }
                                    }),
                                SizedBox(width: 5),
                                MaterialButton(
                                    color: kPrimaryColor,
                                    child: Text("Withdraw",
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      print("MAIL 0 : " +
                                          (int.tryParse(bal).toString()));

                                      if (addMoney.text.isEmpty) {
                                        Fluttertoast.showToast(
                                          msg: "Enter Add Money to Wallet",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.CENTER,
                                          timeInSecForIosWeb: 10,
                                          backgroundColor: Colors.red,
                                          textColor: Colors.white,
                                          fontSize: 16.0,
                                        );
                                      } else {
                                        if (_formKey.currentState.validate()) {
                                          int intAmount =
                                              int.tryParse(addmoney);
                                          var intbal = double.tryParse(bal);
                                          print("MAIL 1 : " +
                                              intAmount.toString());

                                          if (intAmount == null) {
                                            Fluttertoast.showToast(
                                                msg: "Enter Valid Amount",
                                                toastLength: Toast.LENGTH_LONG);
                                          } else if (intAmount > intbal) {
                                            print("Bal : " + intbal.toString());

                                            Fluttertoast.showToast(
                                                msg: "Not enough balance:",
                                                toastLength: Toast.LENGTH_LONG);
                                          } else {
                                            print("show dialog");

                                            _displayTextInputDialog(context,
                                                (String mail,
                                                    String
                                                        selectedPaymentMethod) async {
                                              print("mail : " + addmoney);

                                              String mailBody = "I earned " +
                                                  addmoney +
                                                  "₹ in question king. " +
                                                  "Please Send me that amount from " +
                                                  selectedPaymentMethod +
                                                  ".";

                                              try {
                                                EmailSender.Email email =
                                                    EmailSender.Email(
                                                        body: mailBody,
                                                        subject:
                                                            "Payout request in question king",
                                                        recipients: [
                                                          "Questionking4010@gmail.com"
                                                        ],
                                                        isHTML: false);

                                                final ProgressDialog pr =
                                                    ProgressDialog(context);
                                                await pr.show();
                                                await withdraw();
                                                await pr.hide();

                                                await EmailSender
                                                        .FlutterEmailSender
                                                    .send(email);

                                                Navigator.of(context).pop();

                                                // Fluttertoast.showToast(
                                                //     msg:
                                                //         "Funds will be transfered in 24 hours",
                                                //     toastLength: Toast.LENGTH_LONG);
                                                FlutterToastr.show(
                                                    "Funds will be transfer within 24 hours",
                                                    context,
                                                    duration: FlutterToastr
                                                        .lengthLong,
                                                    position:
                                                        FlutterToastr.center);
                                              } catch (e) {
                                                print(
                                                    "error : " + e.toString());
                                              }
                                            });
                                          }

                                          // add();
                                        }
                                      }
                                    }),
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
                                        begin: const FractionalOffset(0.1, 0.1),
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
                                      "₹ $bal",
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
                                        source: snapshot.data,
                                        columns: getcoloumns()),
                                  )
                                : Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 100),
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
    );
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
  // TODO: implement rows
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

Future<void> _displayTextInputDialog(
    BuildContext context,
    Function(String phoneNumber, String selectedPaymentMethod)
        mailIdCallback) async {
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

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter your Upi Id'),
              SizedBox(
                height: 8,
              ),
              Text(
                'Please make sure you are entering right Upi Id',
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
                DropDownWidget((String value) {
                  print("value : " + value);
                  selectedPaymentMethod = value;
                }),
                TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(hintText: "Enter Upi Id"),
                  validator: (String value) {
                    return value.isEmpty
                        ? 'Enter Upi Id'
                        : value.length != 5
                            ? "Upi Id should be 5 chracter long"
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
              onPressed: () {
                print("_formKey : " +
                    _formKey.currentState.validate().toString());
                if (_formKey.currentState.validate()) {
                  // mailIdCallback(
                  //     _textEditingController.value.text, selectedPaymentMethod);
                }
              },
            ),
          ],
        );
      });
}

class DropDownWidget extends StatefulWidget {
  Function(String value) onChange;
  DropDownWidget(this.onChange);

  @override
  State<DropDownWidget> createState() => _DropDownWidgetState();
}

class _DropDownWidgetState extends State<DropDownWidget> {
  List<String> listOfUpiApps = [
    "UPI_ID",
    "Bank",
  ];

  String selectedItem = "UPI_ID";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: DropdownButton(
          isExpanded: true,
          value: selectedItem,
          items: listOfUpiApps.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(items),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedItem = value;
            });
            widget.onChange(value);
          }),
    );
  }
}
